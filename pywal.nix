{ pkgs, ... }:
let
  inherit (pkgs) python3 stdenv;
  light-dark = light: dark: if stdenv.isDarwin then "\$(defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo ${dark} || ${light})" else dark;
  bat-theme = light-dark "ansi-light" "ansi-dark";
  colorz = python3.pkgs.buildPythonPackage {
    inherit (pkgs.colorz) name version src propagatedBuildInputs meta;
  };
  pywal-mac-fix = pkgs.pywal.overrideAttrs (orig: {
    version = "9999";

    propagatedBuildInputs = [
      colorz
    ];

    src = pkgs.fetchgit {
      url = "https://github.com/dylanaraps/pywal.git";
      rev = "236aa48e741ff8d65c4c3826db2813bf2ee6f352";
      hash = "sha256-La6ErjbGcUbk0D2G1eriu02xei3Ki9bjNme44g4jAF0=";
    };

    patches = [
      ./pywal-backends.patch
    ];
  });
in
{
  home.packages = [
    pywal-mac-fix
  ];

  programs.vscode-brew = {
    settings = {
      "workbench.colorTheme" = "Wal Bordered";
    };
    extensions = [
      "dlasagno.wal-theme"
    ];
  };

  programs.zsh = {
    initExtra = ''
      if [ "$TERM_PROGRAM" = "iTerm.app" ]; then
        cat /Users/pat/.cache/wal/sequences
      fi
    '';

    sessionVariables = {
      BAT_THEME = bat-theme;
    };
  };
}
