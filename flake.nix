{
  description = "Pat's Nix configs";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, darwin, ... }: {
    homeModules = {
      shell = ./shellConfig.nix;
      vscode = ./vscode.nix;
      gruvbox = ./gruvbox.nix;
      pywal = ./pywal.nix;
      secretive = ./secretive.nix;
    };

    darwinModules = {
      vscode-brew = ./vscode-brew.nix;
      iterm2 = ./iterm2.nix;
    };

    homeConfigurations = {
      generic = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { system = "x86_64-linux"; };

        modules = [
          self.homeModules.shell
          {
            home.username = "user";
            home.homeDirectory = "/home/user";
            programs.home-manager.enable = true;
            programs.zsh.initExtra = ''
              export NIX_PATH="nixpkgs=${nixpkgs}:$NIX_PATH"
            '';
            programs.git = {
              userName = "Patrick McLaughlin";
              userEmail = "me@patmclaughl.in";
            };
          }
        ];
      };
    };

    darwinConfigurations = {
      "PatBook-Air" =
        darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            home-manager.darwinModules.home-manager
            ./configuration.nix
            self.darwinModules.vscode-brew
            self.darwinModules.iterm2
            {
              # Let old commands use the pinned nixpkgs
              nix.nixPath = {
                nixpkgs = "${nixpkgs}";
                darwin = "${darwin}";
              };

              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.pat = {
                imports = [
                  self.homeModules.shell
                  self.homeModules.vscode
                  self.homeModules.gruvbox
                  self.homeModules.secretive
                  {
                    home.file.".ssh/id_secretive.pub".text = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBE4bbGajkViyqlWeD8lG24Mrn77wrjvH3Wn4uwdiEmMAgLgqy4kTbJuHhRNo8NLmwzkUQiLQ0orNcTuSJRen0nI= me@patmclaughl.in";

                    programs.git = {
                      userName = "Patrick McLaughlin";
                      userEmail = "me@patmclaughl.in";
                      extraConfig = {
                        user.signingKey = "/Users/pat/.ssh/id_secretive.pub";
                        gpg.format = "ssh";
                        commit.gpgsign = "true";
                      };
                    };
                  }
                ];
              };
            }
          ];
        };
    };
  };
}
