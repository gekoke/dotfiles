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
    };
  };

  config = mkIf cfg.enable {
    elementary.home = {
      extraOptions.imports = [ inputs.spicetify-nix.homeManagerModules.default ];

      programs.spicetify = {
        enable = true;
        enabledExtensions = [
          spicePkgs.extensions.betterGenres
          spicePkgs.extensions.keyboardShortcut
        ];
      };
    };
  };
}
