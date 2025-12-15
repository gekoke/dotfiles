{
  self,
  ...
}:
{
  imports = [
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

  time.timeZone = "Europe/Tallinn";
}
