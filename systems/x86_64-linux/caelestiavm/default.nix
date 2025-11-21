{
  config,
  pkgs,
  inputs,
  ...
}:
{
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  users = {
    mutableUsers = false;
    users.geko = {
      isNormalUser = true;
      initialPassword = "test";
      extraGroups = [ "wheel" ];
    };
  };

  programs.hyprland.enable = true;

  home-manager = {
    sharedModules = [ inputs.caelestia-shell.homeManagerModules.default ];
    useUserPackages = true;
    users.geko = {
      home = {
        stateVersion = config.system.nixos.release;
        packages = [ pkgs.kitty ];
      };
      wayland.windowManager.hyprland = {
        enable = true;
        extraConfig = ''
          misc {
            disable_hyprland_logo = true
          }
          exec-once = caelestia-shell
        '';
      };
      programs = {
        caelestia = {
          enable = true;
          cli.enable = true;
        };
      };
    };
  };
}
