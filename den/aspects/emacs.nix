{ self, inputs, ... }:
{
  den.aspects.emacs =
    { user, ... }:
    {
      homeManager =
        {
          config,
          pkgs,
          ...
        }:
        {
          imports = [ inputs.agenix.homeManagerModules.default ];

          age.secrets.emacsAuthinfo = {
            file = ../../secrets/authinfo.age;
            path = "${config.home.homeDirectory}/.authinfo";
            mode = "700";
          };

          fonts.fontconfig.enable = true;

          home.packages = [
            user.emacs
            # keep-sorted start block=yes
            pkgs.nerd-fonts.blex-mono
            pkgs.nerd-fonts.caskaydia-cove
            pkgs.nerd-fonts.fira-code
            pkgs.nerd-fonts.iosevka
            pkgs.nerd-fonts.jetbrains-mono
            pkgs.nerd-fonts.victor-mono
            # keep-sorted end
            pkgs.noto-fonts-color-emoji
          ];
        };
    };

  den.schema.user =
    { host, lib, ... }:
    {
      options.emacs = lib.mkOption {
        type = lib.types.package;
        default = self.packages.${host.system}.elementary-emacs;
      };
    };
}
