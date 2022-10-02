{pkgs, ...}: {
  programs = {
    alacritty = {
      enable = true;

      settings = {
        window = {
          opacity = 0.82;
          background = "#dddef1";
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
