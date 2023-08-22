{ config, lib, pkgs, ... }:

with lib;
let cfg = config.plusultra.programs.firefox;
in
{
  options.plusultra.programs.firefox = with types; {
    enable = mkEnableOption "Firefox";
    extraExtensions = mkOpt (listOf package) [ ] "Extra extensions to add to Firefox";
  };

  config = mkIf cfg.enable {
    plusultra.home.sessionVariables.MOZ_ENABLE_WAYLAND = 1;

    plusultra.home.programs.firefox = {
      enable = true;
      package = pkgs.firefox-wayland;
      profiles."default" = {
        name = "Default";
        isDefault = true;
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          privacy-badger
          ublock-origin
          vimium
          bitwarden
          sponsorblock
        ] ++ cfg.extraExtensions;
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # Enable userChrome.css
          "media.hardwaremediakeys.enabled" = false; # Disable media keys in Firefox - conflicts with Spotify etc. when audio is playing in browser
          "browser.tabs.firefox-view" = false; # Disable "Firefox View" button on home bar
          "extensions.pocket.enabled" = false; # Disable "pocket" button on home bar
          "browser.uidensity" = 1; # Set UI density to compact
          "browser.shell.checkDefaultBrowser" = false; # Don't show annoying warning about browser not being default
          "browser.aboutconfig.showwarning" = false; # Don't show warning when opening about:config
          "signon.rememberSignons" = false; # Don't use Firefox password manager
          "browser.disableResetPrompt" = true; # Disable "Looks like you haven't started Firefox in a while."
          "browser.onboarding.enabled" = false; # Disable "New to Firefox? Let's get started!" tour
          "full-screen-api.warning.timeout" = 0; # Disable "You're in fullscreen" message
          "browser.contentblocking.category" = "strict"; # Set Firefox Tracking Protection to "Strict"
        };
      };
    };
  };
}
