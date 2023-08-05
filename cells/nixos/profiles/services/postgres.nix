_: {pkgs, ...}: {
  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all 127.0.0.1/32 trust
      host all all ::1/128 trust
    '';
  };
  environment.persistence."/persist".directories = [
    "/var/lib/postgresql"
  ];
}
