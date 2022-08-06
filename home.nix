{ pkgs, vscode ? false }: {
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
    ripgrep
    tmux
    most
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
      export PAGER=most
    '';
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.vscode = if vscode == true then import ./vscode/default.nix { inherit (pkgs) rnix-lsp nixpkgs-fmt; } else { };
}
