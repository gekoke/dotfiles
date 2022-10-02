{pkgs, ...}: {
  programs = {
    alacritty = {
      enable = true;

      settings = {
        colors = {
          primary = {
            background = "#2E3440";
          };
        };
        window = {
          opacity = 1;
        };
        font = {
          normal = {
            family = "JetBrainsMono Nerd Font";
            style = "semibold";
          };
        };
      };
    };
  };

  home = {
    packages = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "Iosevka"
          "JetBrainsMono"
        ];
      })
    ];
  };

  services.sxhkd = {
    enable = true;
    keybindings."super + apostrophe" = "alacritty";
  };
}
