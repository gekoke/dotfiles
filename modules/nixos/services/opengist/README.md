# OpenGist

## Updating

- Copy the image digest (e.g. `sha256:abc...`) from https://hub.docker.com/r/thomiceli/opengist
- Update `imageDigest` with the value
- Update `sha256` with garbage (to force re-fetch)

```nix
{
  # ...
  image = pkgs.dockerTools.pullImage {
    imageName = "thomiceli/opengist";
    finalImageName = "pullimage/thomiceli/opengist";
    imageDigest = "sha256:abc..."; # <- update this with the digest
    sha256 = "sha256-AAA..."; # <- put garbage here
  };
}
```

- Note the new `sha256` for the fetched image by running `nix build .#nixosConfigurations.neon.config.system.build.toplevel -L --accept-flake-config`

```
docker-image-pullimage-thomiceli-opengist-latest.tar> Copying config sha256:...
docker-image-pullimage-thomiceli-opengist-latest.tar> Writing manifest to image destination
error: hash mismatch in fixed-output derivation '/nix/store/...-docker-image-pullimage-thomiceli-opengist-latest.tar.drv':
           likely URL: (unknown)
            specified: sha256-AAA...
                  got: sha256-BBB...
        expected path: /nix/store/...-docker-image-pullimage-thomiceli-opengist-latest.tar
             got path: /nix/store/...-docker-image-pullimage-thomiceli-opengist-latest.tar
```
