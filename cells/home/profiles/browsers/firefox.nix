_: {pkgs, ...}: {
  programs.firefox = {
    enable = true;
    profiles.default = {
      id = 0;
      name = "Default";
      isDefault = true;
      settings = {"browser.startup.homepage" = "https://google.com";};
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        addy_io
        buster-captcha-solver
        c-c-search-extension
        consent-o-matic
        darkreader
        decentraleyes
        enhanced-github
        forget_me_not
        grammarly
        multi-account-containers
        onepassword-password-manager
        peertubeify
        plasma-integration
        sourcegraph
        sponsorblock
        ublock-origin
        umatrix
        enhancer-for-youtube
        firenvim
        french-dictionary
        french-language-pack
        furiganaize
        gesturefy
        greasemonkey
        hover-zoom-plus
        image-search-options
        js-search-extension
        link-gopher
        mullvad
        octolinker
        promnesia
        return-youtube-dislikes
        stylus
        to-deepl
        video-downloadhelper
        youtube-nonstop
        private-relay
        pronoundb
      ];
    };
  };
}
