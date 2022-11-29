{
  description = "Gabe's Nix-darwin Home";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , nixpkgs-unstable
    , darwin
    , home-manager
    , nur
    , sops-nix
    , ...
    }:
    let
      user = "gabehoban";
      host = "macbook";
      system = "aarch64-darwin";
      gitUser = "gabehoban";
      gitEmail = "hello@gabehoban.com";
      gpgKey = "98AD3B0EEEFB665D";
    in
    {
      darwinConfigurations.macbook = darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit user host gitUser gitEmail; };
        modules = [
          ./hosts/laptop/darwin-configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit user gitUser gitEmail; };
            home-manager.users.${user} = import ./hosts/laptop/home.nix;
          }
          {
            nixpkgs.overlays = with inputs; [
              nur.overlay
              sops-nix.nixosModules.sops
            ];
          }
        ];
      };
    };
}