{ config, lib, ... }:

with lib;
let cfg = config.plusultra.programs.direnv;
in
{
  options.plusultra.programs.direnv = with types; {
    enable = mkEnableOption "direnv";
  };

  config = mkIf cfg.enable {
    plusultra.home.programs.direnv = enabled // { nix-direnv = enabled; };
  };
}
