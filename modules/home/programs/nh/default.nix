{
  lib,
  config,
  ...
}:
let
  cfg = config.programs.nh;
in
{
  options.programs.nh.elementary.config =
    let
      inherit (lib) mkEnableOption;
    in
    {
      enable = mkEnableOption "Elementary nh configuration";
    };

  config =
    let
      inherit (lib) mkIf;
      inherit (lib.path) append;
    in
    mkIf cfg.enable {
      programs.nh.flake = append config.home.homeDirectory "Repos/dotfiles";
    };
}
