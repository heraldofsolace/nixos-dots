_: {
  pkgs,
  lib,
  ...
}: {
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;
}
