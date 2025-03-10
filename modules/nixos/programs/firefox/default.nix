{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.elementary.programs.firefox =
    let
      inherit (lib) mkEnableOption;
      inherit (lib.types) listOf package;
      inherit (lib.elementary) mkOpt;
    in
    {
      enable = mkEnableOption "Firefox";
      extraExtensions = mkOpt (listOf package) [ ] "Extra extensions to add to Firefox";
    };

  config =
    let
      inherit (lib) mkIf;
      cfg = config.elementary.programs.firefox;
    in
    mkIf cfg.enable {
      elementary.home.sessionVariables.MOZ_ENABLE_WAYLAND = 1;

      elementary.home.programs.firefox = {
        enable = true;
        package = pkgs.firefox-wayland;
        profiles."default" = {
          name = "Default";
          isDefault = true;
          extensions.packages =
            builtins.attrValues {
              inherit (pkgs.nur.repos.rycee.firefox-addons)
                bitwarden
                privacy-badger
                sponsorblock
                ublock-origin
                vimium
                ;
            }
            ++ cfg.extraExtensions;
          settings = {
            "browser.aboutconfig.showwarning" = false; # Don't show warning when opening about:config
            "browser.contentblocking.category" = "strict"; # Set Firefox Tracking Protection to "Strict"
            "browser.disableResetPrompt" = true; # Disable "Looks like you haven't started Firefox in a while."
            "browser.onboarding.enabled" = false; # Disable "New to Firefox? Let's get started!" tour
            "browser.shell.checkDefaultBrowser" = false; # Don't show annoying warning about browser not being default
            "browser.tabs.firefox-view" = false; # Disable "Firefox View" button on home bar
            "browser.uidensity" = 1; # Set UI density to compact
            "extensions.pocket.enabled" = false; # Disable "pocket" button on home bar
            "full-screen-api.warning.timeout" = 0; # Disable "You're in fullscreen" message
            "media.hardwaremediakeys.enabled" = false; # Disable media keys in Firefox - conflicts with Spotify etc. when audio is playing in browser
            "signon.rememberSignons" = false; # Don't use Firefox password manager
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # Enable userChrome.css
          };
        };
      };
    };
}
