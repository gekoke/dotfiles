{ inputs, ... }:
{
  den.aspects.niri = {
    nixos =
      { pkgs, ... }:
      {
        imports = [ inputs.niri-flake.nixosModules.niri ];

        nixpkgs.overlays = [ inputs.niri-flake.overlays.niri ];
        programs.niri = {
          enable = true;
          package = pkgs.niri;
        };
        environment.variables = {
          NIXOS_OZONE_WL = "1";
          QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        };
      };

    provides.to-users.homeManager = {
      imports = [
        inputs.dank-material-shell.homeModules.dank-material-shell
        inputs.dank-material-shell.homeModules.niri
      ];
      programs = {
        niri.settings = import ./_niri-settings.nix;
        dank-material-shell = {
          enable = true;
          systemd.enable = true;
        };
      };
    };
  };
}
