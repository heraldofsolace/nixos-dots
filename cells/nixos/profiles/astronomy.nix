_: {pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # siril
    kstars
    stellarium
    siril-new2
    sirilic
    indi-full
    phd2
    # pixinsight
  ];

  services.gvfs.enable = true;
}
