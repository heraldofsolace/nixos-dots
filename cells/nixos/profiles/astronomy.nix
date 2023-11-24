_: {pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # siril
    kstars
    stellarium
    siril-new2
    # pixinsight
  ];

  services.gvfs.enable = true;
}
