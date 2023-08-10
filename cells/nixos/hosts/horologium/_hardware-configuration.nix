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
    device = "/dev/disk/by-uuid/c42fa35b-6c22-438b-b1a0-85260ba4b3da";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-95c0f91d-7e40-477f-a779-9a7e467e2ddc".device = "/dev/disk/by-uuid/95c0f91d-7e40-477f-a779-9a7e467e2ddc";

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/ACCA-93CB";
    fsType = "vfat";
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/6db3bc43-f852-4f1b-884e-a1bbee1d2d8e";}
  ];

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.keyboard.zsa.enable = true;
  environment.systemPackages = [pkgs.wally-cli];

  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;
  hardware.sensor.iio.enable = true;
  hardware.bluetooth.enable = true;
}
