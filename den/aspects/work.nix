{ inputs, self, ... }:
{
  den.aspects.work = {
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
          imports = [ inputs.pi.homeModules.default ];

          home.packages = [
            # keep-sorted start block=yes
            pkgs.azure-cli
            pkgs.bun
            pkgs.opencode
            pkgs.powershell
            # keep-sorted end
          ];

          programs.pi.coding-agent = {
            enable = true;
            extraArgs = [ "--offline" ];
            extensions = [
              "${self.packages.${pkgs.stdenv.hostPlatform.system}.pi-anthropic-auth}/pi-anthropic-auth/index.js"
            ];
          };
        };
    };
  };
}
