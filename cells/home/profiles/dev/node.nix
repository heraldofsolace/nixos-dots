{
  inputs,
  cell,
}: {pkgs, ...}: {
  home.packages = with pkgs; [
    nodejs_latest
    yarn
  ];

  # Run locally installed bin-script, e.g. n coffee file.coffee
  home.shellAliases = {
    noderun = ''PATH="$(${pkgs.nodejs_latest}/bin/npm bin):$PATH"'';
    ya = "yarn";
  };
}
