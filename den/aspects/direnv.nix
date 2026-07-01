{
  den.aspects.direnv.provides.to-users.homeManager.programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config.global.hide_env_diff = true;
  };
}
