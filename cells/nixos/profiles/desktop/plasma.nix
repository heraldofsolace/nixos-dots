_: {pkgs, ...}: {
  imports = [./common.nix];

  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.wacom.enable = true;

  programs.ssh = {
    askPassword = "${pkgs.ksshaskpass}/bin/ksshaskpass";
    startAgent = true;
  };

  programs.kdeconnect.enable = true;
  environment.systemPackages = [pkgs.yakuake pkgs.ark];
}
