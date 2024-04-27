{
  inputs,
  cell,
}: {
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    ruby
    bundix
    rubyPackages.rails
  ];
}
