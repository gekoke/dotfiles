{ den, ... }:
{
  den.aspects.workstation = {
    includes = [
      den.aspects.noshell
      den.aspects.cli-tools
      den.aspects.direnv
      den.aspects.git
      den.aspects.gpg
      den.aspects.nh
      den.aspects.ssh
      den.aspects.zsh
    ];

    nixos = {
      security.sudo.wheelNeedsPassword = false;
      virtualisation.docker.enable = true;

      programs.nh.clean = {
        dates = "daily";
        extraArgs = "--no-gcroots --keep-since 1w --keep 10 --optimise";
      };
    };

    provides.to-users = {
      homeManager =
        { config, lib, ... }:
        {
          xdg.userDirs = {
            enable = true;
            createDirectories = true;
            setSessionVariables = false;
          };

          # This is cringe beyond belief
          # See: https://pkg.go.dev/cmd/go#hdr-GOPATH_environment_variable
          home.sessionVariables.GOPATH = lib.path.append (/. + config.xdg.dataHome) "go";
        };
    };
  };
}
