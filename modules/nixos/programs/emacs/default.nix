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
    mkEnableOption
    mkIf
    mkOption
    ;
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

    elementary.home.packages = [
      cfg.package
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

    age.secrets.emacsAuthinfo = lib.mkIf config.elementary.secrets.enable {
      file = ./../../../../secrets/authinfo.age;
      owner = config.elementary.user.name;
      path = "${config.users.users.${config.elementary.user.name}.home}/.authinfo";
      mode = "700";
    };
  };
}
