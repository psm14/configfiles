{
  description = "Pat's Nix configs";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    darwin = {
      # Fork with mouse scaling
      url = "github:psm14/nix-darwin/mouse-scaling";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, darwin, ... }: {
    darwinConfigurations = {
      "PatBook-Air" = let
        system = "aarch64-darwin";
        pkgs = import nixpkgs { inherit system; };
      in darwin.lib.darwinSystem {
        inherit system;
        modules = [
          ./configuration.nix
          ./vscode/default.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.pat = import ./home.nix { inherit pkgs; };

            users.users.patrickmclaughlin = {
              name = "pat";
              home = "/Users/pat";
            };
          }
        ];
      };
    };
  };
}
