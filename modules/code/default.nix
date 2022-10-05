{ pkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.modules.code;
in
{
  options.modules.code = {
    enable = mkEnableOption "VSCode";
    enableRust = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.vscode = {
        enable = true;
        extensions = with pkgs.vscode-extensions; [
          arrterian.nix-env-selector
        ];
      };
    }

    (mkIf (cfg.enableRust) {
      programs.vscode.extensions = with pkgs.vscode-extensions; [
        matklad.rust-analyzer
      ];
    })
  ]);
}
