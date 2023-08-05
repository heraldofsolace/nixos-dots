_: {pkgs, ...}: {
  home.packages = with pkgs; [
    xprintidle-ng
  ];
}
