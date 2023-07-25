{ options, config, lib, inputs, ... }:

with lib;
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  options.plusultra.home = with types; {
    file = mkOpt attrs { }
      "A set of files to be managed by home-manager's <option>home.file</option>";
    configFile = mkOpt attrs { }
      "A set of files to be managed by home-manager's <option>xdg.configFile</option>";
    packages = mkOpt (listOf package) [ ] "Packages to pass to <option>packages</option>";
    programs = mkOpt attrs { } "Attributes to pass to <option>programs</option>";
    services = mkOpt attrs { } "Attributes to pass to <option>services</option>";
    sessionVariables = mkOpt (lazyAttrsOf (oneOf [ str path int float ])) { } "Attributes to pass to <option>home.sessionVariables</option>";
    shellAliases = mkOpt (attrsOf str) { } "Attributes to pass to <option>home.shellAliases</option>";

    extraOptions = mkOpt attrs { } "Options to pass directly to home-manager";
  };

  config = {
    plusultra.home.extraOptions = {
      systemd.user.startServices = true;

      xdg.enable = true;
      xdg.configFile = mkAliasDefinitions options.plusultra.home.configFile;

      home.stateVersion = config.system.stateVersion;
      home.file = mkAliasDefinitions options.plusultra.home.file;
      home.packages = mkAliasDefinitions options.plusultra.home.packages;
      home.sessionVariables = mkAliasDefinitions options.plusultra.home.sessionVariables;
      home.shellAliases = mkAliasDefinitions options.plusultra.home.shellAliases;

      programs = mkAliasDefinitions options.plusultra.home.programs;
      services = mkAliasDefinitions options.plusultra.home.services;
    };

    home-manager = {
      useUserPackages = true;

      users.${config.plusultra.user.name} = mkAliasDefinitions options.plusultra.home.extraOptions;
    };
  };
}
