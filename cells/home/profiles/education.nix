_: {pkgs, ...}: {
  home.packages = with pkgs; [
    zotero
    anki
  ];
}
