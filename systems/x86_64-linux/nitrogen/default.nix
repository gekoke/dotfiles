{
  self,
  lib,
  ...
}:
{
  imports = [
    self.nixosModules."constants"
    self.nixosModules."roles.work"
    self.nixosModules."roles.workstation"
    self.nixosModules."roles.wsl"
  ];

  system.stateVersion = "25.11";

  roles = {
    work.enable = true;
    workstation.enable = true;
    wsl.enable = true;
  };

  elementary.secrets.enable = lib.mkForce false;

  home-manager = {
    sharedModules = [ self.homeModules."identities.geko" ];
    users.lev = {
      identities.geko.enable = lib.mkForce false;
      programs.git.includes = lib.mkForce [ ];
    };
  };

  constants.default.user.name = "lev";

  time.timeZone = "Europe/Tallinn";

  # HACK: see https://github.com/nix-community/NixOS-WSL/issues/375#issuecomment-2411845271
  systemd.tmpfiles.rules = [
    "f /var/lib/systemd/linger/lev"
  ];
}
