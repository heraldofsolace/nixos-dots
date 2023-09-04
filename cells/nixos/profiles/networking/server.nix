_: {
  pkgs,
  lib,
  ...
}: {
  systemd.network.enable = true;

  systemd.network.networks."10-enp9s0" = {
    matchConfig.Name = "enp9s0";
    # acquire a DHCP lease on link up
    networkConfig.DHCP = "ipv4";
    networkConfig.IPv6AcceptRA = false;
    linkConfig.RequiredForOnline = "routable";
  };
  networking.hosts = {
    "192.168.0.1" = ["router.home"];
    "192.168.0.3" = ["pi.hole"];
    "192.168.49.2" = ["my-demo-app.local"];
  };

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [5555 27183 22];
  
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
}
