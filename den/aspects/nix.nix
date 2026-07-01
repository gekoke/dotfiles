{ inputs, lib, ... }:
{
  den.default.nixos = {
    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        dates = lib.mkDefault "weekly";
      };
    };

    nix = {
      registry = {
        p.flake = inputs.nixpkgs;
        u.flake = inputs.nixpkgs-unfree;
      };
      settings.keep-outputs = true;
      settings.keep-derivations = true;
      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}
