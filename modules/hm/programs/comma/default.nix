{ lib
, pkgs
, config
, ...
}:
with lib; let
  cfg = config.modules.programs.comma;
  nixIndexUpdateScript = pkgs.writeShellScriptBin "nixindex" ''
    filename="index-x86_64-$(uname | tr A-Z a-z)"
    mkdir -p ~/.cache/nix-index
    cd ~/.cache/nix-index
    # -N will only download a new version if there is an update.
    ${pkgs.wget}/bin/wget -q -N https://github.com/Mic92/nix-index-database/releases/latest/download/$filename
    ln -f $filename files
  '';
in
{
  options.modules.programs.comma = {
    enable = mkEnableOption "Comma program";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nixIndexUpdateScript
      comma
    ];
  };
}
