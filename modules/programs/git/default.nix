{ pkgs, ... }:
{
  programs = {
    git = {
      enable = true;

      userName = "gekoke";
      userEmail = "gekoke@lazycantina.xyz";

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
