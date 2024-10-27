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

      nextcloud-password = {
        key = "nextcloud";
        sopsFile = ./sops/user-passwords.yaml;
        owner = "nextcloud";
      };

      miranda-cert = {
        key = "miranda-cert";
        sopsFile = ./sops/keys.yaml;
        owner = "nginx";
      };

      miranda-cert-key = {
        key = "miranda-cert-key";
        sopsFile = ./sops/keys.yaml;
        owner = "nginx";
      };

      tailscale-key = {
        key = "tailscale";
        sopsFile = ./sops/keys.yaml;
      };

      weatherapi-key = {
        key = "weatherapi-key";
        sopsFile = ./sops/keys.yaml;
        mode = "0444";
      };
    };
  };
}
