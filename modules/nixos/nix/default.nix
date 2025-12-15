{
  inputs,
  config,
  pkgs,
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
        extraArgs = "--no-gcroots --keep-since 1w --keep 10 --optimise";
      };
    };

    nix = {
      package = pkgs.lixPackageSets.stable.lix;
      registry = {
        p.flake = inputs.nixpkgs;
        u.flake = inputs.nixpkgs-unfree;
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
