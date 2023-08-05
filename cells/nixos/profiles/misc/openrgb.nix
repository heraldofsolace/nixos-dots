_: {pkgs, ...}: {
  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
  };
  networking.firewall.allowedTCPPorts = [
    6742
  ];
}
