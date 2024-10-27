_: {
  pkgs,
  lib,
  ...
}: {
  networking.networkmanager.enable = true;
  # networking.resolvconf.enable = false;
  networking.hosts = {
    "192.168.0.1" = ["router.home"];
    "192.168.0.3" = ["pi.hole"];
    "192.168.49.2" = ["my-demo-app.local"];
  };
  networking.wireless.iwd.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [5555 27183 22 5353];
  networking.useDHCP = lib.mkDefault true;
  networking.dhcpcd.wait = "background";
  networking.dhcpcd.extraConfig = "noarp";

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
  };

  systemd.services.NetworkManager-wait-online.enable = false;
}
