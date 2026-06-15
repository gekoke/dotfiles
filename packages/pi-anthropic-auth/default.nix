{
  lib,
  stdenvNoCC,
  bun,
  fetchFromGitHub,
  nodejs,
  writableTmpDirAsHomeHook,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pi-anthropic-auth";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "cortexkit";
    repo = "anthropic-auth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GPVbDv9qaamk4gOEXaylTh9Bz4Ks7mklVjY64Pius34=";
  };

  node_modules = stdenvNoCC.mkDerivation {
    pname = "${finalAttrs.pname}-node_modules";
    inherit (finalAttrs) version src;

    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND"
      "SOCKS_SERVER"
    ];

    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;
    dontFixup = true;

    buildPhase = ''
      runHook preBuild

      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
      bun install \
        --cpu="*" \
        --frozen-lockfile \
        --ignore-scripts \
        --no-progress \
        --os="*"

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -R node_modules $out/

      runHook postInstall
    '';

    outputHash = "sha256-51qf3OcAc4jgWJ80avz+mBGVEcBtE+e2U0rgZPQM5aM=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

  nativeBuildInputs = [
    bun
    # `bun run build` runs `tsc`, which needs a `node` interpreter on PATH.
    nodejs
  ];

  configurePhase = ''
    runHook preConfigure

    cp -R ${finalAttrs.node_modules}/node_modules .
    patchShebangs node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    bun run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    core=$out/node_modules/@cortexkit/anthropic-auth-core
    mkdir -p $out/pi-anthropic-auth $core/dist

    # index.js transitively imports its siblings. Use a named directory rather
    # than `dist` so `pi` labels the loaded extension `pi-anthropic-auth`.
    cp packages/pi/dist/*.js $out/pi-anthropic-auth/

    # index.js imports @cortexkit/anthropic-auth-core; its package.json `main`
    # is needed to resolve the bare specifier, and index.js re-exports every
    # dist/ module.
    cp packages/core/package.json $core/package.json
    cp packages/core/dist/*.js $core/dist/

    # Sole runtime dependency of core.
    cp -RL node_modules/xxhash-wasm $out/node_modules/xxhash-wasm

    runHook postInstall
  '';

  dontFixup = true;

  meta = {
    description = "Pi package for CortexKit Anthropic OAuth support";
    homepage = "https://github.com/cortexkit/anthropic-auth";
    changelog = "https://github.com/cortexkit/anthropic-auth/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
