{ pkgs, lib, ... }:
let
  secretive = pkgs.stdenv.mkDerivation {
    name = "secretive";
    version = "2.2.0";

    src = pkgs.fetchzip {
      url = "https://github.com/maxgoedjen/secretive/releases/download/v2.2.0/Secretive.zip";
      hash = "sha256-/sJvzPfj2sR87EXCQcPDeF/LMOe3bzqATTKDKG80jnE=";
    };

    phases = [ "unpackPhase" "installPhase" ];
    installPhase = ''
      mkdir -p $out/Applications
      cp -r $src $out/Applications/Secretive.app
    '';
  };
in
{
  home = {
    activation = {
      alias-secretive = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD rm -f $HOME/Applications/Secretive.app
        $DRY_RUN_CMD osascript -e "tell app \"Finder\"" -e "make new alias file at POSIX file \"$HOME/Applications\" to POSIX file \"${secretive}/Applications/Secretive.app\"" -e "set name of result to \"Secretive.app\"" -e "end tell"
      '';
    };
  };


  programs.zsh.sessionVariables = {
    SSH_AUTH_SOCK = "$HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
  };
}
