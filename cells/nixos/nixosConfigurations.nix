{
  inputs,
  cell,
}: let
  inherit (inputs) haumea nixpkgs;
  l = nixpkgs.lib // builtins;
  inherit (inputs) cells;
in
  haumea.lib.load {
    src = ./hosts;
    # loader = haumea.lib.loaders.default;
    transformer = haumea.lib.transformers.liftDefault;
    inputs = {
      inherit inputs;
      lib = l;
      suites = cell.nixosSuites;
      profiles =
        cell.nixosProfiles
        // {
          common = cells.common.commonProfiles;
          inherit (cells.secrets.nixosProfiles) secrets;
          users = cells.home.users.nixos;
        };
      inherit (cells.home) userProfiles;
    };
  }
