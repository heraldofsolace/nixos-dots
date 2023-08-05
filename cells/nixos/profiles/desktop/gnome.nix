_: {pkgs, ...}: {
  imports = [./common.nix];

  # services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  environment.systemPackages = with pkgs; [gnomeExtensions.appindicator];
  services.udev.packages = with pkgs; [gnome.gnome-settings-daemon];
}
