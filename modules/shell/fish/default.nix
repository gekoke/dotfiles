{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.modules.fish;
  exaIconsOption = if cfg.enableFileIcons then "--icons" else "";
in {
  options.modules.fish = {
    enable = mkEnableOption "Fish shell";
    enableFlashyPrompt = mkOption {
      type = types.bool;
      default = true;
    };
    enableFileIcons = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf (cfg.enableFlashyPrompt) {
      home.packages = with pkgs;
        [
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

    ({
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
          };
        };
      };

      home = {
        packages = with pkgs; [ exa ];

        sessionVariables = {
          fish_prompt_pwd_dir_length = 0;
        };
      };
    })
  ]);
}
