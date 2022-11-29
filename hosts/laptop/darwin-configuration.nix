{ config, pkgs, user, host, ... }:

{
  nixpkgs.config.allowUnfree = true;

  networking = {
    computerName = "${host}";
    hostName = "${host}";
  };

  users.users."${user}" = {
    shell = pkgs.zsh;
    home = "/Users/${user}";
  };

  nix = {
    package = pkgs.nix;

    gc = {
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
    };

    settings = {
      trusted-users = [ "root" "${user}" ];
    };

    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
    '';
  };

  system = {
    defaults = {
      dock = {
        autohide = false;
        launchanim = false;
        mineffect = "scale";
        minimize-to-application = true;
        mru-spaces = false;
        orientation = "bottom";
        show-process-indicators = true;
        show-recents = false;
        showhidden = true;
        tilesize = 48;
      };

      screencapture.location = "/tmp/screenshots";

      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = false;
        FXEnableExtensionChangeWarning = false;
        QuitMenuItem = true;
        ShowPathbar = true;
      };

      loginwindow = {
        DisableConsoleAccess = true;
        GuestEnabled = false;
      };

      NSGlobalDomain = {
        ApplePressAndHoldEnabled = false;
        AppleInterfaceStyle = "Dark";
        InitialKeyRepeat = 15;
        KeyRepeat = 3;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticWindowAnimationsEnabled = false;
        NSDocumentSaveNewDocumentsToCloud = false;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
      };
    };

    stateVersion = 4;
  };

  environment = {
    shells = with pkgs; [ zsh ];
    systemPackages = with pkgs; [
      git
      curl
      xcode-install
    ];
  };

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" "SpaceMono" ]; })
    ];
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    taps = [
      "homebrew/core"
      "homebrew/cask"
      "homebrew/cask-versions"
      "homebrew/cask-drivers"
      "homebrew/services"
    ];
    casks = [
      "spaceid"
      "alfred"
      "1password"
      "firefox"
      "steam"
    ];
  };

  programs.bash.enable = false;
  programs.gnupg = {
    agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  services = {
    nix-daemon.enable = true;
  };
}