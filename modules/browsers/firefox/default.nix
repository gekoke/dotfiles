{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.browsers.firefox;
in {
  options.modules.browsers.firefox = {
    enable = mkEnableOption "Firefox module";
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      extensions = with config.nur.repos.rycee.firefox-addons; [
        privacy-badger
        ublock-origin
        vimium
        bitwarden
      ];
      profiles."default" = {
        bookmarks = { };
        settings = {
          # --- Appearance ---
          "devtools.theme" = "dark";
          "browser.theme.dark-private-windows" = true;
          # Reduce search engine noise in the urlbar's completion window. The
          "browser.urlbar.suggest.searches" = false;
          "browser.urlbar.shortcuts.bookmarks" = false;
          "browser.urlbar.shortcuts.history" = false;
          "browser.urlbar.shortcuts.tabs" = false;
          "browser.urlbar.showSearchSuggestionsFirst" = false;
          "browser.urlbar.speculativeConnect.enabled" = false;
          "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
          "browser.urlbar.suggest.quicksuggest.sponsored" = false;
          "services.sync.prefs.sync.browser.uiCustomization.state" = true;

          # --- Privacy ---
          "security.family_safety.mode" = 0;
          "browser.contentblocking.category" = "strict";
          "privacy.donottrackheader.enabled" = true;
          "privacy.donottrackheader.value" = 1;
          "privacy.purge_trackers.enabled" = true;
          # Disable Activity Stream (https://wiki.mozilla.org/Firefox/Activity_Stream)
          "browser.newtabpage.activity-stream.enabled" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          # Use Mozilla geolocation service instead of Google if given permission
          "geo.provider.network.url" = "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
          "geo.provider.use_gpsd" = false;
          "extensions.getAddons.showPane" = false; # Uses Google Analytics
          "browser.discovery.enabled" = false;
          # Disable battery API
          # https://developer.mozilla.org/en-US/docs/Web/API/BatteryManager
          # https://bugzilla.mozilla.org/show_bug.cgi?id=1313580
          "dom.battery.enabled" = false;
          # Disable "beacon" asynchronous HTTP transfers (used for analytics)
          # https://developer.mozilla.org/en-US/docs/Web/API/navigator.sendBeacon
          "beacon.enabled" = false;
          # Disable pinging URIs specified in HTML <a> ping= attributes
          # http://kb.mozillazine.org/Browser.send_pings
          "browser.send_pings" = false;
          # Disable gamepad API to prevent USB device enumeration
          # https://www.w3.org/TR/gamepad/
          # https://trac.torproject.org/projects/tor/ticket/13023
          "dom.gamepad.enabled" = false;
          # Don't try to guess domain names when entering an invalid domain name in URL bar
          # http://www-archive.mozilla.org/docs/end-user/domain-guessing.html
          "browser.fixup.alternate.enabled" = false;
          # Disable telemetry
          # https://wiki.mozilla.org/Platform/Features/Telemetry
          # https://wiki.mozilla.org/Privacy/Reviews/Telemetry
          # https://wiki.mozilla.org/Telemetry
          # https://www.mozilla.org/en-US/legal/privacy/firefox.html#telemetry
          # https://support.mozilla.org/t5/Firefox-crashes/Mozilla-Crash-Reporter/ta-p/1715
          # https://wiki.mozilla.org/Security/Reviews/Firefox6/ReviewNotes/telemetry
          # https://gecko.readthedocs.io/en/latest/browser/experiments/experiments/manifest.html
          # https://wiki.mozilla.org/Telemetry/Experiments
          # https://support.mozilla.org/en-US/questions/1197144
          # https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/internals/preferences.html#id1
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.server" = "data:,";
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.coverage.opt-out" = true;
          "toolkit.coverage.opt-out" = true;
          "toolkit.coverage.endpoint.base" = "";
          "experiments.supported" = false;
          "experiments.enabled" = false;
          "experiments.manifest.uri" = "";
          "browser.ping-centre.telemetry" = false;
          # https://mozilla.github.io/normandy/
          "app.normandy.enabled" = false;
          "app.normandy.api_url" = "";
          "app.shield.optoutstudies.enabled" = false;
          # Disable health reports (basically more telemetry)
          # https://support.mozilla.org/en-US/kb/firefox-health-report-understand-your-browser-perf
          # https://gecko.readthedocs.org/en/latest/toolkit/components/telemetry/telemetry/preferences.html
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.healthreport.service.enabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          # Disable crash reports
          "breakpad.reportURL" = "";
          "browser.tabs.crashReporting.sendReport" = false;
          "browser.crashReports.unsubmittedCheck.autoSubmit2" = false; # Don't submit backlogged reports

          ### --- Miscellanious state / UI ---
          "browser.shell.checkDefaultBrowser" = false;
          "browser.aboutconfig.showwarning" = false;
          "browser.compactmode.show" = true;
          "signon.rememberSignons" = false; # Don't use Firefox password manager
          "browser.newtabpage.enhanced" = false; # Disable new tab tile ads & preload
          "browser.newtabpage.introShown" = true;
          "browser.newtab.preload" = false;
          "browser.newtabpage.directory.ping" = "";
          "browser.newtabpage.directory.source" = "data:text/plain,{}";
          "browser.disableResetPrompt" = true;  # "Looks like you haven't started Firefox in a while."
          "browser.onboarding.enabled" = false;  # "New to Firefox? Let's get started!" tour
          "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
          "extensions.pocket.enabled" = false;
          "extensions.shield-recipe-client.enabled" = false;
        };
      };
    };
  };
}
