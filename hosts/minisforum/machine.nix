{ ... }:
{
  flake.nixosModules.hostMinisforum =
    { ... }:
    {
      powerManagement.cpuFreqGovernor = "powersave";

      hardware.bluetooth.enable = true;

      fileSystems."/mnt/synology" = {
        device = "192.168.1.104:/volume1/documents";
        fsType = "nfs";
        options = [ "nfsvers=4" ];
      };
    };
}
