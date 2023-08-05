_: {pkgs, ...}: {
  security.sudo.extraConfig = ''
    Defaults  insults
  '';
  environment.persistence."/persist".directories = [
    "/var/db/sudo"
  ];
}
