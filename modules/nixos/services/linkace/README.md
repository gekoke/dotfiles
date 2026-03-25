# Linkace

## Updating

- Copy the image digest (e.g. `sha256:cc008363bef22f3151b5b80faf2d13d3a073682b378e1e5d3f8f46972af2c9f9`) from https://hub.docker.com/r/linkace/linkace
- Update `imageDigest` with the value
- Update `sha256` with garbage (to force re-fetch)

```nix
{
  # ...
  image = pkgs.dockerTools.pullImage {
    imageName = "linkace/linkace";
    finalImageName = "pullimage/linkace/linkace";
    imageDigest = "sha256:cc008363bef22f3151b5b80faf2d13d3a073682b378e1e5d3f8f46972af2c9f9"; # <- update this with the digest
    sha256 = "sha256-o16818gKsuSH+VEensRpvg2Jf2jnL3oD582du/AzDPg="; # <- put garbage here
  };
}
```

- Note the new `sha256` for the fetched image by running `nix build .#nixosConfigurations.neon.config.system.build.toplevel -L --accept-flake-config`

```
docker-image-pullimage-linkace-linkace-latest.tar> Copying config sha256:6241844814f1a721d9bdd09e4958c28bd37b42962c17dc9989daaddd0a797942
docker-image-pullimage-linkace-linkace-latest.tar> Writing manifest to image destination
error: hash mismatch in fixed-output derivation '/nix/store/bz8piz62p41j4mb37cbvcgkw9w576awk-docker-image-pullimage-linkace-linkace-latest.tar.drv':
           likely URL: (unknown)
            specified: sha256-z/55523eNCNzTLYnafAeS6a9zEWJhkd1Sy333+PuVp4=
                  got: sha256-o16818gKsuSH+VEensRpvg2Jf2jnL3oD582du/AzDPg=
        expected path: /nix/store/nw28w2ag342anihizg88yj5izfaflwnv-docker-image-pullimage-linkace-linkace-latest.tar
             got path: /nix/store/i2ysi2j29x4v1y02wg9f16wvfm0jma8c-docker-image-pullimage-linkace-linkace-latest.t
```
