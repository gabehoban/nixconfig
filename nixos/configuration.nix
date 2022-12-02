# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    overlays = [
      # If you want to use overlays your own flake exports (from overlays dir):
      # outputs.overlays.modifications
      # outputs.overlays.additions
    ];

    config = {
      allowUnfree = true;
    };
  };

  nix = {
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  networking.hostName = "gabehoban";

  boot.loader.systemd-boot.enable = true;

  users.users = {
    gabehoban = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBGtDM+U1muLpDDW7+igfgGvl2UVQVC+GqWpeQ66DZv6wj8QWXP7QVH6ZDtaG0JFgDoc3gG4U6cd+mEtyE17igwo= cardno:17 077 465
      ];
      extraGroups = [ "wheel" ];
    };
  };

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    passwordAuthentication = false;
  };

  system.stateVersion = "22.11";
}
