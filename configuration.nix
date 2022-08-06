{ lib, pkgs, ... }: {
  imports = [
    # For the mouse scaling setting
    ./darwinExtensions.nix
  ];

  config = {
    nixpkgs.config = {
      allowUnfree = true;
    };

    environment = {
      systemPackages = [
        pkgs.colima
        pkgs.docker
      ];

      shells = [ pkgs.zsh ];
      loginShell = "${pkgs.zsh}/bin/zsh -l";

      variables = {
        SHELL = "${pkgs.zsh}/bin/zsh";
        LANG = "en_US.UTF-8";
      };
    };

    nix.package = pkgs.nixUnstable;

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

    # Use a custom configuration.nix location.
    # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
    # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

    # Auto upgrade nix package and the daemon service.
    services.nix-daemon.enable = true;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    system.stateVersion = 4;
  };
}
