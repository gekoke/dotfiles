{ den, ... }:
{
  den.aspects.work = {
    includes = [ den.aspects.agents ];

    nixos = {
      programs.nix-ld.enable = true;
      networking.firewall.allowedTCPPorts = [
        1499 # MSSQL container talking to the WSL host from Windows
      ];
    };

    provides = {
      geko =
        let
          workDir = "Work";
        in
        {
          homeManager = {
            home.file."${workDir}/.hmkeep".text = "";
            programs.git.includes = [
              {
                condition = "gitdir:~/${workDir}/";
                contents.user.email = "gregor.grigorjan@gamesglobal.com";
              }
            ];
          };
        };

      to-users.homeManager =
        { pkgs, ... }:
        {
          home.packages = [
            # keep-sorted start block=yes
            pkgs.azure-cli
            pkgs.bun
            pkgs.opencode
            pkgs.powershell
            # keep-sorted end
          ];
        };
    };
  };
}
