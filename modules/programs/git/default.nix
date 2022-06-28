{ pkgs, ... }:
{
  programs = {
    git = {
      enable = true;

      signing = {
        signByDefault = false;
        key = "B4BE4DE6F6F29B82";
      };

      extraConfig = {
        init.defaultBranch = "main"; 
        credential.helper = "store";
      }; 
    };
  };
}
