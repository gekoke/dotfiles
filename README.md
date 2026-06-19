# runelite [![CI](https://github.com/runelite/runelite/workflows/CI/badge.svg)](https://github.com/gekoke/runelite/actions?query=workflow%3ACI+branch%3Amaster)

A [RuneLite](https://github.com/runelite/runelite/) build with [`ClickToMinimize`](https://github.com/WaylonJ/OSRS_ClickToMinimize) built in, developer mode gates removed, and plugin side-loading enabled by default.

## Usage

Get the latest version of `client-gekoke.jar` from [Releases](https://github.com/gekoke/runelite/releases/).

### RuneLite Launcher

If you have an existing RuneLite installation, you just have to point the launcher to the the custom client `.jar` file:

- Move `client-gekoke.jar` to `$RUNELITE_DIR/repository2`
  - On Windows, this defaults to `%USERPROFILE%\.runelite\repository2\`
- Pass `--classpath client-gekoke.jar` when running the RuneLite launcher (`RuneLite.exe` on Windows)
  - On Windows, you can edit the existing `RuneLite` shortcut: *right click -> Properties -> Shortcut -> `[...] --classpath client-gekoke.jar`* - or, just create a new shortcut.

### Standalone

Alternatively, just run `java -jar client-gekoke.jar`. This bypasses the launcher shenanigans entirely, but requires a `java` installation.

## Sideloading Plugins

Simply place plugin `.jar` files in (defaults to `%USERPROFILE%\.runelite\sideloaded-plugins` on Windows).
