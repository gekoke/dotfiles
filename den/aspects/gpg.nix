{
  den.aspects.gpg.provides.to-users.homeManager = {
    programs.gpg.enable = true;
    services.gpg-agent =
      let
        ttlInSeconds = 8 * 60 * 60;
      in
      {
        enable = true;
        defaultCacheTtl = ttlInSeconds;
        maxCacheTtl = ttlInSeconds;
      };
  };
}
