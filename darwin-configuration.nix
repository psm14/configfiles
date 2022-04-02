{ config, lib, pkgs, ... }:

{
  imports = [ <home-manager/nix-darwin> ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
      rustup
    ];
  
  nix.package = pkgs.nixFlakes; # NOTE: EXPERIMENTAL.

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

  programs.zsh = {
    enable = true;

    # Using oh-my-zsh for theming instead
    promptInit = "";
  };

  homebrew = {
    enable = true;
    autoUpdate = true;
    cleanup = "zap";

    taps = [];
    casks = [];
  };

  users.users.patrickmclaughlin = {
    name = "pat";
    home = "/Users/pat";
  };
  home-manager.users.pat = { config, pkgs, ... }: {
    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "21.11";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    home.packages = with pkgs; [
      comma
      bat
      direnv
      gitAndTools.delta
      neovim
    ];

    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      enableSyntaxHighlighting = true;
      shellAliases = {
        vim = "nvim";
        ls = "ls --color=auto";
	cat = "bat -pp";
      };

      oh-my-zsh = {
        enable = true;
	plugins = [ "git" ];
	theme = "gallois";
      };

      initExtra = ''
        export DIRENV_LOG_FORMAT=
        export EDITOR=nvim
      '';

      initExtraBeforeCompInit = ''
        eval "$(/opt/homebrew/bin/brew shellenv)"
      '';
    };

    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
