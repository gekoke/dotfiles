{
  inputs,
  config,
  lib,
  ...
}:

with lib;
with lib.elementary;
let
  cfg = config.elementary.nix;
in
{
  options.elementary.nix = with types; {
    enable = mkEnableOption "Nix configuration";
  };

  config = mkIf cfg.enable {
    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        dates = "daily";
        extraArgs = "--nogcroots";
      };
    };

    nix = {
      registry = {
        p.flake = inputs.nixpkgs;
        s.flake = inputs.self;
      };
      settings =
        let
          users = [
            "root"
            config.elementary.user.name
          ];
        in
        {
          experimental-features = "nix-command flakes";
          auto-optimise-store = true;
          trusted-users = users;
          allowed-users = users;
          keep-outputs = true;
          keep-derivations = true;
        };
    };
  };
}
