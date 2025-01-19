{
  description = "A flake that outputs a development environment with zsh, direnv, and starship";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: 
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in {
      defaultPackage = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
          pkgs.stdenv.mkDerivation {
            name = "my-shell";
            buildInputs = with pkgs; [
              zsh
              direnv
              starship
              neovim
              bat
              lsd
              aider-chat
            ];
            phases = ["installPhase"];
            installPhase = ''
              mkdir -p $out/home/user
              cat <<EOF > $out/home/user/.zshrc
              export HISTFILE=~/.zsh_history

              export XDG_CONFIG_HOME=$out/home/user/.config
              export XDG_DATA_HOME=~/.local/share/nvim
              export XDG_STATE_HOME=~/.local/state/nvim

              export STARSHIP_CONFIG=$out/home/user/.config/starship.toml
              eval "\$(starship init zsh)"
              eval "\$(direnv hook zsh)"

              export EDITOR=${pkgs.neovim}/bin/nvim
              alias vim="${pkgs.neovim}/bin/nvim"

              export PAGER=${pkgs.bat}/bin/bat
              export MANPAGER="sh -c 'col -b | ${pkgs.bat}/bin/bat -l man'"
              export BAT_THEME="ansi"

              alias cat="${pkgs.bat}/bin/bat -pp"
              alias ls="${pkgs.lsd}/bin/lsd"

              export PATH=${pkgs.direnv}/bin:${pkgs.bat}/bin:${pkgs.neovim}/bin:${pkgs.lsd}/bin:${pkgs.aider-chat}/bin:\$PATH
              EOF


              mkdir -p $out/home/user/.config
              cp -r ${./starship.toml} $out/home/user/.config/starship.toml
              cp -r ${./nvim} $out/home/user/.config/nvim

              mkdir -p $out/bin
              cat <<EOF > $out/bin/my-shell
              #!${pkgs.stdenv.shell}
              export ZDOTDIR=$out/home/user
              exec zsh
              EOF
              chmod +x $out/bin/my-shell
            '';
          }
      );
    };
}
