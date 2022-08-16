{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.modules.comma;
in {
  imports = [../scripts];

  options.modules.comma = {
    enable = mkEnableOption "Comma program";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [comma];

    modules.scripts.script."update-nix-index.sh" = {
      source = ./update-nix-index.sh;
      executable = true;
    };
  };
}
