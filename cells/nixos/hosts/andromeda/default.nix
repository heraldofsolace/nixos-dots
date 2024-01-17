{
  inputs,
  suites,
  profiles,
  ...
}: let
  system = "x86_64-linux";
in {
  imports = [
    suites.base
    profiles.docker
    profiles.astronomy
    profiles.desktop.plasma
    profiles.gaming.steam
    profiles.misc.gparted
    profiles.misc.hass
    profiles.misc.op
    profiles.misc.openrgb
    profiles.networking.common
    profiles.networking.samba
    profiles.networking.tailscale
    profiles.security.sudo
    profiles.services.postgres
    profiles.services.mariadb
    profiles.services.virtualbox
    inputs.grub2-themes.nixosModules.default
    ./_hardware-configuration.nix
    ./_zfs.nix
  ];

  bee.system = system;
  bee.home = inputs.home;
  bee.pkgs = import inputs.nixos {
    inherit system;
    config.allowUnfree = true;
    overlays = with inputs.cells.common.overlays; [
      common-packages
      latest-overrides
      nur
      nvfetcher
      agenix
    ];
    config.permittedInsecurePackages = [
      "qtwebkit-5.212.0-alpha4"
      "zotero-6.0.26"
      "electron-25.9.0"
    ];
  };

  environment = {
    variables = {
      EDITOR = "vim";
    };

    persistence = {
      "/persist" = {
        hideMounts = true;
        directories = [
          "/etc/nix"
          "/etc/pipewire"
          "/root"
        ];
        files = [
          "/etc/machine-id"
        ];
      };
    };
  };

  networking.interfaces.enp6s0.wakeOnLan.enable = true;
  networking.hostName = "andromeda";
  services = {
    geoclue2.enable = true;
    gnome.gnome-keyring.enable = true;
    xserver = {
      enable = true;
      wacom.enable = true;
      videoDrivers = ["amdgpu"];
    };
    openssh = {
      enable = true;
      settings.PermitRootLogin = "no";
      settings.PasswordAuthentication = false;
      hostKeys = [
        {
          path = "/persist/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
        {
          path = "/persist/etc/ssh/ssh_host_rsa_key";
          type = "rsa";
          bits = 4096;
        }
      ];
    };
  };

  security.polkit.enable = true;
  services.avahi.hostName = "andromeda";
  system.stateVersion = "22.05";
}
