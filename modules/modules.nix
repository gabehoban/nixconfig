# why not use stdenv isDarwin function
# https://github.com/nix-community/home-manager/issues/414
{ lib, isDarwin ? false, isNixOS ? false }:

with lib;
let
  loadModule = file: { condition ? true }: { inherit file condition; };
  allModules = [
    (loadModule ./browsers/firefox.nix { })
    (loadModule ./dev/julia.nix { })
    (loadModule ./dev/node.nix { })
    (loadModule ./dev/python.nix { })
    (loadModule ./editor.nix { })
    (loadModule ./hosts.nix { })
    (loadModule ./common.nix { })
    (loadModule ./settings.nix { })
    (loadModule ./terminal { })
    (loadModule ./brew.nix { condition = isDarwin; })
  ];
  modules = map (getAttr "file") (filter (getAttr "condition") allModules);
in modules
