<h1 align="center">
    dotfiles
    <img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/palette/macchiato.png" width="800px"/>
</h1>

<div align="center">
    <img alt="Declared With Emacs" src="https://img.shields.io/static/v1?logo=gnu-emacs&logoColor=white&label=Declared%20with&labelColor=7547B4&message=Emacs&color=d8dee9&style=for-the-badge">
    <img alt="Built With Nix" src="https://img.shields.io/static/v1?logo=nixos&logoColor=d8dee9&label=Built%20With&labelColor=5e81ac&message=Nix&color=d8dee9&style=for-the-badge">
    <img alt="License" src="https://img.shields.io/static/v1.svg?style=for-the-badge&label=License&message=AGPL-3.0&labelColor=74be88&color=d8dee9"/>
</div>

# Development

```sh
direnv allow
```

## Updating GitHub Actions

```sh
pinact run -u
```

## Updating in-tree package outputs

```sh
nix-update --build --commit --flake <PKG_OUTPUT_NAME> # e.g. `connections` - must be run in the project's root
```
