{ nixpkgs ? <nixpkgs>
, pkgs ? import nixpkgs
, lib ? pkgs.lib
 }: {
   home = import "./home.nix" { inherit pkgs; };
   darwin = import "./darwin-configuration.nix" { inherit pkgs lib; };
}