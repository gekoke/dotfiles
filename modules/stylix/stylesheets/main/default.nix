{ lib, pkgs, ... }:

with lib;
{
  options.plusultra.stylix.stylesheets.main.enable = mkEnableOption "main stylesheet";

  config =
    let
      rounding = 1;
      borderSize = 1;
    in
    {
      plusultra.stylix.extraOptions = {
        polarity = "dark";
        image = "${pkgs.wallpapers}/share/wallpapers/purplewildlife.jpg";
        base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";

        opacity = {
          terminal = 0.75;
          desktop = 0.75;
          popups = 0.95;
        };

        fonts = {
          sizes = {
            desktop = 10;
            terminal = 13;
            popups = 10;
          };

          serif = {
            package = pkgs.dejavu_fonts;
            name = "DejaVu Serif";
          };

          sansSerif = {
            package = pkgs.dejavu_fonts;
            name = "IosevkaTerm Nerd Font";
          };

          monospace = {
            package = pkgs.nerdfonts;
            name = "IosevkaTerm Nerd Font";
          };

          emoji = {
            package = pkgs.noto-fonts-emoji;
            name = "Noto Color Emoji";
          };
        };
      };

      plusultra.desktop.addons.dunst.settings = {
        global = {
          width = 360;
          height = 110;
          gap_size = 6;
          frame_width = borderSize;
          offset = "16x16";
          corner_radius = rounding;
          icon_corner_radius = rounding;
          min_icon_size = 64;
          max_icon_size = 64;
        };
      };

      plusultra.home.sessionVariables = {
        SWWW_TRANSITION_FPS = 255;
        SWWW_TRANSITION_TYPE = "wipe";
        SWWW_TRANSITION_BEZIER = "0.86,0.0,0.07,1.0";
      };

      # TODO: remove hardcoded gradient colors
      plusultra.desktop.hyprland.extraHomeManagerOptions.extraConfig = ''
        layerrule = blur, (waybar|notifications|gtk-layer-shell|rofi)

        general {
            gaps_out = 10
            gaps_in = 5

            border_size = ${toString borderSize}
            col.active_border = rgb(f5bde6) rgb(c6a0f6) rgb(8bd5ca) rgb(91d7e3) rgb(7dc4e4) rgb(8aadf4) rgb(b7bdf8)
            col.inactive_border = rgb(494d64)
        }

        decoration {
            rounding = ${toString rounding};
            blur = true
            blur_size = 8
            blur_passes = 3
        }

        bezier = overshot, 0.05, 0.9, 0.1, 1.1
        bezier = easeInOutQuint, 0.86, 0, 0.07, 1
        bezier = easeOutExpo, 0.19, 1, 0.22, 1

        animations {
            animation = workspaces, 1, 2.5, easeInOutQuint, slidevert
            animation = windows, 1, 4, easeOutExpo, popin
        }
      '';
    };
}
