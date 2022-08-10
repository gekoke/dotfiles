{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.modules.fish;
  exaIconsOption =
    if cfg.enableFileIcons
    then "--icons"
    else "";
in {
  options.modules.fish = {
    enable = mkEnableOption "Fish shell";
    enableFlashyPrompt = mkEnableOption "Enable flashy shell prompt with neofetch, figlet et al";
    enableFileIcons = mkEnableOption "Enable icons when using ls (exa)";
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf (cfg.enableFlashyPrompt) {
      home.packages = with pkgs; [
        neofetch
        lolcat
        boxes
        fortune
      ];
      xdg.configFile."fish/conf.d/greeting.fish".source = ./config/conf.d/greeting.fish;
    })

    (mkIf (!cfg.enableFlashyPrompt) {
      home.sessionVariables.fish_greeting = "";
    })

    {
      programs = {
        fzf = {
          enable = true;
          enableFishIntegration = true;
        };

        fish = {
          enable = true;

          shellAliases = {
            ls = "exa ${exaIconsOption}";
            la = "exa -a ${exaIconsOption}";
            ll = "exa -l ${exaIconsOption}";
            i = "grep -i";
            x = "grep";
            cal = "ncal -b -M -A2";
            dl = "trash";
            rm = "echo 'Are you sure mate'";
          };
        };
      };

      home = {
        packages = with pkgs; [
          exa
          trash-cli
        ];

        sessionVariables = {
          fish_prompt_pwd_dir_length = 0;
        };
      };
    }
  ]);
}
