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
      inherit (lib.strings) normalizePath;
    in
    mkIf cfg.enable {
      programs.nh.flake = normalizePath (config.home.homeDirectory + "/" + "Repos/dotfiles");
    };
}
