{
  description = "Gabe's Nix-darwin Home";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";
  };

  outputs =
    { self
    , nixpkgs
    , darwin
    , home-manager
    , nur
    , ...
    }@inputs:
    let
      user = "gabehoban";
      host = "macbook";
      system = "aarch64-darwin";
      gitUser = "gabehoban";
      gitEmail = "hello@gabehoban.com";
      gpgKey = "E12BDCFE4AEF7082";
    in
    {
      darwinConfigurations.macbook = darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit user host gitUser gitEmail gpgKey; };
        modules = [
          ./hosts/laptop/darwin-configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit user gitUser gitEmail gpgKey; };
            home-manager.users.${user} = import ./hosts/laptop/home.nix;
          }
          {
            nixpkgs.overlays = with inputs; [
              nur.overlay
            ];
          }
        ];
      };
    };
}