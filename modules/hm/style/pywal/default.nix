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
    pywalfox update
  '';
in
{
  options.modules.style.pywal = {
    enable = mkEnableOption "pywal warpper";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      walWrapper
      mypkgs.python3Packages.pywalfox
    ];

    programs.fish.shellInit = ''
      wal -R > /dev/null
    '';
  };
}
