# https://github.com/hlissner/dotfiles/blob/master/modules/desktop/browsers/firefox.nix
{ config, lib, pkgs, ... }:

with lib;
let cfg = config.modules.browsers.firefox;
in {
  options.modules.browsers.firefox = {
    enable = mkEnableOption "firefox";
    pkg = mkOption {
      type = types.package;
      default = pkgs.firefox;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.my.username} = {
      programs.firefox.enable = true;
      programs.firefox.package = cfg.pkg;
      programs.firefox.extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        https-everywhere
        privacy-badger
        onepassword-password-manager
      ];
      programs.firefox.profiles = {
        home = {
          id = 0;
          settings = {
            "app.normandy.enabled" = false;
            "app.shield.optoutstudies.enabled" = false;
            "breakpad.reportURL" = "";
            "browser.cache.disk.enable" = false;
            "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
            "browser.discovery.enabled" = false;
            "browser.newtabpage.activity-stream.feeds.telemetry" = false;
            "browser.newtabpage.activity-stream.telemetry" = false;
            "browser.ping-centre.telemetry" = false;
            "browser.privatebrowsing.forceMediaMemoryCache" = true;
            "browser.region.update.enabled" = false;
            "browser.sessionstore.privacy_level" = 2;
            "browser.tabs.crashReporting.sendReport" = false;
            "browser.xul.error_pages.expert_bad_cert" = true;
            "datareporting.healthreport.uploadEnabled" = false;
            "datareporting.policy.dataSubmissionEnabled" = false;
            "device.sensors.enabled" = false;
            "dom.gamepad.enabled" = false;
            "dom.push.enabled" = false;
            "dom.push.userAgentID" = "";
            "dom.webnotifications.enabled" = false;
            "dom.webnotifications.serviceworker.enabled" = false;
            "extensions.getAddons.showPane" = false;
            "extensions.htmlaboutaddons.recommendations.enabled" = false;
            "extensions.pocket.enabled" = false;
            "extensions.screenshots.disabled" = true;
            "geo.provider.use_corelocation" = false;
            "identity.fxaccounts.enabled" = false;
            "intl.accept_languages" = "en-US, en";
            "javascript.use_us_english_locale" = true;
            "mathml.disabled" = true;
            "media.autoplay.blocking_policy" = 0;
            "media.eme.enabled" = true;
            "media.memory_cache_max_size" = 65536;
            "media.ondevicechange.enabled" = false;
            "media.webspeech.synth.enabled" = false;
            "network.connectivity-service.enabled" = false;
            "network.http.referer.XOriginPolicy" = 0;
            "network.http.referer.XOriginTrimmingPolicy" = 0;
            "network.http.sendRefererHeader" = 0;
            "network.http.sendSecureXSiteReferrer" = false;
            "places.history.expiration.max_pages" = 10000000;
            "plugins.enumerable_names" = "blank";
            "privacy.history.custom" = true;
            "privacy.resistFingerprinting" = true;
            "privacy.trackingprotection.enabled" = true;
            "security.cert_pinning.enforcement_level" = 2;
            "security.family_safety.mode" = 0;
            "security.OCSP.enabled" = 1;
            "security.OCSP.require" = true;
            "security.pki.crlite_mode" = 2;
            "security.remote_settings.crlite_filters.enabled" = true;
            "security.ssl.require_safe_negotiation" = true;
            "security.ssl.treat_unsafe_negotiation_as_broken" = true;
            "security.tls.enable_0rtt_data" = false;
            "signon.generation.available" = false;
            "signon.generation.enabled" = false;
            "signon.management.page.breach-alerts.enabled" = false;
            "signon.management.page.breachAlertUrl" = "";
            "signon.management.page.enabled" = false;
            "signon.rememberSignons" = false;
            "toolkit.coverage.endpoint.base" = "";
            "toolkit.coverage.opt-out" = true;
            "toolkit.telemetry.archive.enabled" = false;
            "toolkit.telemetry.bhrPing.enabled" = false;
            "toolkit.telemetry.coverage.opt-out" = true;
            "toolkit.telemetry.enabled" = false;
            "toolkit.telemetry.firstShutdownPing.enabled" = false;
            "toolkit.telemetry.newProfilePing.enabled" = false;
            "toolkit.telemetry.server" = "data:,";
            "toolkit.telemetry.shutdownPingSender.enabled" = false;
            "toolkit.telemetry.unified" = false;
            "toolkit.telemetry.updatePing.enabled" = false;
            "webgl.disabled" = false;
          };
        };
      };
    };
  };
}
