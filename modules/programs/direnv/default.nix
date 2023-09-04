{ config, lib, ... }:

with lib;
let cfg = config.elementary.programs.direnv;
in
{
  options.elementary.programs.direnv = with types; {
    enable = mkEnableOption "direnv";
  };

  config = mkIf cfg.enable {
    elementary.home.programs.direnv = enabled // { nix-direnv = enabled; };
  };
}
