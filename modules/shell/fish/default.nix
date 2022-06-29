{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.modules.fish;
in {
  options.modules.fish = {
    enableFlashyPrompt = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = (mkMerge [
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
            ll = "ls -l";
          };
        };
      };

      home.sessionVariables = {
        fish_prompt_pwd_dir_length = 0;
      };
    })
  ]);
}
