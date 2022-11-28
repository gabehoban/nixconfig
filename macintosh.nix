{ inputs, config, lib, pkgs, ... }:

with pkgs.stdenv;
with lib; {
  networking.hostName = config.my.hostname;
  nix = {
    package = pkgs.nixUnstable;

    # trusted-users = [ "root" config.my.username ];
    # trustedBinaryCaches = config.nix.binaryCaches;
    gc = { user = "${config.my.username}"; };
  };

  system.stateVersion = 4;
  services.nix-daemon.enable = true;
  system.defaults = {
    dock = {
      autohide = false;
      mru-spaces = false;
      orientation = "bottom";
      mineffect = "scale";
      showhidden = true;
      launchanim = false;
      show-recents = false;
      minimize-to-application = true;
      show-process-indicators = true;
    };

    screencapture.location = "/tmp/screenshots";

    finder = {
      AppleShowAllExtensions = true;
      _FXShowPosixPathInTitle = true;
      FXEnableExtensionChangeWarning = false;
    };

    NSGlobalDomain._HIHideMenuBar = false;
    NSGlobalDomain.InitialKeyRepeat = 15;
    NSGlobalDomain.KeyRepeat = 2;
    NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
    NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
    NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
  };
  
  system.keyboard = {
    enableKeyMapping = true;
  };

  environment.shells = [ pkgs.zsh ];
  environment.systemPackages = [ pkgs.zsh pkgs.gcc pkgs.libu2f-host pkgs.yubikey-personalization pkgs.yubikey-manager ];

  programs.bash.enable = false;
  programs.zsh = {
    enableCompletion = false;
    enable = true;
  };
  programs.gnupg = {
    agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  time.timeZone = "America/Detroit";

  users.users.${config.my.username} = {
    shell = pkgs.zsh;
    home = config.my.homeDirectory;
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = false;
  home-manager.users.${config.my.username} = import ./home.nix { inherit pkgs lib config; };

  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    fira-code
    font-awesome
    (nerdfonts.override { fonts = [ "JetBrainsMono" "SpaceMono" ]; })
    roboto
    roboto-mono
  ];

  services.activate-system.enable = true;
}
