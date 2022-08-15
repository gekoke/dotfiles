{pkgs, ...}: {
  programs.gpg = {
    enable = true;
    settings = {
      default-key = "B4BE4DE6F6F29B82";
    };
  };

  services.gpg-agent = {
    enable = true;
  };

  home.packages = with pkgs; [pinentry];
}
