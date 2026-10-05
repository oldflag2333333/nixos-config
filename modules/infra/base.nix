{ self, ... }:
{
  flake.nixosModules.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options = {
        repo.infra.base.enable = (lib.mkEnableOption "Enable base system capability.") // {
          default = true;
        };

        repo.user = {
          name = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Primary user name shared by NixOS and Home Manager.";
          };

          email = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Primary user email shared by NixOS and Home Manager.";
          };
        };
      };

      config = lib.mkIf config.repo.infra.base.enable {
        assertions = [
          {
            assertion = config.repo.user.name != null;
            message = "Set repo.user.name in the host module.";
          }
          {
            assertion = config.repo.user.email != null;
            message = "Set repo.user.email in the host module.";
          }
        ];

        # Shared kernel policy; hosts can select another kernel without mkForce.
        boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

        boot.loader.systemd-boot = {
          enable = true;
          consoleMode = "max";
        };
        boot.loader.efi.canTouchEfiVariables = true;

        networking.networkmanager.enable = true;

        console = {
          earlySetup = true;
          packages = [ pkgs.terminus_font ];
          font = "ter-132b";
        };

        time.timeZone = lib.mkDefault "Asia/Shanghai";

        i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
        i18n.extraLocaleSettings = {
          LC_ADDRESS = "zh_CN.UTF-8";
          LC_IDENTIFICATION = "zh_CN.UTF-8";
          LC_MEASUREMENT = "zh_CN.UTF-8";
          LC_MONETARY = "zh_CN.UTF-8";
          LC_NAME = "zh_CN.UTF-8";
          LC_NUMERIC = "zh_CN.UTF-8";
          LC_PAPER = "zh_CN.UTF-8";
          LC_TELEPHONE = "zh_CN.UTF-8";
          LC_TIME = "zh_CN.UTF-8";
        };

        users.users.${config.repo.user.name} = {
          isNormalUser = true;
          group = config.repo.user.name;
          extraGroups = [
            "networkmanager"
            "wheel"
          ];
          packages = [ ];
        };

        users.groups.${config.repo.user.name} = { };

        users.defaultUserShell = pkgs.zsh;

        programs.zsh.enable = true;

        nixpkgs = {
          overlays = [
            self.overlays.additions
            self.overlays.unstable-packages
          ];

          config = {
            allowUnfree = true;
            permittedInsecurePackages = [ ];
          };
        };

        nix = {
          gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 7d";
          };

          settings.experimental-features = [
            "nix-command"
            "flakes"
          ];
        };

        security.sudo.extraRules = [
          {
            commands = [
              {
                command = "ALL";
                options = [ "NOPASSWD" ];
              }
            ];
            groups = [ "wheel" ];
          }
        ];
      };
    };
}
