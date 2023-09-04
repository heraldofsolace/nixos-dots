{
  inputs,
  suites,
  profiles,
  ...
}: let
  system = "x86_64-linux";
in {
  imports = [
    suites.miranda
    profiles.docker
    profiles.networking.server
    profiles.networking.tailscale
    profiles.security.sudo
    profiles.services.postgres
    ./_hardware-configuration.nix
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
  };

  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.copyKernels = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";

  environment.variables = {
    EDITOR = "vim";
  };

  networking.hostName = "miranda";

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
  };

  security.polkit.enable = true;

  system.stateVersion = "22.05";
}
