{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.org;
  bw-cli = pkgs.bitwarden-cli;
  orgInitScript = pkgs.writeShellScriptBin "orginit" ''
    password=$(${bw-cli}/bin/bw get password 94de01e0-2bb1-45fd-af92-aea50128cb02)
    git clone "https://organicesync:$password@gitlab.com/organicesync/organice-sync/" "$HOME/org"
  '';
in {
  options.modules.org = {
    enable = mkEnableOption "Whether to set up Org mode directory";
  };

  config = mkIf cfg.enable {
    xdg.enable = true;

    home.packages = with pkgs; [
      orgInitScript
      bitwarden-cli
    ];
  };
}
