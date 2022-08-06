# Fake derivation that symlinks to the homebrew vscode
{ pkgs }: pkgs.stdenv.mkDerivation {
  name = "vscode-brew";
  pname = "vscode";

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cd $out/bin
    ln -s /opt/homebrew/bin/code
  '';
}
