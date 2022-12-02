# This is just an example, you should generate yours with nixos-generate-config and put it in here.
{
  fileSystems."/" = {
    device = "/dev/nvme0n1";
    fsType = "ext4";
  };

  nixpkgs.hostPlatform = "x86_64-linux";
}
