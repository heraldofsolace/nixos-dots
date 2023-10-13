_: {pkgs, ...}: {
  programs.firefox = {
    enable = true;
    profiles.default = {
      id = 0;
      name = "Default";
      isDefault = true;
      settings = {"browser.startup.homepage" = "https://google.com";};
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        # https-everywhere
        privacy-badger
        addy_io
        buster-captcha-solver
        c-c-search-extension
        consent-o-matic
        darkreader
        decentraleyes
        enhanced-github
        forget_me_not
        grammarly
        mailvelope
        multi-account-containers
        onepassword-password-manager
        peertubeify
        plasma-integration
        sourcegraph
        sponsorblock
        terms-of-service-didnt-read
        ublock-origin
        umatrix
        # bypass-paywalls-clean
        dictionaries
        enhancer-for-youtube
        facebook-container
        firenvim
        french-dictionary
        french-language-pack
        furiganaize
        gesturefy
        greasemonkey
        hover-zoom-plus
        istilldontcareaboutcookies
        image-search-options
        js-search-extension
        link-gopher
        momentumdash
        mullvad
        octolinker
        promnesia
        raindropio
        return-youtube-dislikes
        stylus
        to-deepl
        video-downloadhelper
        youtube-nonstop
      ];
    };
  };
}
