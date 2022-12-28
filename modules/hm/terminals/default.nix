{ pkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.modules.terminals;
in
{
  imports = [
    ./alacritty
  ];

  options.modules.terminals = {
    enable = mkEnableOption "terminal emulators";
    default = mkOption {
      type = types.str;
      default = "alacritty";
    };
  };

  config = mkIf cfg.enable {
    home.sessionVariables.TERM = cfg.default;

    services.sxhkd = {
      enable = true;
      keybindings."super + apostrophe" = "${config.modules.terminals.default}";
    };
  };
}
