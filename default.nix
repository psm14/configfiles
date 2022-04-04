{ nixpkgs ? <nixpkgs>
, pkgs ? import nixpkgs { inherit system; }
, lib ? pkgs.lib,
 }: {
   home = import "./home.nix" { inherit pkgs; };
   darwin = import "./darwin-configuration.nix" { inherit pkgs lib; };
}