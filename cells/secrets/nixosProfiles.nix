{
  inputs,
  cell,
}: {
  secrets = _: {
    imports = [
      inputs.sops-nix.nixosModules.sops
      ./_common.nix
    ];

    sops.secrets = {
      root-password = {
        key = "root";
        sopsFile = ./sops/user-passwords.yaml;
        neededForUsers = true;
      };

      aniket-password = {
        key = "aniket";
        sopsFile = ./sops/user-passwords.yaml;
        neededForUsers = true;
      };

      hass-password = {
        key = "hass";
        sopsFile = ./sops/user-passwords.yaml;
        neededForUsers = true;
      };
    };
  };
}
