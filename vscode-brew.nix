{ pkgs, lib, ... }:
let
  vscode-brew = pkgs.stdenv.mkDerivation {
    name = "vscode-brew";
    pname = "vscode";

    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      cd $out/bin
      ln -s /opt/homebrew/bin/code
    '';
  };
  make-settings-json = vscode-settings: pkgs.runCommand "vscode-settings" { } ''
    cat << EOF | ${pkgs.jq}/bin/jq . > $out
    ${builtins.toJSON vscode-settings}
    EOF
  '';
  home-module = { config, pkgs, lib, ... }: {
    options =
      let
        inherit (lib) mkOption options types flatten;
      in
      {
        programs.vscode-brew = {
          extensions = mkOption {
            type = types.listOf types.string;
            default = [ ];
            description = ''
              Extensions to install
            '';
          };

          settings = mkOption {
            type = types.attrs;
            default = { };
            description = ''
              Settings to write
            '';
          };
        };
      };
    config =
      let
        inherit (config.programs.vscode-brew) extensions settings;
        settings-json = make-settings-json settings;
        settings-dir =
          if pkgs.stdenv.hostPlatform.isDarwin then
            "$HOME/Library/Application Support/Code/User"
          else
            "${config.xdg.configHome}/Code/User";
      in
      {
        home.packages = [ vscode-brew ];

        home.activation.install-extensions =
          let
            install-cmd = lib.concatMapStrings (ext: "$DRY_RUN_CMD ${vscode-brew}/bin/code --install-extension ${ext}\n") extensions;
          in
          lib.hm.dag.entryAfter [ "writeBoundary" ] install-cmd;

        home.activation.copy-settings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          cp -f "${settings-json}" "${settings-dir}/settings.json"
        '';

        programs.zsh.shellAliases = {
          vscode-settings-diff = "${pkgs.delta}/bin/delta  \"${settings-json}\" \"${settings-dir}/settings.json\"";
        };
      };
  };
in
{
  config = {
    homebrew = {
      enable = true;
      autoUpdate = true;
      cleanup = "zap";

      taps = [
        "homebrew/bundle"
        "homebrew/cask"
        "homebrew/cask-versions"
        "homebrew/core"
      ];

      casks = [
        "visual-studio-code"
      ];
    };

    home-manager.sharedModules = [
      home-module
    ];
  };
}
