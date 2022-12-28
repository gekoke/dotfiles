{ pkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.modules.dev.lua;
in
{
  options.modules.dev.lua = {
    enable = mkEnableOption "Lua dev support";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ sumneko-lua-language-server ];
  };
}
