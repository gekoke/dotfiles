{ pkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.modules.dev.csharp;
in {
  options.modules.dev.csharp = {
    enable = mkEnableOption "C# dev support";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      dotnet-sdk_6
      omnisharp-roslyn
      mono6
    ];
  };
}
