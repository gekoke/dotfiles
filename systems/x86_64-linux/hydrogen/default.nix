{
  inputs,
  self,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
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

  home-manager = {
    sharedModules = [ self.homeModules."identities.geko" ];
    users.geko.identities.geko.enable = true;
  };

  time.timeZone = "Europe/Tallinn";
}
