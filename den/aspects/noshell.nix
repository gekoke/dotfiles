{ inputs, ... }:
{
  den.aspects.noshell = {
    nixos = {
      imports = [ inputs.noshell.nixosModules.default ];
      programs.noshell.enable = true;
    };

    provides.to-users.homeManager =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        xdg.configFile = {
          "zsh".source = lib.getExe pkgs.zsh;
          "shell" = {
            executable = true;
            text = ''
              exec ${config.xdg.configHome}/zsh "$@"
            '';
          };
        };
      };
  };
}
