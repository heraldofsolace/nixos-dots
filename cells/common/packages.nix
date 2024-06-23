{
  inputs,
  cell,
}: let
  inherit (inputs) haumea latest;

  nixpkgs = import latest {inherit (inputs.nixpkgs) system;};

  l = nixpkgs.lib // builtins;

  sources = nixpkgs.callPackage ./sources/generated.nix {};
in
  l.mapAttrs (
    _: v:
      if v == ./packages/pixinsight.nix
      then
        nixpkgs.libsForQt5.callPackage v {
          inherit sources;
        }
      else
        nixpkgs.callPackage v {
          inherit sources;
          inherit inputs;
        }
  )
  (
    haumea.lib.load {
      src = ./packages;
      loader = haumea.lib.loaders.path;
    }
  )
