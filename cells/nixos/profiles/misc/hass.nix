_: {pkgs, ...}: {
  environment.systemPackages = [pkgs.hass-report-usage pkgs.xprintidle];
}
