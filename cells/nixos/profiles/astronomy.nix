_: {pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # siril
    kstars
    stellarium
    siril-new2
    sirilic
    # pixinsight
  ];

  services.gvfs.enable = true;
}
