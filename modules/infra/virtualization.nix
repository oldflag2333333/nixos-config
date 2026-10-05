{ ... }:
{
  flake.nixosModules.virtualization =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.repo.infra.virtualization = {
        enable = lib.mkEnableOption "Enable virtualization support.";
        user = lib.mkOption {
          type = lib.types.str;
          default = config.repo.user.name;
        };
        platform = lib.mkOption {
          type = lib.types.str;
          default = "amd";
        };
        vfioIds = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };
      };

      config = lib.mkIf config.repo.infra.virtualization.enable {
        boot = {
          initrd.kernelModules = [
            "vfio_pci"
            "vfio"
            "vfio_iommu_type1"
          ];
          kernelParams = [
            "${config.repo.infra.virtualization.platform}_iommu=on"
            "iommu=pt"
          ];
          extraModprobeConfig = "options vfio-pci ids=${builtins.concatStringsSep "," config.repo.infra.virtualization.vfioIds}";
        };

        systemd.tmpfiles.rules = [
          "f /dev/shm/looking-glass 0660 ${config.repo.infra.virtualization.user} qemu-libvirtd -"
          "d /var/lib/libvirt/secrets 0700 root root -"
        ];

        environment.systemPackages = with pkgs; [ looking-glass-client ];

        programs.virt-manager.enable = true;

        virtualisation.libvirtd = {
          enable = true;
          package = pkgs.unstable.libvirt;
          extraConfig = ''user="${config.repo.infra.virtualization.user}"'';
          qemu = {
            package = pkgs.unstable.qemu_kvm;
            verbatimConfig = "namespaces = []";
          };
          onBoot = "ignore";
          onShutdown = "shutdown";
        };

        users.users.${config.repo.infra.virtualization.user}.extraGroups = [
          "qemu-libvirtd"
          "libvirtd"
          "disk"
        ];
      };
    };
}
