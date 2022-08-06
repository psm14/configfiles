{ lib, pkgs, ... }:
let
  inherit (pkgs) stdenv;
  # Fake derivation that symlinks to the homebrew vscode
  vscode = stdenv.mkDerivation {
    name = "vscode-brew";
    pname = "vscode";

    phases = [ "installPhase" ];

    installPhase = ''
      mkdir -p $out/bin
      cd $out/bin
      ln -s /opt/homebrew/bin/code
    '';
  };
in
{
  nixpkgs.config = {
    allowUnfree = true;
  };

  environment = {
    systemPackages = [
      pkgs.colima
      pkgs.docker
      vscode
    ];

    shells = [ pkgs.zsh ];
    loginShell = "${pkgs.zsh}/bin/zsh -l";

    variables = {
      SHELL = "${pkgs.zsh}/bin/zsh";
      LANG = "en_US.UTF-8";
    };
  };

  nix.package = pkgs.nixFlakes;

  nix.useSandbox = true;
  nix.sandboxPaths = [ "/private/tmp" "/private/var/tmp" "/usr/bin/env" ];

  programs.nix-index.enable = true;

  nix.extraOptions = ''
    keep-derivations = true
    keep-outputs = true
    experimental-features = nix-command flakes
  '';

  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 12;
  system.defaults.NSGlobalDomain.KeyRepeat = 1;
  system.defaults.NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;

  # TODO: Add support for this
  system.defaults.".GlobalPreferences"."com.apple.mouse.scaling" = "-1.0";

  system.defaults.dock.autohide = true;
  system.defaults.finder.AppleShowAllExtensions = true;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  fonts = {
    fontDir.enable = true;
    fonts = [
      pkgs.hack-font
    ];
  };

  programs.zsh = {
    enable = true;

    # Using oh-my-zsh for theming instead
    promptInit = "";
  };

  homebrew = {
    enable = true;
    autoUpdate = true;
    cleanup = "zap";

    brews = [
      "openjdk@11"
    ];

    taps = [
      "homebrew/bundle"
      "homebrew/cask"
      "homebrew/cask-versions"
      "homebrew/core"
    ];
    casks = [
      "visual-studio-code"
      "iterm2-beta"
    ];
  };

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
