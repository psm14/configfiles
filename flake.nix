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
    homeConfigurations = {
      generic = home-manager.lib.homeManagerConfiguration {
        system = "x86_64-linux";
        homeDirectory = "/home/user";
        username = "user";

        modules = [
          ./shellConfig.nix
          {
            programs.home-manager.enable = true;
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
            ./vscode.nix
            ./iterm2.nix
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.pat = {
                imports = [
                  ./shellConfig.nix
                ];
              };
            }
          ];
        };
    };
  };
}
