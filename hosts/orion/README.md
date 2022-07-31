```sh
nix build --extra-experimental-features 'nix-command flakes' .#nixosConfigurations.orion.activationPackage
./result/activate
sudo echo "/home/$USER/.nix-profile/bin/fish" >> /etc/shells
chsh $USER -s /home/$USER/.nix-profile/bin/fish
```

```fish
fish_add_path /home/$USER/.nix-profile/bin
```

