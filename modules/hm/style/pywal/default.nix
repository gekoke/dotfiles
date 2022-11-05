{ pkgs
, mypkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.modules.style.pywal;
  wml = pkgs.writeShellScriptBin "wml" ''
    # Force wal to use feh, since it's correctly patched
    # in the pywal Nix package
    XDG_CURRENT_DESKTOP="none"
    wal "$@"
    pywalfox update
  '';
in {
  options.modules.style.pywal = {
    enable = mkEnableOption "pywal warpper";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      pywal
      wml
      mypkgs.python3Packages.pywalfox
    ];
  };
}
