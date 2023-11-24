{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd" "uinput"];
  boot.extraModulePackages = [];
  boot.blacklistedKernelModules = ["rtl8192cu" "rtl_usb" "rtl8192c_common" "rtlwifi"];
  boot.extraModprobeConfig = ''
    options snd_usb_audio vid=0x1235 pid=0x8211 device_setup=1
    options snd_usb_audio vid=0x1235 pid=0x8210 device_setup=1
  '';
  fileSystems."/" = {
    device = "rpool/local/root";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "rpool/local/nix";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "rpool/safe/home";
    fsType = "zfs";
  };

  fileSystems."/persist" = {
    device = "rpool/safe/persist";
    fsType = "zfs";
    neededForBoot = true;
  };

  fileSystems."/boot" = {
    device = "bpool/nixos/root";
    fsType = "zfs";
  };

  fileSystems."/boot/efis/nvme-Seagate_FireCuda_520_SSD_ZP1000GM30002_7QG021QD-part1" = {
    device = "/dev/disk/by-uuid/F582-0E75";
    fsType = "vfat";
  };

  fileSystems."/boot/efis/ata-ST1000DM010-2EP102_ZN10JDQ3-part1" = {
    device = "/dev/disk/by-uuid/F582-4BBA";
    fsType = "vfat";
  };

  fileSystems."/boot/efi" = {
    device = "/boot/efis/nvme-Seagate_FireCuda_520_SSD_ZP1000GM30002_7QG021QD-part1";
    fsType = "none";
    options = ["bind"];
  };

  fileSystems."/games" = {
    device = "/dev/disk/by-uuid/a8197ae8-7052-4d76-a017-31e5ee7f2620";
    fsType = "ext4";
  };

  swapDevices = [
    {device = "/dev/disk/by-id/nvme-Seagate_FireCuda_520_SSD_ZP1000GM30002_7QG021QD-part4";}
    {device = "/dev/disk/by-id/ata-ST1000DM010-2EP102_ZN10JDQ3-part4";}
  ];

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.keyboard.zsa.enable = true;
  hardware.keyboard.qmk.enable = true;
  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;

  hardware.bluetooth.enable = true;
  services.udev.packages = [ pkgs.bazecor ];
  services.udev.extraRules = ''
  KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
  '';
}
