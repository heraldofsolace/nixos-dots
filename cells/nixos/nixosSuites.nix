{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs std haumea;
  l = nixpkgs.lib // builtins;
  profiles = cell.nixosProfiles;
  users = inputs.cells.home.users.nixos;
in
  # with cell.darwinProfiles;
  {
    base = _: {
      imports = [
        profiles.core
        users.aniket
        users.root
        users.hass
        inputs.cells.secrets.nixosProfiles.secrets
      ];
    };
  }
