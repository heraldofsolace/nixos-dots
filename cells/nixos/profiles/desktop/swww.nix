{inputs, ...}: {pkgs, ...}: {
  environment.systemPackages = [
    inputs.swww.packages.${pkgs.system}.swww
    pkgs.swww-schedule
  ];
}
