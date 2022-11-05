{ pkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.modules.terminals.alacritty;
in {
  options.modules.terminals.alacritty = {
    enable = mkEnableOption "Alacritty terminal emulator";
  };

  config = mkIf cfg.enable {
    programs = {
      alacritty = {
        enable = true;

        settings = {
          colors = {
            primary = {
              background = "#2E3440";
            };
          };
          window = {
            opacity = 0.88;
            padding = {
              x = 4;
              y = 4;
            };
          };
          font = {
            normal = {
              family = "JetBrainsMono Nerd Font";
              style = "semibold";
            };
          };
        };
      };
    };

    home = {
      packages = with pkgs; [
        (nerdfonts.override {
          fonts = [
            "JetBrainsMono"
          ];
        })
      ];
    };

    fonts.fontconfig.enable = true;
  };
}
