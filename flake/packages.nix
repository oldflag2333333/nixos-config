{ inputs, self, ... }:
{
  perSystem =
    { system, pkgs, ... }:
    {
      # Flake packages use system pins; standalone Home Manager owns its own pkgs.
      _module.args.pkgs = import inputs.nixpkgs-system {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          self.overlays.additions
          self.overlays.unstable-packages
        ];
      };

      packages = import ../pkgs pkgs;
    };
}
