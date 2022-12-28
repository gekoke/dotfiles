{ pkgs
, system ? "x86_64-linux"
}:
pkgs.lib.nixosSystem {
  inherit system;
  modules = [
    "${pkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
    {
      networking.wireless.enable = false;
      networking.networkmanager.enable = true;
      nix.extraOptions = "experimental-features = nix-command flakes";
    }
  ];
}
