{
  config,
  lib,
  system,
  inputs,
  ...
}:
with lib;
with lib.elementary;
let
  cfg = config.elementary.programs.spotify;
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
        enabledExtensions =
          let
            inherit (inputs.spicetify-nix.legacyPackages.${system}) extensions;
          in
          [
            extensions.betterGenres
            extensions.keyboardShortcut
          ];
      };
    };
  };
}
