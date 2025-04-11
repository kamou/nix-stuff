{ config, ... }:
{
  programs.librewolf = {
    enable = true;
    settings = {
      "privacy.resistFingerprinting.letterboxing" = true;
      "identity.fxaccounts.enabled" = true;
      "identity.sync.tokenserver.uri" = {{ librewolf_tokenserver_uri }};
      "services.sync.username" = {{ librewolf_firefox_account_username }};
      "security.OCSP.require" = false;
      "sidebar.revamp" = true;
      "sidebar.verticalTabs" = true;
    };

    # only works when librewolf version is == firefox version. but sometimes, librewolf has 136.0.4-X whenre -X does not exist in firefox.
    # should be fixed in next nixos release...
    # programs.librewolf.languagePacks = [ "fr" "en-US" ];
  };
}
