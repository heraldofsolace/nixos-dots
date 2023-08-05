{
  inputs,
  cell,
}: {pkgs, ...}: {
  home.packages = with pkgs; [
    gcc
    bear
    gdb
    cmake
  ];
}
