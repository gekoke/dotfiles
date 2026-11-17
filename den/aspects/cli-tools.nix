_: {
  den.aspects.cli-tools.provides.to-users.homeManager =
    {
      osConfig,
      pkgs,
      lib,
      ...
    }:
    {
      home.file.".parallel/will-cite".text = "";

      home.packages = [
        # keep-sorted start
        (lib.hiPrio pkgs.parallel-full) # `pkgs.moreutils` provides `parallel` as well
        (lib.mkIf osConfig.virtualisation.docker.enable pkgs.docker-compose)
        pkgs.bat
        pkgs.btop
        pkgs.dig
        pkgs.dos2unix
        pkgs.efibootmgr
        pkgs.exfat
        pkgs.jq
        pkgs.jwt-cli
        pkgs.moreutils # -> `sponge` et al
        pkgs.p7zip
        pkgs.ripgrep
        pkgs.rsbkb
        pkgs.tldr
        pkgs.units
        pkgs.wget
        pkgs.xxd
        pkgs.zip
        # keep-sorted end
      ];
    };
}
