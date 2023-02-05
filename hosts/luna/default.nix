{ config
, lib
, pkgs
, inputs
, user
, location
, ...
}: {
  modules = {
    loginmanagers.lightdm.enable = true;
    hardware.gpu.nvidia = {
      enable = true;
      digitalVibrance = 1023;
    };
  };

  nixpkgs.config.allowUnfree = true;

  # For lutris
  hardware.opengl.driSupport32Bit = true;

  system.stateVersion = "22.05";

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = "experimental-features = nix-command flakes";
    settings = {
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 10d";
    };
  };

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
  };

  security.sudo = {
    enable = true;
    extraRules = [{
      runAs = "root";
      groups = [ "wheel" ];
      commands = [{
        command = "/run/current-system/sw/bin/nixos-rebuild";
        options = [ "NOPASSWD" ];
      }];
    }];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
  };

  swapDevices = [ ];

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        devices = [ "nodev" ];
        useOSProber = true;
        gfxmodeEfi = "1920x1080";
      };
    };
    kernelParams = [
      #  TODO: Try to get lightdm to play nice
      #  "video=HDMI-0:1920x1080@239.96"
      "video=HDMI-0:1920x1080"
    ];
  };

  # Set timezone automatically using network
  services.tzupdate.enable = true;
  i18n.defaultLocale = "en_US.UTF-8";

  services = {
    xserver = {
      enable = true;
      windowManager.awesome.enable = true;
      displayManager.sessionCommands = ''
        xrandr --output HDMI-0 --mode 1920x1080 --rate 239.96 &
      '';
    };
    gnome.gnome-keyring.enable = true;
  };

  programs = {
    ssh = {
      startAgent = true;
    };
    dconf.enable = true;
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  environment.extraInit = ''
    # Do not want this in the environment. NixOS always sets it and does not
    # provide any option not to, so I must unset it myself via the
    # environment.extraInit option.
    unset -v SSH_ASKPASS
  '';

  networking = {
    hostName = "luna";
    wireless.enable = false;
    useDHCP = true;
    firewall.allowedTCPPorts = [ 10543 ]; # For serving files
  };
}
