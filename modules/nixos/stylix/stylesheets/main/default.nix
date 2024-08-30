{
  config,
  lib,
  pkgs,
  ...
}:

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
        enable = true;
        image = "${pkgs.elementary.wallpapers}/share/wallpapers/evening-sky.png";
        base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

        opacity = {
          terminal = 0.85;
          desktop = 0.75;
          popups = 0.9;
        };

        fonts = {
          sizes = {
            desktop = 11;
            terminal = 14;
            popups = 11;
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
      elementary.desktop.hyprland.extraHomeManagerOptions.extraConfig =
        let
          inherit (config.lib.stylix.colors)
            base0A
            base0B
            base0C
            base0D
            base0E
            base0F
            ;
        in
        ''
          layerrule = blur, (waybar|notifications|gtk-layer-shell|rofi)

          general {
              gaps_out = 8
              gaps_in = 4

              border_size = 2

              col.active_border = rgb(${base0A}) rgb(${base0B}) rgb(${base0C}) rgb(${base0D}) rgb(${base0E}) rgb(${base0F})
          }

          decoration {
              rounding = 1

              blur {
                  enabled = true
                  size = 8
                  passes = 2
              }
          }

          bezier = overshot, 0.05, 0.9, 0.1, 1.1
          bezier = easeInOutQuint, 0.86, 0, 0.07, 1
          bezier = easeOutExpo, 0.19, 1, 0.22, 1

          animations {
              animation = workspaces, 1, 2, easeInOutQuint, slidefadevert 15%
              animation = windowsIn, 1, 4, easeOutExpo, popin 60%
              animation = windowsOut, 1, 4, easeOutExpo, popin 60%
              animation = windowsMove, 1, 3, easeOutExpo, slide
              animation = fade, 1, 3, easeOutExpo
          }
        '';
    }
    {
      elementary.programs.spotify = {
        enable = true;
      };
    }
    {
      elementary.home.extraOptions = {
        services.hyprpaper.settings.splash = false;
      };
    }
  ];
}
