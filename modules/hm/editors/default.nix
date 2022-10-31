{ pkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.modules.editors;
in {
  imports = [
    ./emacs
    ./neovim
    ./code
  ];

  options.modules.editors = {
    enable = mkEnableOption "text editors";
    default = mkOption {
      type = types.default;
      default = "nvim";
    };
  };

  config = mkIf cfg.enable {
    home.sessionVariables.EDITOR = cfg.default;
  };
}
