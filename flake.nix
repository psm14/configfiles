{
  description = "A flake that outputs a development environment with zsh, direnv, and starship";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: 
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      starshipToml = builtins.readFile ./starship.toml;
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
            ];
            phases = ["installPhase"];
            installPhase = ''
              mkdir -p $out/home/user
              cat <<EOF > $out/home/user/.zshrc
              export HISTFILE=~/.zsh_history

              eval "\$(STARSHIP_CONFIG=$out/home/user/.config starship init zsh)"
              eval "\$(direnv hook zsh)"

              export EDITOR=${pkgs.neovim}/bin/nvim
              alias vim=${pkgs.neovim}/bin/nvim
              EOF

              mkdir -p $out/home/user/.config
              cat <<EOF > $out/home/user/.config/starship.toml
              ${starshipToml}
              EOF

              mkdir -p $out/bin
              cat <<EOF > $out/bin/my-shell
              #!${pkgs.stdenv.shell}
              export ZDOTDIR=$out/home/user
              cd $out/home/user
              exec zsh
              EOF
              chmod +x $out/bin/my-shell
            '';
          }
      );
    };
}
