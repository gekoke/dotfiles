{ lib, pkgs, ... }:

with lib;
{
  options.plusultra.stylix.stylesheets.main.enable = mkEnableOption "main stylesheet";

  config = {
    plusultra.stylix.extraOptions = {
      polarity = "dark";
      image = "${pkgs.wallpapers}/share/wallpapers/purplewildlife.jpg";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";

      opacity = {
        terminal = 0.75;
      };

      fonts = {
        sizes = {
          desktop = 13;
          terminal = 12;
        };

        serif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Serif";
        };

        sansSerif = {
          package = pkgs.dejavu_fonts;
          name = "Iosevka Nerd Font";
        };

        monospace = {
          package = pkgs.nerdfonts;
          name = "Iosevka Nerd Font";
        };

        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };
      };
    };

    plusultra.desktop.hyprland.extraHomeManagerOptions.extraConfig = ''
      general {
          gaps_out = 10
          gaps_in = 5
      }

      decoration {
          rounding = 1
          blur_size = 8
          blur_passes = 3
      }

      bezier = overshot, 0.05, 0.9, 0.1, 1.1

      animations {
          animation = workspaces, 1, 4, overshot, slidevert
          animation = windows, 1, 4, overshot, popin
      }
    '';
  };
}
