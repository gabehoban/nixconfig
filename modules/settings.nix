{ config, lib, pkgs, home-manager, options, ... }:

with lib;

let
  mkOptStr = value:
    mkOption {
      type = with types; uniq str;
      default = value;
    };

  # copied from https://github.com/cmacrae/config
  mailAddr = name: domain: "${name}@${domain}";
in {

  options = with types; {
    my = {
      username = mkOptStr "gabehoban";
      name = mkOptStr "Gabe Hoban";
      email = mkOptStr (mailAddr "me" "gabehoban.com");
      hostname = mkOptStr "macbook";
      gpgKey = mkOptStr "98AD3B0EEEFB665D";
      homeDirectory = mkOptStr "/Users/gabehoban";
      font = mkOptStr "JetBrainsMono Nerd Font";
    };
  };
}
