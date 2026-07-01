rec {
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org?priority=41"
      "https://gekoke-dotfiles.cachix.org?priority=42"
      "https://niri.cachix.org?priority=43"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "gekoke-dotfiles.cachix.org-1:mED8HYGwRLMcDvi54a/Qxl5LshQtOXRt3rlXHw4GkDw="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
    ];
  };

  inputs = {
    # keep-sorted start
    abiopetaja.url = "github:gekoke/abiopetaja";
    agenix-shell.url = "github:aciceri/agenix-shell";
    agenix.url = "github:ryantm/agenix";
    dank-material-shell.url = "github:AvengeMedia/DankMaterialShell";
    den.url = "github:denful/den";
    dgop.url = "github:AvengeMedia/dgop";
    disko.url = "github:nix-community/disko";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager.url = "github:nix-community/home-manager";
    import-tree.url = "github:denful/import-tree";
    niri-flake.url = "github:sodiboo/niri-flake";
    nix-pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixpkgs-emacs-packages.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-emacs-runtime.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-emacs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-for-opentofu.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unfree.url = "github:numtide/nixpkgs-unfree";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    noshell.url = "git+https://codeberg.org/viperML/noshell";
    nur.url = "github:nix-community/NUR";
    pi.inputs.nixpkgs.follows = "nixpkgs";
    pi.url = "github:lukasl-dev/pi.nix";
    proxytunnel.url = "github:proxytunnel/proxytunnel";
    systems.url = "github:nix-systems/default-linux";
    website.url = "github:gekoke/website";
    # keep-sorted end
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      imports = [
        inputs.den.flakeModule
        (inputs.import-tree ./den)
      ];
    };
}
