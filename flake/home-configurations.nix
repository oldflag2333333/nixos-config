{
  config,
  inputs,
  lib,
  self,
  ...
}:
let
  environmentOptions = { name, ... }: {
    options = {
      system = lib.mkOption {
        type = lib.types.str;
        default = "x86_64-linux";
        description = "Platform for this independent user environment.";
      };
      user = lib.mkOption {
        type = lib.types.submodule {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              description = "User owning this environment.";
            };
            email = lib.mkOption {
              type = lib.types.str;
              description = "Email used by user applications such as Git.";
            };
          };
        };
        description = "User identity shared with the system declaration.";
      };
      stateVersion = lib.mkOption {
        type = lib.types.str;
        description = "Home Manager compatibility version; do not bump on updates.";
      };
      configuration = lib.mkOption {
        type = lib.types.deferredModule;
        default = { };
        description = "Declarative application and user configuration selection for ${name}.";
      };
    };
  };
  mkHome =
    hostName: cfg:
    let
      pkgs = import inputs.nixpkgs-user {
        inherit (cfg) system;
        config.allowUnfree = true;
        overlays = [
          (_final: _prev: {
            unstable = import inputs.nixpkgs-user-unstable {
              inherit (cfg) system;
              config.allowUnfree = true;
            };
          })
        ];
      };
      # Desktop helpers must use the same compositor version as the system.
      systemPkgs = import inputs.nixpkgs-system {
        inherit (cfg) system;
        config.allowUnfree = true;
      };
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit inputs self systemPkgs; };
      modules = (builtins.attrValues self.homeModules) ++ [
        {
          home = {
            username = cfg.user.name;
            homeDirectory = "/home/${cfg.user.name}";
            inherit (cfg) stateVersion;
          };
          repo = {
            inherit hostName;
            inherit (cfg) user;
          };
        }
        cfg.configuration
      ];
    };
in
{
  options.repo.userEnvironments = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule environmentOptions);
    default = { };
    description = "Independent Home Manager environments, selected in hosts/<host>/user.nix.";
  };

  config.perSystem =
    { system, ... }:
    {
      checks = lib.mapAttrs' (
        hostName: cfg:
        lib.nameValuePair "home-${hostName}"
          self.homeConfigurations."${cfg.user.name}@${hostName}".activationPackage
      ) (lib.filterAttrs (_: cfg: cfg.system == system) config.repo.userEnvironments);
    };

  config.flake.homeConfigurations = lib.mapAttrs' (
    hostName: cfg: lib.nameValuePair "${cfg.user.name}@${hostName}" (mkHome hostName cfg)
  ) config.repo.userEnvironments;
}
