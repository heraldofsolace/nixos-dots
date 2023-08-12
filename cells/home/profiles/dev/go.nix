{
  inputs,
  cell,
}: {pkgs, ...}: {
  programs.go = {
    enable = true;
    goPath = "go";
    goBin = ".local/bin/go";
    package = pkgs.go_1_20;
  };
}
