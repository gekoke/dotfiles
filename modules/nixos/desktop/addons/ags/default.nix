{ inputs, pkgs, lib, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.elementary.desktop.addons.ags = {
    enable = mkEnableOption "Aylur's GTK Shell";
  };

  config = {
    elementary.home = {
      extraOptions.imports = [
        inputs.ags.homeManagerModules.default
      ];

      packages = builtins.attrValues
        {
          inherit (pkgs)
            # Dependencies
            brightnessctl
            nerdfonts
            sassc
            swww

            # Optional dependencies
            asusctl
            hyprpicker
            imagemagick
            pavucontrol
            slurp
            supergfxctl
            swappy
            wayshot
            wf-recorder
            wl-gammactl
            ;
        };


      programs.ags = {
        enable = true;
      };

      configFile."ags" = {
        recursive = true;
        source = "${inputs.aylur-dotfiles}/ags/";
      };
    };

    elementary.desktop.hyprland.extraHomeManagerOptions.extraConfig = ''
      bind=CTRL SHIFT, R,  exec, ags quit; ags -b hypr

      bind=SUPER, P, exec, ags -b hypr -t applauncher
      bind=,XF86PowerOff, exec, ags -b hypr -t powermenu
      bind=SUPER, Tab, exec, ags -b hypr -t overview

      bind=,XF86Launch4, exec, ags -b hypr -r 'recorder.start()'
      bind=,Print, exec, ags -b hypr -r 'recorder.screenshot()'
      bind=SHIFT, Print, exec, ags -b hypr -r 'recorder.screenshot(true)'

      bindle=,XF86MonBrightnessUp, exec, ags -b hypr -r 'brightness.screen += 0.05; indicator.display()'
      bindle=,XF86MonBrightnessDown, exec, ags -b hypr -r 'brightness.screen -= 0.05; indicator.display()'
      bindle=,XF86KbdBrightnessUp, exec, ags -b hypr -r 'brightness.kbd++; indicator.kbd()'
      bindle=,XF86KbdBrightnessDown, exec, ags -b hypr -r 'brightness.kbd--; indicator.kbd()'

      bindle=,XF86AudioRaiseVolume, exec, ags -b hypr -r 'audio.speaker.volume += 0.05; indicator.speaker()'
      bindle=,XF86AudioLowerVolume, exec, ags -b hypr -r 'audio.speaker.volume -= 0.05; indicator.speaker()'
    '';
  };
}
