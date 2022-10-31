{ lib
, pkgs
, config
, ...
}:
with lib; let
  cfg = config.modules.shells.fish;
  exaIconsOption =
    if cfg.enableFileIcons
    then "--icons"
    else "";
in
{
  options.modules.shells.fish = {
    enable = mkEnableOption "Fish shell";
    enableFlashyPrompt = mkEnableOption "flashy shell prompt";
    enableFileIcons = mkEnableOption "icons when using ls (exa)";
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
