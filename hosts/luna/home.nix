{ config
, lib
, pkgs
, user
, ...
}:
with lib;
{
  config = {
    nixpkgs.config.allowUnfree = true;

    home = {
      username = "${user}";
      homeDirectory = "/home/${user}";
      stateVersion = "22.05";

      keyboard = {
        layout = "ee";
        variant = "us";
      };

      packages = with pkgs; [
        bitwarden
        neofetch
        coreutils
        tldr
        spotify
        discord
        teamspeak_client
        signal-desktop
        element-desktop

        ajour
        lutris

        brave

        pavucontrol

        docker-compose

        xclip
      ];
    };

    programs = {
      home-manager.enable = true;
      git = {
        userName = "gekoke";
        userEmail = "gekoke@lazycantina.xyz";
      };
      mpv.enable = true;
      rtorrent.enable = true;
    };

    services = {
      unclutter = {
        enable = true;
        timeout = 5;
      };
    };

    modules = {
      windowmanagers.awesome.enable = true;

      dev = {
        nix.enable = true;
        c.enable = true;
        prolog.enable = true;
        haskell.enable = true;
        python.enable = true;
        lua.enable = true;
      };

      editors = {
        enable = true;
        default = "nvim";
        neovim = {
          enable = true;
          enableNix = true;
          colorscheme = "nord";
        };
        emacs.enable = true;
      };

      browsers = {
        enable = true;
        default = "qutebrowser";
        qutebrowser.enable = true;
        firefox.enable = true;
      };

      terminals = {
        enable = true;
        alacritty.enable = true;
      };

      shells.fish = {
        enable = true;
        enableFlashyPrompt = true;
        enableFileIcons = true;
      };

      programs = {
        flameshot.enable = true;
        comma.enable = true;
        ranger.enable = true;
        git.enable = true;
        rofi.enable = true;
        gpg.enable = true;
      };

      services = {
        mediakeys.enable = true;
        email.enable = true;
        picom.enable = true;
      };

      style = {
        pointer.enable = true;
        pywal.enable = true;
      };
    };
  };
}
