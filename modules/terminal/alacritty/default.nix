{pkgs, ...}: {
  programs = {
    alacritty = {
      enable = true;

      settings = {
        window = {
          opacity = 0.8;
        };
        font = {
          normal = {
            family = "Iosevka Nerd Font";
          };
        };
      };
    };
  };

  home = {
    packages = with pkgs; [
      (nerdfonts.override {fonts = ["Iosevka"];})
    ];
  };
}
