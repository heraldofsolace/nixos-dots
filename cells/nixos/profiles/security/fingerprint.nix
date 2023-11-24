_: {pkgs, ...}: {
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
}
