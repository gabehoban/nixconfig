{
  description = "Gabe's Nix-darwin Home";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devenv.url = "github:cachix/devenv/v0.2";
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    resource-id.url = "github:yuanwang-wf/resource-id";
    ws-access-token.url = "github:yuanwang-wf/ws-access-token";
  };

  outputs =
    inputs@{ self
    , devenv
    , nixpkgs
    , nixpkgs-unstable
    , darwin
    , home-manager
    , nur
    , resource-id
    , ws-access-token
    , devshell
    , flake-utils
    , ...
    }:
    let
      inherit (flake-utils.lib) eachDefaultSystem eachSystem;

      system = "aarch64-darwin";
      globalPkgsConfig = {
        allowUnfree = true;
      };

      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config = globalPkgsConfig;
        };
      };

      overlays = [
        overlay-unstable
        nur.overlay
        (final: prev: {
          devenv = inputs.devenv.defaultPackage.${prev.system};
          resource-id = inputs.resource-id.defaultPackage.${prev.system};
          ws-access-token =
            inputs.ws-access-token.defaultPackage.${prev.system};
        })
        (import ./overlays)
      ];

      # idea borrowed from https://github.com/hardselius/dotfiles
      mkDarwinSystem = { modules }:
        darwin.lib.darwinSystem {
          inputs = inputs;
          system = "aarch64-darwin";
          modules = [
            { nixpkgs.overlays = overlays; }

            ({ lib, ... }: {
              imports = import ./modules/modules.nix {
                inherit lib;
                isDarwin = true;
              };
            })
            home-manager.darwinModules.home-manager
            ./macintosh.nix
          ] ++ modules;
        };
    in
    {
      darwinConfigurations = {
        macbook = mkDarwinSystem { modules = [ ./hosts/macbook.nix ]; };
      };
      macbook = self.darwinConfigurations.macbook.system;

    } // eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ devshell.overlay ];
      };
    in
    {
      devShell = pkgs.devshell.mkShell {
        name = "nix-home";
        imports = [ (pkgs.devshell.extraModulesDir + "/git/hooks.nix") ];
        git.hooks.enable = true;
        git.hooks.pre-commit.text = "${pkgs.treefmt}/bin/treefmt";
        packages = [
          pkgs.ormolu
          pkgs.treefmt
          pkgs.nixfmt
        ];
      };
    });
}
