# hardware-configuration.nix - Portable server template
#
# Uses disk LABELS instead of UUIDs so this works on any system.
# On the target machine, either:
#   a) Label your partitions:  sudo e2fslabel /dev/nvme0n1p2 nixos && sudo fatlabel /dev/nvme0n1p1 NIXOS_BOOT
#   b) Regenerate this file:  sudo nixos-generate-config --show-hardware-config > hosts/server/hardware-configuration.nix
#
# Option (b) is recommended - it picks up the correct kernel modules for your hardware too.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/NIXOS_BOOT";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
