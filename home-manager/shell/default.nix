{ config, lib, pkgs, ... }: {

  home.packages = with pkgs; [
    fd
  ];

  programs = {
    zsh = {
      enable = true;

      enableAutosuggestions = true;
      enableCompletion = true;
      enableSyntaxHighlighting = true;

      initExtra = ''
        zstyle ':completion:*' menu yes select
        zstyle ':completion:*' menu select=1
        zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
      '';

      sessionVariables = {
        # Install non-free packages e.g. Steam
        NIXPKGS_ALLOW_UNFREE = "1";
        FZF_DEFAULT_OPTS = "--layout=reverse";

        # Autosuggest as orange
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=3";

        # Use NeoVim is my editor for all
        EDITOR = "nvim";
      };

      shellAliases = {
        # easy out
        ".." = "cd ..";

        # interactive ripgrep
        irg = ''INITIAL_QUERY=""
          RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case " \
          FZF_DEFAULT_COMMAND="$RG_PREFIX '$INITIAL_QUERY'"     \
          fzf -m --bind "change:reload:$RG_PREFIX {q} || true"  \
              --ansi --disabled --query "$INITIAL_QUERY"        \
              --height=50% --layout=reverse'';
      };
    };

    fzf = {
        enable = true;
        enableZshIntegration = true;
        defaultCommand = ''${pkgs.fd}/bin/fd --follow --type f --exclude="'.git'" .'';
        defaultOptions = [ "--exact" "--cycle" "--layout=reverse" ];
        enableFishIntegration = false;
    };

    programs.starship = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        enableFishIntegration = false;

        settings = {
            add_newline = false;
            format = "$username$hostname$directory$git_branch$nix_shell$git_commit$git_state$git_status$cmd_duration$jobs$status$character";

            cmd_duration = {
                disabled = false;
                min_time = 10000;
            };

            directory = {
                disabled = false;
                truncation_length = 1;
                fish_style_pwd_dir_length = 1;
                truncate_to_repo = false;
            };

            git_branch = {
                format = "\\([$branch]($style)\\) ";
            };

            hostname = {
                ssh_only = false;
                style = "fg:purple";
                format = "[@$hostname]($style):";
            };

            line_break = {
                disabled = true;
            };

            # screws up the prompt in kitty
            nix_shell = {
                disabled = true;
                format = "[$symbol]($style)";
                impure_msg = "";
                pure_msg = "";
                symbol = "❄️";
            };

            time = {
                disabled = true;
                format = "%H:%M";
            };

            username = {
                disabled = true;
                show_always = true;
                style_user = "fg:purple";
                style_root = "bold fg:red";
                format = "[$user]($style)";
            };
        };
    };
  };
}
