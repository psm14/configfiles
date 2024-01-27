{ pkgs, ... }:
let
  inherit (pkgs) stdenv;
in
{
  programs.vscode-brew = {
    settings = {
      "workbench.colorTheme" = "City Lights";
      "workbench.preferredDarkColorTheme" = "City Lights";
      "window.autoDetectColorScheme" = false;
    };
    extensions = [
      "yummygum.city-lights-theme"
    ];
  };

  programs.zsh.sessionVariables = {
    BAT_THEME = "Nord";
  };
}
