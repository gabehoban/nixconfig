{ config, lib, pkgs, ... }:
let
  cfg = config.modules.editors.vscode;

in with lib; {
  options.modules.editors.vscode = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    pkg = mkOption {
      type = types.package;
      default = pkgs.vscode;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.my.username} = {
      home = {
        packages = with pkgs; [
          git
          gnutls
          fd
          imagemagick
          html-tidy
          shfmt
          nodePackages.eslint
          nodePackages.unified-language-server
          nodePackages.bash-language-server
          taplo-lsp
          nodePackages.js-beautify
          nodePackages.stylelint
          nodePackages.yaml-language-server
        ];
      };
      programs.vscode = {
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
      programs.zsh = {
        sessionVariables = { EDITOR = "code"; };
      };
    };
  };
}
