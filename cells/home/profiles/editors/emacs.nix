{
  services.emacs = {
    enable = true;
    client.enable = true;
    startWithUserSession = true;
  };

  programs.emacs = {
    enable = true;
  };
}
