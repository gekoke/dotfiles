{ options, inputs, lib, ... }:

with lib;
with lib.elementary;
{
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  options.elementary.stylix = with types; {
    extraOptions = mkOpt attrs { } "Options to pass directly to stylix's NixOS module";
    extraHomeManagerOptions = mkOpt attrs { } "Options to pass directly to stylix's home-manager module";
  };

  config = {
    elementary.stylix.stylesheets.main = enabled;

    stylix = mkAliasDefinitions options.elementary.stylix.extraOptions;
    elementary.home.extraOptions.stylix = mkAliasDefinitions options.elementary.stylix.extraHomeManagerOptions;
  };
}
