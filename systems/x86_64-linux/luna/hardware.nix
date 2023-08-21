{ lib, inputs, ... }:
with lib;
{
  imports = with inputs.nixos-hardware.nixosModules; [
    common-pc
    common-pc-ssd
    common-cpu-intel-kaby-lake
    common-gpu-nvidia-nonprime
  ];

  plusultra.hardware.nvidia = enabled;
}
