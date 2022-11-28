{ config, lib, pkgs, ... }:

with lib;
let cfg = config.modules.dev.python;
in {
  options.modules.dev.python = { enable = mkEnableOption "python"; };

  config = mkIf cfg.enable {
    home-manager.users.${config.my.username}.home.packages = [
      (pkgs.python3.withPackages (ps:
        with ps; [
          pip
          black
          pandas
          setuptools
          pylint
          virtualenv
          virtualenvwrapper
        ]))
    ];
  };
}
