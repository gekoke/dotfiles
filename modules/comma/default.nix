{ lib
, pkgs
, config
, ...
}:
with lib; let
  cfg = config.modules.comma;
  nixIndexUpdateScript = pkgs.writeShellScriptBin "nixindex" (builtins.readFile ./update-nix-index.sh);
in
{
  options.modules.comma = {
    enable = mkEnableOption "Comma program";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      comma

      wget # Script dependency
      nixIndexUpdateScript
    ];
  };
}
