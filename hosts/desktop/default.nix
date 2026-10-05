{ inputs, self, ... }:
let
  system = "x86_64-linux";
  user = import ../_user.nix;
in
{
  flake.nixosConfigurations.desktop = inputs.nixpkgs-system.lib.nixosSystem {
    inherit system;

    specialArgs = {
      inherit inputs self;
    };

    modules = [ self.nixosModules.hostDesktop ];
  };

  flake.nixosModules.hostDesktop =
    { ... }:
    {
      imports = [
        self.nixosModules.base
        self.nixosModules.general
        self.nixosModules.desktop
        self.nixosModules.niri-profile
        self.nixosModules.intel-gpu
        self.nixosModules.amd-gpu
        self.nixosModules.docker
        self.nixosModules.steam
      ];

      repo = {
        inherit user;

        infra = {
          base.enable = true;
          docker.enable = false;
          gpu.intel.enable = true;
          gpu.amd.enable = true;
        };

        profiles = {
          general.enable = true;
          desktop.enable = true;
          niri.enable = true;
        };

        programs = {
          steam.enable = true;
        };
      };

      networking.hostName = "desktop";
      system.stateVersion = "25.11";
    };
}
