{ inputs, self, ... }:
let
  system = "x86_64-linux";
  user = import ../_user.nix;
in
{
  flake.nixosConfigurations.minisforum = inputs.nixpkgs-system.lib.nixosSystem {
    inherit system;

    specialArgs = {
      inherit inputs self;
    };

    modules = [ self.nixosModules.hostMinisforum ];
  };

  flake.nixosModules.hostMinisforum =
    { ... }:
    {
      imports = [
        self.nixosModules.base
        self.nixosModules.general
        self.nixosModules.desktop
        self.nixosModules.hyprland-profile
        self.nixosModules.amd-gpu
        self.nixosModules.docker
        self.nixosModules.steam
      ];

      repo = {
        inherit user;

        infra = {
          base.enable = true;
          docker.enable = true;
          gpu.amd.enable = true;
        };

        profiles = {
          general.enable = true;
          desktop.enable = true;
          hyprland.enable = true;
        };

        programs = {
          steam.enable = true;
        };
      };

      networking.hostName = "minisforum";
      system.stateVersion = "25.05";
    };
}
