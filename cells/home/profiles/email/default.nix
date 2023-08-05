{pkgs, ...}: {
  programs.mbsync.enable = true;
  programs.msmtp.enable = true;
  programs.notmuch = {
    enable = true;
    hooks = {
      preNew = "mbsync --all";
    };
  };

  accounts.email = {
    accounts.aniketmail669 = {
      address = "aniket@abhattacharyea.dev";
      gpg = {
        key = "0x1C89935B2933922D";
        signByDefault = true;
      };
      flavor = "gmail.com";
      mbsync = {
        enable = true;
        create = "maildir";
      };
      msmtp.enable = true;
      notmuch.enable = true;
      primary = true;
      realName = "Aniket Bhattacharyea";
      signature = {
        text = ''
          - Aniket Bhattacharyea
        '';
        showSignature = "append";
      };
      passwordCommand = "op read op://Personal/smwnismrgb7sxkppgu2hss7yse/app_password";
      userName = "aniket@abhattacharyea.dev";
    };
  };
}
