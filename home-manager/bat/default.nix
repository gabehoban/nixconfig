{ config, lib, pkgs, ... }: {
  programs.bat = {
    enable = true;
    config = {
        theme = "TwoDark";
        pager = "less --quit-if-one-screen --RAW-CONTROl-CHARS";
        style = "numbers,changes,header";
    };
  };
}
