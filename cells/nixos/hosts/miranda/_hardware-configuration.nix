{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/9230ab9d-eca3-4b71-93d5-0a3c41d47bc7";
    fsType = "ext4";
  };

  fileSystems."/var/lib/nextcloud" = {
    device = "/dev/disk/by-uuid/ee86aeac-30b6-4c48-8630-d8212cd6d942";
    fsType = "ext4";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/D074-7B2E";
    fsType = "vfat";
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/27183b98-984f-452b-8ec8-954cc7f26ed6";}
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
