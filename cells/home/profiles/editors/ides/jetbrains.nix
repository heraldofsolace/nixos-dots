_: {pkgs, ...}: {
  home.packages = with pkgs.jetbrains; [
    pycharm-community
    webstorm
    goland
    clion
    datagrip
    phpstorm
    ruby-mine
    idea-community
  ];
}
