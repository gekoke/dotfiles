{ pkgs
, mypkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.modules.style.pywal;
  walWrapper = pkgs.writeShellScriptBin "wal" ''
    # Force wal to use feh, since it's correctly patched
    # in the pywal Nix package
    XDG_CURRENT_DESKTOP="none"
    ${pkgs.pywal}/bin/wal "$@"
  '';
in
{
  options.modules.style.pywal = {
    enable = mkEnableOption "pywal wrapper";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      walWrapper
      mypkgs.python3Packages.pywalfox
    ];

    modules.browsers.firefox.extraExtensions = with config.nur.repos.rycee.firefox-addons; [
      pywalfox
    ];
  };
}
