{
  description = "charles' pc configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: let
    inherit (builtins) readDir;
    hosts = builtins.attrNames (readDir ./hosts);

    mkSystem = hostname: nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs hostname; };
      modules = [
        ./hosts/${hostname}/configuration.nix
        inputs.home-manager.nixosModules.default
      ];
    };
  in {
    nixosConfigurations = builtins.listToAttrs (map
      (hostname: {
        name = hostname;
        value = mkSystem hostname;
      })
      hosts);
  };
}
