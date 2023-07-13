{ options, inputs, lib, ... }:

with lib;
{
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  options.plusultra.stylix = with types; {
    extraOptions = mkOpt attrs { } "Options to pass directly to stylix's NixOS module";
  };

  config = {
    plusultra.stylix.stylesheets.main = enabled;

    stylix = mkAliasDefinitions options.plusultra.stylix.extraOptions;
  };
}
