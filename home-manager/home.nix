{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ./alacritty
    ./bat
    ./direnv
    ./fonts
    ./git
    ./gpg
    ./shell
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "gabehoban";
    homeDirectory = "/home/gabehoban";
  };

  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "22.11";
}
