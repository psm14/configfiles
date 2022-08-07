{ pkgs, ... }:
let
  inherit (pkgs) stdenv;
  light-dark = light: dark: if stdenv.isDarwin then "\$(defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo ${dark} || ${light})" else dark;
  bat-theme = light-dark "gruvbox-light" "gruvbox-dark";
in
{
  programs.vscode-brew = {
    settings = {
      "workbench.colorTheme" = "Gruvbox Dark Hard";
      "workbench.preferredDarkColorTheme" = "Gruvbox Dark Hard";
      "workbench.preferredLightColorTheme" = "Gruvbox Light Medium";
      "window.autoDetectColorScheme" = true;
    };
    extensions = [
      "jdinhlife.gruvbox"
    ];
  };

  programs.zsh.initExtra = ''
    export BAT_THEME=${bat-theme};
  '';
}
