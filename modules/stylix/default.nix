{ options, inputs, lib, ... }:

with lib;
{
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  options.plusultra.stylix = with types; {
    extraOptions = mkOpt attrs { } "Options to pass directly to stylix's NixOS module";
    extraHomeManagerOptions = mkOpt attrs { } "Options to pass directly to stylix's home-manager module";
  };

  config = {
    plusultra.stylix.stylesheets.main = enabled;

    stylix = mkAliasDefinitions options.plusultra.stylix.extraOptions;
    plusultra.home.extraOptions.stylix = mkAliasDefinitions options.plusultra.stylix.extraHomeManagerOptions;
  };
}
