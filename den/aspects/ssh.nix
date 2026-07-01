{
  den.aspects.ssh.provides.to-users.homeManager = {
    services.ssh-agent.enable = true;
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "*".addKeysToAgent = "yes";
        "github.com".identitiesOnly = true;
      };
    };
  };
}
