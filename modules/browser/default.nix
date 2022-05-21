let
  defaultBrowserDesktopFile = "org.qutebrowser.qutebrowser.desktop";
in {
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
}
