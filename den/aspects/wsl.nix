{ inputs, ... }:
{
  den.aspects.wsl = {
    nixos =
      { host, ... }:
      let
        primaryUser = (builtins.head (builtins.attrValues host.users)).userName;
      in
      {
        imports = [ inputs.nixos-wsl.nixosModules.default ];

        wsl = {
          enable = true;
          defaultUser = primaryUser;
          wslConf.user.default = primaryUser;
        };
      };

    provides.to-users.homeManager =
      { pkgs, ... }:
      {
        home.shellAliases = {
          "cb" = "clip.exe";
          "cbo" = "powershell.exe Get-ClipBoard";
        };
        services.gpg-agent.pinentry.package = pkgs.pinentry-qt;
      };
  };
}
