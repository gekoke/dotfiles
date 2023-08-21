{ config, lib, ... }:

with lib;
let cfg = config.plusultra.nix;
in {
  options.plusultra.nix = with types; {
    enable = mkEnableOption "Nix configuration";
  };

  config = mkIf cfg.enable {
    nix =
      let users = [ "root" config.plusultra.user.name ];
      in {
        settings = {
          experimental-features = "nix-command flakes impure-derivations ca-derivations";
          http-connections = 0; # Unlimited
          auto-optimise-store = true;
          trusted-users = users;
          allowed-users = users;
        } // (lib.optionalAttrs config.plusultra.programs.direnv.enable {
          keep-outputs = true;
          keep-derivations = true;
        });

        gc = {
          automatic = true;
          dates = "daily";
          options = "--delete-older-than 30d";
        };
      };
  };
}
