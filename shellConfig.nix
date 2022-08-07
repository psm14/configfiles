{ pkgs, ... }:
let
  inherit (pkgs) stdenv;
  bat-theme = if stdenv.isDarwin then "\$(defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo gruvbox-dark || echo gruvbox-light)" else "gruvbox-dark";
  delta-theme = if stdenv.isDarwin then "\$(defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo --dark || --light)" else "--dark";
  delta-cmd = "${pkgs.gitAndTools.delta}/bin/delta ${delta-theme}";
in
{
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";

  home.packages = with pkgs; [
    comma
    bat
    direnv
    gitAndTools.delta
    neovim
    ripgrep
    tmux
  ];

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    shellAliases = {
      vim = "nvim";
      ls = "ls --color=auto";
      cat = "bat --theme=${bat-theme} -pp";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "gallois";
    };

    initExtra = ''
      export DIRENV_LOG_FORMAT=
      export EDITOR=nvim
      export PAGER=bat
      export BAT_THEME=${bat-theme}
      export BAT_STYLE=plain
    '';
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Patrick McLaughlin";
    userEmail = "me@patmclaughl.in";

    extraConfig = {
      pull = {
        ff = "only";
      };
      init = {
        defaultBranch = "master";
      };
      core = {
        pager = delta-cmd;
      };
      interactive = {
        diffFilter = "${delta-cmd} --color-only --features=interactive";
      };
      delta = {
        navigate = "true";
      };
      merge = {
        conflictStyle = "diff3";
      };
    };

    ignores = [
      ".DS_Store"
      ".direnv"
    ];
  };

  programs.nix-index = {
    enable = true;
  };
}
