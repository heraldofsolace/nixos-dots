_: {pkgs, ...}: {
  home.packages = with pkgs; [
    qpwgraph
    audacity
    ardour
    guitarix
    alsa-scarlett-gui
    bitwig-studio
  ];
}