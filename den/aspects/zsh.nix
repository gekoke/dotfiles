{
  den.aspects.zsh.provides.to-users.homeManager =
    { config, pkgs, ... }:
    {
      home.packages = [ pkgs.trash-cli ];

      programs = {
        zsh = {
          enable = true;
          shellAliases.dl = "trash";
          syntaxHighlighting.enable = true;
          autosuggestion.enable = true;
          autocd = true;
          history = {
            # `2^63 - 1` — effectively unlimited.
            size = 9223372036854775807;
            save = 9223372036854775807;
          };
          # Pin the pre-26.05 default (home directory) so a stateVersion bump
          # doesn't silently relocate history/config on disk.
          dotDir = config.home.homeDirectory;
        };
        eza = {
          enable = true;
          icons = "auto";
        };
        zoxide = {
          enable = true;
          enableZshIntegration = true;
        };
        starship = {
          enable = true;
          enableZshIntegration = true;
          settings.username.show_always = true;
        };
        atuin = {
          enable = true;
          enableZshIntegration = true;
          flags = [ "--disable-up-arrow" ];
          settings = {
            inline_height = 30;
            style = "compact";
          };
        };
      };
    };
}
