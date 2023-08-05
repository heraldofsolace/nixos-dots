{
  inputs,
  cell,
}: {pkgs, ...}: {
  home.packages = [pkgs.rustup];
  home.shellAliases = {
    rs = "rustc";
    rsp = "rustup";
    ca = "cargo";
  };
}
