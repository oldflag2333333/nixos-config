{ inputs, ... }:
{
  flake.nixosModules.hostDesktop =
    { ... }:
    {
      imports = [ inputs.disko.nixosModules.disko ];

      # Declarative disk layout for desktop.
      # NOTE: nvme1n1 is reserved for VM passthrough, not managed by disko.
      disko.devices = {
        disk = {
          main = {
            device = "/dev/disk/by-id/nvme-SOLIDIGM_SSDPFKKW010X7_SNC2N413910502B18";
            type = "disk";
            content = {
              type = "gpt";
              partitions = {
                ESP = {
                  type = "EF00";
                  size = "1G";
                  content = {
                    type = "filesystem";
                    format = "vfat";
                    mountpoint = "/boot";
                    mountOptions = [ "umask=0077" ];
                  };
                };
                swap = {
                  size = "64G";
                  content = {
                    type = "swap";
                    resumeDevice = true;
                  };
                };
                root = {
                  size = "100%";
                  content = {
                    type = "filesystem";
                    format = "ext4";
                    mountpoint = "/";
                  };
                };
              };
            };
          };
        };
      };

      boot.resumeDevice = "/dev/disk/by-partlabel/disk-main-swap";
      boot.tmp = {
        useTmpfs = true;
        tmpfsSize = "16G";
      };

      powerManagement.cpuFreqGovernor = "performance";

      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
      };

      networking.networkmanager.wifi.powersave = false;

      fileSystems."/mnt/synology" = {
        device = "192.168.1.104:/volume1/documents";
        fsType = "nfs";
        options = [ "nfsvers=4" ];
      };
    };
}
