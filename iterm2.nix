{ pkgs, ... }:
let
  iterm2-config = pkgs.stdenv.mkDerivation {
    name = "iterm2-config";
    src = ./com.googlecode.iterm2.plist;
    phases = ["installPhase"];
    installPhase = ''
      cp $src $out
    '';
  };
  home-module = { pkgs, lib, ... }: {
    config = {
      home.activation.config-iterm = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD cp -f ${iterm2-config} $HOME/Library/Preferences/com.googlecode.iterm2.plist
        $DRY_RUN_CMD chmod +w $HOME/Library/Preferences/com.googlecode.iterm2.plist
      '';
    };
  };
in
{
  config = {
    homebrew = {
      enable = true;

      onActivation = {
        autoUpdate = true;
        cleanup = "zap";
        upgrade = true;
      };

      taps = [
        "homebrew/bundle"
      ];

      casks = [
        "iterm2-beta"
      ];
    };

    home-manager.sharedModules = [
      home-module
    ];
  };
}
