_: {pkgs, ...}: {
  services.mysql = {
    enable = true;
    package = pkgs.mysql;
    user = "root";
  };
}
