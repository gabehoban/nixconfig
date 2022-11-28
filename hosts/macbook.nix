{ lib, pkgs, config, ... }: {
  home-manager.users.${config.my.username}.programs.git = {
    extraConfig = { github.user = "gabehoban"; };
  };

  my = {
    username = "gabehoban";
    name = "Gabe Hoban";
    email = "me@gabehoban.com";
    hostname = "macbook";
    gpgKey = "98AD3B0EEEFB665D";
    homeDirectory = "/Users/gabehoban";
  };

  modules = {

    browsers.firefox = {
      enable = true;
      pkg = pkgs.runCommand "firefox-0.0.0" { } "mkdir $out";
    };

    terminal.enable = true;

    brew = {
      enable = true;
      casks = [
        "1Password"
        "firefox"
      ];
    };
  
    editors.vscode = {
      enable = true;
    };
  };
}
