{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.elementary;
let
  cfg = config.elementary.programs.spotify;
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  options.elementary.programs.spotify = with types; {
    enable = mkEnableOption "Spotify";
    spicetifyTheme = {
      enable = mkEnableOption "Spicetify theme";
      theme = mkOpt str "sleek" "The Spicetify theme to apply";
      colorScheme = mkOpt str "RosePine" "The color scheme to apply to the Spicetify theme";
    };
  };

  config = mkIf cfg.enable {
    elementary.home = {
      extraOptions.imports = [ inputs.spicetify-nix.homeManagerModules.default ];

      programs.spicetify =
        {
          enable = true;
          enabledExtensions = with spicePkgs.extensions; [
            betterGenres
            keyboardShortcut
          ];
        }
        // (lib.optionalAttrs cfg.spicetifyTheme.enable {
          inherit (cfg.spicetifyTheme) colorScheme;
          theme = spicePkgs.themes.${cfg.spicetifyTheme.theme};
        });
    };
  };
}
