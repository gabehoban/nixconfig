{ config, pkgs, user, gitUser, gitEmail, gpgKey, ... }:

let
  fakepkg = name: pkgs.runCommand name {} "mkdir $out";
in
{
  home = {
    username = "${user}";
    homeDirectory = "/Users/${user}";
    stateVersion = "23.05";
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "code";
      TERMINAL = "alacritty";
    };
    packages = with pkgs; [
      # shell prompt
      starship
      # cli utilities
      bat
      curl
      diceware
      ffmpeg
      fzf
      git-crypt
      git-lfs
      jq
      libu2f-host
      yubikey-personalization
      yubikey-manager
      less
      lsd
      moreutils
      nix-du
      nix-prefetch-git
      nix-tree
      nixfmt
      nixpkgs-fmt
      openssh
      pinentry_mac
      tree
      wget
      # GUI Apps
      vscode
    ];
  };

  programs = {
    home-manager = {
      enable = true;
    };

    git = {
      enable = true;
      userName = "${gitUser}";
      userEmail = "${gitEmail}";
      signing = {
        key = "${gpgKey}";
        signByDefault = true;
      };
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
      };
      diff-so-fancy.enable = true;
      ignores = [ ".direnv" ".DS_Store" ".envrc" ];
    };

    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      enableCompletion = true;
      history = {
        size = 50000;
        save = 500000;
        path = "$HOME/.config/zsh/history";
        ignoreDups = true;
        share = true;
      };
      initExtra = ''
        eval "$(starship init zsh)"
        export PATH=$PATH:/usr/local/bin:/usr/local/sbin/:$HOME/.local/bin
      '';
      shellAliases = {
        ls = "lsd -lah";
        cat = "bat";
      };
    };

    gpg = {
      enable = true;
      scdaemonSettings = {
        disable-ccid = true;
        reader-port = "Yubico YubiKey OTP+FIDO+CCID";
      };
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    tmux = {
      enable = true;
      baseIndex = 1;
      customPaneNavigationAndResize = true;
      disableConfirmationPrompt = true;
      escapeTime = 0;
      historyLimit = 50000;
      keyMode = "vi";
      newSession = true;
      prefix = "C-a";
      terminal = "screen-256color";
      tmuxp.enable = true;
      plugins = with pkgs; [
        tmuxPlugins.tmux-fzf
        {
          plugin = tmuxPlugins.power-theme;
          extraConfig = "set -g @tmux_power_theme 'moon'";
        }
      ];
      extraConfig = ''
        # Vim settings
        set-option -g focus-events on
        # Changing key bindings
        unbind r
        bind r source-file $XDG_CONFIG_HOME/tmux/tmux.conf \; display "Reloaded tmux conf"
        set -g mouse on
        unbind |
        unbind -
        unbind up
        unbind down
        unbind right
        unbind left
        unbind -
        unbind %
        unbind '"'
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        bind -n C-left select-pane -L
        bind -n C-down select-pane -D
        bind -n C-up select-pane -U
        bind -n C-right select-pane -R
        unbind n
        unbind w
        bind n command-prompt "rename-window '%%'"
        bind w new-window -c "#{pane_current_path}"
        bind -n M-j previous-window
        bind -n M-k next-window
        # Vim keybindings
        unbind -T copy-mode-vi Space;
        unbind -T copy-mode-vi Enter;
        bind -T copy-mode-vi v send-keys -X begin-selection
        bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xsel --clipboard" 
        set -g -a terminal-overrides ',*:Ss=\E[%p1%d q:Se=\E[2 q'
        is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
            | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
        bind -n C-h if-shell "$is_vim" "send-keys C-h"  "select-pane -L"
        bind -n C-j if-shell "$is_vim" "send-keys C-j"  "select-pane -D"
        bind -n C-k if-shell "$is_vim" "send-keys C-k"  "select-pane -U"
        bind -n C-l if-shell "$is_vim" "send-keys C-l"  "select-pane -R"
        bind -n C-\\ if-shell "$is_vim" "send-keys C-\\" "select-pane -l"
      '';
    };

    lsd = {
      enable = true;
      settings = {
        classic = false;
        blocks = [
          "permission"
          "user"
          "size"
          "date"
          "name"
        ];
        date = "+%d %b %R";
        icons = {
          when = "auto";
          theme = "fancy";
          separator = " ";
        };
        layout = "grid";
        sorting = {
          column = "name";
          reverse = false;
          dir-grouping = "first";
        };
        symlink-arrow = "->";
      };
    };

    alacritty = {
      enable = true;
      settings = {
        live_config_reload = true;
        dynamic_title = true;
        window = {
          padding = {
            x = 15;
            y = 15;
          };
        };
        font = {
          size = 17.0;
          normal = {
            family = "JetBrainsMono Nerd Font";
            style = "Regular";
          };
          bold = {
            family = "JetBrainsMono Nerd Font";
            style = "Bold";
          };
          italic = {
            family = "JetBrainsMono Nerd Font";
            style = "Italic";
          };
        };
        draw_bold_text_with_bright_colors = true;
        colors = {
          primary = {
            background = "#222222";
            foreground = "#f7f1ff";
          };
          selection = {
            text = "#bab6c0";
            background = "#403e41";
          };
          normal = {
            black = "#363537";
            red = "#fc618d";
            green = "#7db88f";
            yellow = "#fce566";
            blue = "0x61afef";
            magenta = "#948ae3";
            cyan = "#5ad4e6";
            white = "#f7f1ff";
          };
          bright = {
            black = "#403e41";
            red = "#fc618d";
            green = "#7db88f";
            yellow = "#fce566";
            blue = "0x61afef";
            magenta = "#948ae3";
            cyan = "#5ad4e6";
            white = "#f7f1ff";
          };
        };
      };
    };

    vscode = {
      enable = true;
        enableUpdateCheck = false;
        extensions = with pkgs.vscode-extensions; [
          jnoortheen.nix-ide
          zhuangtongfa.material-theme
          pkief.material-icon-theme
        ];
        userSettings = {
          "editor.fontFamily" = "JetBrainsMono Nerd Font";
          "editor.fontLigatures" = true;
          "editor.fontSize" = 18;
          "editor.lineHeight" = 30;
          "window.zoomLevel" = 1;
          "workbench.activityBar.visible" = true;
          "workbench.colorTheme" = "One Dark Pro";
          "workbench.iconTheme" = "material-icon-theme";
        };
    };

    firefox = {
      enable = true;
      package = fakepkg "firefox";
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        onepassword-password-manager
        decentraleyes
        privacy-badger
      ];
      profiles."${user}" = {
        isDefault = true;
        settings = {
          # Configured via Firefox Profilemaker
          "app.normandy.api_url" = "";
          "app.normandy.enabled" = false;
          "app.shield.optoutstudies.enabled" = false;
          "app.update.auto" = false;
          "beacon.enabled" = false;
          "breakpad.reportURL" = "";
          "browser.aboutConfig.showWarning" = false;
          "browser.crashReports.unsubmittedCheck.autoSubmit" = false;
          "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
          "browser.crashReports.unsubmittedCheck.enabled" = false;
          "browser.disableResetPrompt" = true;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
          "browser.newtabpage.enhanced" = false;
          "browser.newtabpage.introShown" = true;
          "browser.safebrowsing.appRepURL" = "";
          "browser.safebrowsing.blockedURIs.enabled" = false;
          "browser.safebrowsing.downloads.enabled" = false;
          "browser.safebrowsing.downloads.remote.enabled" = false;
          "browser.safebrowsing.downloads.remote.url" = "";
          "browser.safebrowsing.enabled" = false;
          "browser.safebrowsing.malware.enabled" = false;
          "browser.safebrowsing.phishing.enabled" = false;
          "browser.selfsupport.url" = "";
          "browser.sessionstore.privacy_level" = 2;
          "browser.shell.checkDefaultBrowser" = false;
          "browser.startup.homepage_override.mstone" = "ignore";
          "browser.tabs.crashReporting.sendReport" = false;
          "browser.urlbar.groupLabels.enabled" = false;
          "browser.urlbar.quicksuggest.enabled" = false;
          "browser.urlbar.trimURLs" = false;
          "datareporting.healthreport.service.enabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "device.sensors.ambientLight.enabled" = false;
          "device.sensors.enabled" = false;
          "device.sensors.motion.enabled" = false;
          "device.sensors.orientation.enabled" = false;
          "device.sensors.proximity.enabled" = false;
          "dom.battery.enabled" = false;
          "dom.security.https_only_mode" = true;
          "dom.security.https_only_mode_ever_enabled" = true;
          "experiments.activeExperiment" = false;
          "experiments.enabled" = false;
          "experiments.manifest.uri" = "";
          "experiments.supported" = false;
          "extensions.getAddons.cache.enabled" = false;
          "extensions.getAddons.showPane" = false;
          "extensions.pocket.enabled" = false;
          "extensions.shield-recipe-client.api_url" = "";
          "extensions.shield-recipe-client.enabled" = false;
          "extensions.webservice.discoverURL" = "";
          "media.autoplay.default" = 1;
          "media.autoplay.enabled" = false;
          "media.navigator.enabled" = false;
          "network.allow-experiments" = false;
          "network.cookie.cookieBehavior" = 1;
          "network.http.referer.spoofSource" = true;
          "privacy.query_stripping" = true;
          "privacy.trackingprotection.cryptomining.enabled" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.fingerprinting.enabled" = true;
          "privacy.trackingprotection.pbmode.enabled" = true;
          "privacy.usercontext.about_newtab_segregation.enabled" = true;
          "services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsoredTopSite" = false;
          "signon.autofillForms" = false;
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.cachedClientID" = "";
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.hybridContent.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.prompted" = 2;
          "toolkit.telemetry.rejected" = true;
          "toolkit.telemetry.reportingpolicy.firstRun" = false;
          "toolkit.telemetry.server" = "";
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.unifiedIsOptIn" = false;
          "toolkit.telemetry.updatePing.enabled" = false;
          "webgl.renderer-string-override" = " ";
          "webgl.vendor-string-override" = " ";
        };
      };
    };
  };
}