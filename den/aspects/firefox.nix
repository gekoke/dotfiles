{ inputs, ... }:
{
  den.aspects.firefox.provides.to-users.homeManager =
    { pkgs, ... }:
    {
      programs.firefox = {
        enable = true;
        package = pkgs.firefox;
        profiles."default" = {
          name = "Default";
          isDefault = true;
          extensions.packages = builtins.attrValues {
            inherit (inputs.nur.legacyPackages.${pkgs.stdenv.hostPlatform.system}.repos.rycee.firefox-addons)
              bitwarden
              privacy-badger
              sponsorblock
              ublock-origin
              vimium
              ;
          };
          settings = {
            "browser.aboutconfig.showwarning" = false; # Don't show warning when opening about:config
            "browser.aboutwelcome.enabled" = false; # Onboarding - "You’re in safe paws" yada yada yada
            "browser.contentblocking.category" = "strict"; # Firefox Tracking Protection = Strict
            "browser.disableResetPrompt" = true; # Disable "Looks like you haven't started Firefox in a while."
            "browser.onboarding.enabled" = false; # Disable new-user tour
            "browser.shell.checkDefaultBrowser" = false; # Don't warn about not being default browser
            "browser.tabs.firefox-view" = false; # Disable "Firefox View" button on home bar
            "browser.uidensity" = 1; # Set UI density to compact
            "extensions.pocket.enabled" = false; # Disable "pocket" button on home bar
            "extensions.update.enabled" = false;
            "full-screen-api.warning.timeout" = 0; # Disable "You're in fullscreen" message
            "media.hardwaremediakeys.enabled" = false; # Media keys conflict with Spotify etc.
            "signon.rememberSignons" = false; # Don't use Firefox password manager
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # Enable userChrome.css
          };
        };
      };
    };
}
