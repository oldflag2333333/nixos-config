# This file defines overlays
{ inputs, ... }:
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final;

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-system-unstable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
      config.permittedInsecurePackages = [ ];

      overlays = [ ];
    };
  };
}
