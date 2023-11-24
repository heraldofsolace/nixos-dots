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
    profiles.desktop.plasma
    profiles.misc.gparted
    profiles.misc.op
    profiles.astronomy
    profiles.networking.common
    profiles.networking.samba
    profiles.networking.tailscale
    profiles.security.sudo
    profiles.services.postgres
    profiles.services.virtualbox
    inputs.grub2-themes.nixosModules.default
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
    config.permittedInsecurePackages = [
      "qtwebkit-5.212.0-alpha4"
      "zotero-6.0.26"
      "electron-24.8.6"
    ];
  };

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-ac0722b1-35f7-4b31-a215-942322657a7c".device = "/dev/disk/by-uuid/ac0722b1-35f7-4b31-a215-942322657a7c";
  boot.initrd.luks.devices."luks-ac0722b1-35f7-4b31-a215-942322657a7c".keyFile = "/crypto_keyfile.bin";

  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.grub.enable = true;
  boot.loader.grub.copyKernels = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.enableCryptodisk = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.device = "nodev";

  boot.loader.grub2-theme = {
    enable = true;
    theme = "tela";
    screen = "2k";
    footer = true;
  };

  environment.variables = {
    EDITOR = "vim";
  };

  environment.systemPackages = with inputs.nixpkgs; [
    maliit-keyboard
    maliit-framework
  ];

  networking.hostName = "horologium";

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
  };

  services.xserver = {
    enable = true;
    wacom.enable = true;
    videoDrivers = ["amdgpu"]; # Need a way to change this for different hosts
  };

  services.geoclue2.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;

  system.stateVersion = "22.05";
}
