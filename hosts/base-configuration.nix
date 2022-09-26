{
  config,
  lib,
  pkgs,
  inputs,
  user,
  location,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "22.05";

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = "experimental-features = nix-command flakes";
    settings = {
      auto-optimise-store = true;
    };
  };

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    shell = pkgs.fish;
  };

  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      efiSupport = true;
      devices = ["nodev"];
      useOSProber = true;
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    htop
    git
  ];

  services.gnome.gnome-keyring.enable = true;

  time.timeZone = "Europe/Tallinn";
  i18n.defaultLocale = "en_US.UTF-8";

  imports = [
    ../config/system/services/xserver
  ];

  programs.dconf.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  environment.extraInit = ''
    # Do not want this in the environment. NixOS always sets it and does not
    # provide any option not to, so I must unset it myself via the
    # environment.extraInit option.
    unset -v SSH_ASKPASS
  '';
}
