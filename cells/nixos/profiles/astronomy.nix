_: {pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    siril
    kstars
    stellarium
    # pixinsight
  ];

  services.gvfs.enable = true;
}
