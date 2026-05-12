{
  self,
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    self.nixosModules."roles.work"
    self.nixosModules."roles.workstation"
    self.nixosModules."roles.wsl"
  ];

  system.stateVersion = "24.11";

  roles = {
    work.enable = true;
    workstation.enable = true;
    wsl.enable = true;
  };

  elementary.programs.emacs.package =
    self.packages.${pkgs.stdenv.hostPlatform.system}.elementary-emacs-pgtk;

  home-manager = {
    sharedModules = [
      self.homeModules."identities.geko"
      { xdg.userDirs.setSessionVariables = false; }
    ];
    users.${config.constants.default.user.name}.identities.geko.enable = true;
  };

  time.timeZone = "Europe/Tallinn";
}
