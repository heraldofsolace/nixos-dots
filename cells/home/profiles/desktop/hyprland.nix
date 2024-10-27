{inputs, ...}: {
  pkgs,
  config,
  lib,
  ...
}: {
  desktop.hyprland-suite.enable = true;
  desktop.hyprland-suite.package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  desktop.hyprland-suite.plugins = [
    inputs.hyprland-plugins.packages.${pkgs.system}.borders-plus-plus
  ];
  desktop.hyprland-suite.weztermPackage = let
    pkgs-unstable = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  in
    pkgs-unstable.wezterm;
  desktop.hyprland-suite.hyprlockPackage = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.hyprlock;
  services.hass-report-usage.enable = lib.mkForce false;
}
