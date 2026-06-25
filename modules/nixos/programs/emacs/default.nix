{
  config,
  lib,
  pkgs,
  inputs,
  self,
  ...
}:
let
  inherit (lib)
    attrValues
    filter
    mkEnableOption
    mkIf
    mkOption
    ;
  inherit (lib.attrsets) isDerivation;
  inherit (lib.types) package;
  cfg = config.elementary.programs.emacs;
in
{
  imports = [ inputs.agenix.nixosModules.default ];

  options.elementary.programs.emacs = {
    enable = mkEnableOption "GNU Emacs";
    package = mkOption {
      type = package;
      default = self.packages.${pkgs.stdenv.hostPlatform.system}.elementary-emacs;
    };
  };

  config = mkIf cfg.enable {
    elementary.home.extraOptions.fonts.fontconfig.enable = true;

    elementary.home.packages =
      let
        allNerdFonts = filter isDerivation (attrValues pkgs.nerd-fonts);
      in
      [
        cfg.package
        # keep-sorted start block=yes
        pkgs.noto-fonts-color-emoji
        # keep-sorted end
      ]
      ++ allNerdFonts;

    age.secrets.emacsAuthinfo = lib.mkIf config.elementary.secrets.enable {
      file = ./../../../../secrets/authinfo.age;
      owner = config.elementary.user.name;
      path = "${config.users.users.${config.elementary.user.name}.home}/.authinfo";
      mode = "700";
    };
  };
}
