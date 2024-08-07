{ lib, pkgs, ... }:

with lib;
with lib.elementary;
{
  options.elementary.stylix.stylesheets.main.enable = mkEnableOption "main stylesheet";

  config = mkMerge [
    {
      elementary.stylix.extraOptions.targets.grub = disabled;
      elementary.stylix.extraHomeManagerOptions.targets = {
        emacs = disabled;
      };

      elementary.stylix.extraOptions = {
        polarity = "dark";
        image = "${pkgs.elementary.wallpapers}/share/wallpapers/cyberpunkgirl-inverted.png";
        base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";

        opacity = {
          terminal = 0.85;
          desktop = 0.75;
          popups = 0.9;
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
            package = pkgs.nerdfonts;
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

      elementary.stylix.extraHomeManagerOptions.targets.swaylock.useImage = false;

      elementary.desktop.addons.waybar.style = ''
        .modules-left * {
            border: none;
            border-radius: 0;
        }
        .modules-left #workspaces button {
            color: @base05;
            transition: border-bottom 0.15s ease-out, background 0.15s ease-out;
        }
        .modules-left #workspaces button.active {
            border-bottom: 3px solid @base05;
        }
        .modules-left #workspaces button.urgent {
            border-bottom: 3px solid @base08;
        }
      '';

      elementary.stylix.extraHomeManagerOptions.targets.rofi = disabled;
      elementary.desktop.addons.rofi.rofi-collection.launcher = {
        enable = true;
        type = 4;
        style = 5;
      };

      elementary.desktop.addons.dunst.settings = {
        global = {
          width = 360;
          height = 110;
          gap_size = 6;
          frame_width = 1;
          offset = "16x16";
          corner_radius = 1;
          icon_corner_radius = 1;
          min_icon_size = 64;
          max_icon_size = 64;
        };
      };

      # TODO: remove hardcoded gradient colors
      elementary.desktop.hyprland.extraHomeManagerOptions.extraConfig = ''
        layerrule = blur, (waybar|notifications|gtk-layer-shell|rofi)

        general {
            gaps_out = 8
            gaps_in = 4

            border_size = 2
        }

        master {
            no_gaps_when_only = 1
        }

        decoration {
            blur {
                enabled = true
                size = 8
                passes = 3
            }
        }

        bezier = overshot, 0.05, 0.9, 0.1, 1.1
        bezier = easeInOutQuint, 0.86, 0, 0.07, 1
        bezier = easeOutExpo, 0.19, 1, 0.22, 1

        animations {
            enabled = false
        }
      '';
    }
    {
      elementary.programs.spotify = {
        enable = true;
      };
    }
  ];
}
