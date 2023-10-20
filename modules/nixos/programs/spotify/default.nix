{ config, lib, pkgs, inputs, ... }:
with lib;
with lib.elementary;
let
  cfg = config.elementary.programs.spotify;
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
in
{
  options.elementary.programs.spotify = with types; {
    enable = mkEnableOption "Spotify";
    theme = mkOpt str "Sleek" "The Spicetify theme to apply";
    colorScheme = mkOpt str "RosePine" "The color scheme to apply to the Spicetify theme";
  };

  config = mkIf cfg.enable {
    elementary.home = {
      extraOptions.imports = [
        inputs.spicetify-nix.homeManagerModule
      ];

      programs.spicetify = {
        enable = true;
        inherit (cfg) colorScheme;
        theme = spicePkgs.themes.${cfg.theme};
        enabledExtensions = with spicePkgs.extensions; [
          genre
          keyboardShortcut
        ];
      };
    };
  };
}
