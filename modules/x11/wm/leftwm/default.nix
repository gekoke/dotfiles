{ ... }:
let
  themeFile = ./theme.toml;
in {
  imports =
    [
      ./home.nix
    ];

   xdg.configFile."leftwm/".source = ./config;
}
