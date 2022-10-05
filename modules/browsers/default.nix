{ pkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.modules.browsers;
  defaultBrowserDesktopFile = getAttr cfg.default {
    qutebrowser = "org.qutebrowser.qutebrowser.desktop";
    brave = "brave-browser.desktop";
    firefox = "firefox.desktop";
  };
in
{
  imports = [
    ./firefox
    ./brave
    ./qutebrowser
  ];

  options.modules.browsers = {
    enable = mkEnableOption "Browser module";
    default = mkOption {
      type = types.str;
      default = "qutebrowser";
    };
  };

  config = mkIf cfg.enable {
    xdg.mime.enable = true;
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = defaultBrowserDesktopFile;
        "x-scheme-handler/http" = defaultBrowserDesktopFile;
        "x-scheme-handler/https" = defaultBrowserDesktopFile;
        "x-scheme-handler/about" = defaultBrowserDesktopFile;
        "x-scheme-handler/unknown" = defaultBrowserDesktopFile;
      };
    };

    services.sxhkd = {
      enable = true;
      keybindings = {
        "super + shift + w" = cfg.default;
      };
    };
  };
}
