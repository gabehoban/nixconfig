{ config, lib, pkgs, ...}: {
  programs.alacritty = {
    enable = true;
    settings = {
      env = { };
      padding = {
        x = 15;
        y = 5;
      };
      decorations = "full";
      dynamic_padding = true;
      dynamic_title = true;

      scrolling = {
        history = 10000;
        multiplier = 3;
      };

      font = {
        size = 16;

        normal.family = "JetBrainsMono Nerd Font";
        normal.style = "Regular";
        bold.family = "JetBrainsMono Nerd Font";
        bold.style = "Bold";
        italic.family = "JetBrainsMono Nerd Font";
        italic.style = "Italic";
        bold_italic.family = "JetBrainsMono Nerd Font";
        bold_italic.style = "Bold Italic";

        offset = {
          x = 0;
          y = 0;
        };

        glyph_offset = {
          x = 0;
          y = 0;
        };
      };

      colors = {
        # Default colors
        primary = {
          background = "0x1d1f21";
          foreground = "0xc5c8c6";
        };

        # Normal colors
        normal = {
          black =   "0x1d1f21";
          red =     "0xcc6666";
          green =   "0xb5bd68";
          yellow =  "0xe6c547";
          blue =    "0x81a2be";
          magenta = "0xb294bb";
          cyan =    "0x70c0ba";
          white =   "0x373b41";
        };
        # Bright colors
        bright = {
          black =   "0x666666";
          red =     "0xff3334";
          green =   "0x9ec400";
          yellow =  "0xe7c547";
          blue =    "0x81a2be";
          magenta = "0xb77ee0";
          cyan =    "0x54ced6";
          white =   "0x282a2e";
        };
      };

      live_config_reload = true;
    };
  };
}
