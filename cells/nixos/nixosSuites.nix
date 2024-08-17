{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs std haumea;
  l = nixpkgs.lib // builtins;
  profiles = cell.nixosProfiles;
  inherit (cell) nixosModules;
  modulesImportables = l.attrValues nixosModules;
  users = inputs.cells.home.users.nixos;
in
  # with cell.darwinProfiles;
  {
    base = _: {
      imports =
        [
          profiles.core
          users.aniket
          users.root
          users.hass
          users.nextcloud
          users.nginx
          inputs.cells.secrets.nixosProfiles.secrets
        ]
        ++ modulesImportables;
    };
    miranda = _: {
      imports =
        [
          profiles.core
          profiles.entertainment.plex
          profiles.entertainment.jellyfin
          users.aniket-miranda
          users.nextcloud
          users.nginx
          users.root
          inputs.cells.secrets.nixosProfiles.secrets
        ]
        ++ modulesImportables;
    };
  }
