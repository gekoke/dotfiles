{
  options,
  config,
  lib,
  inputs,
  ...
}:

with lib;
with lib.elementary;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.elementary.home = with types; {
    enable = lib.mkEnableOption "home-manager wrapper";
    file = mkOpt attrs { } "A set of files to be managed by home-manager's <option>home.file</option>";
    configFile =
      mkOpt attrs { }
        "A set of files to be managed by home-manager's <option>xdg.configFile</option>";
    packages = mkOpt (listOf package) [ ] "Packages to pass to <option>packages</option>";
    programs = mkOpt attrs { } "Attributes to pass to <option>programs</option>";
    services = mkOpt attrs { } "Attributes to pass to <option>services</option>";
    sessionVariables = mkOpt (lazyAttrsOf (oneOf [
      str
      path
      int
      float
    ])) { } "Attributes to pass to <option>home.sessionVariables</option>";
    shellAliases = mkOpt (attrsOf str) { } "Attributes to pass to <option>home.shellAliases</option>";

    extraOptions = mkOpt attrs { } "Options to pass directly to home-manager";
  };

  config = lib.mkIf config.elementary.home.enable {
    elementary.home.extraOptions = {
      xdg.enable = true;
      xdg.configFile = mkAliasDefinitions options.elementary.home.configFile;

      home.stateVersion = config.system.stateVersion;
      home.file = mkAliasDefinitions options.elementary.home.file;
      home.packages = mkAliasDefinitions options.elementary.home.packages;
      home.sessionVariables = mkAliasDefinitions options.elementary.home.sessionVariables;
      home.shellAliases = mkAliasDefinitions options.elementary.home.shellAliases;

      programs = mkAliasDefinitions options.elementary.home.programs;
      services = mkAliasDefinitions options.elementary.home.services;

      nixpkgs.config.allowUnfree = true;
    };

    home-manager = {
      useUserPackages = true;

      users.${config.elementary.user.name} = mkAliasDefinitions options.elementary.home.extraOptions;
    };
  };
}
