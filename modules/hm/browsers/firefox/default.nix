{ pkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.modules.browsers.firefox;
in
{
  options.modules.browsers.firefox = {
    enable = mkEnableOption "Firefox";
    extraExtensions = mkOption {
      type = types.listOf types.package;
    };
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      profiles."default" = {
        name = "Default";
        isDefault = true;
        extensions = with config.nur.repos.rycee.firefox-addons; [
          privacy-badger
          ublock-origin
          vimium
          bitwarden
        ] ++ cfg.extraExtensions;
        settings = {
          "media.hardwaremediakeys.enabled" = false;     # Disable media keys in Firefox - conflicts with Spotify etc. when audio is playing in browser
          "browser.tabs.firefox-view"= false;            # Disable "Firefox View" button on home bar
          "extensions.pocket.enabled" = false;           # Disable "pocket" button on home bar
          "browser.uidensity" = 1;                       # Set UI density to compact
          "browser.shell.checkDefaultBrowser" = false;   # Don't show annoying warning about browser not being default
          "browser.aboutconfig.showwarning" = false;     # Don't show warning when opening about:config
          "signon.rememberSignons" = false;              # Don't use Firefox password manager
          "browser.disableResetPrompt" = true;           # Disable "Looks like you haven't started Firefox in a while."
          "browser.onboarding.enabled" = false;          # Disable "New to Firefox? Let's get started!" tour
          "full-screen-api.warning.timeout" = 0;         # Disable "You're in fullscreen" message
          "browser.contentblocking.category" = "strict"; # Set Firefox Tracking Protection to "Strict"
        };
      };
    };
  };
}
