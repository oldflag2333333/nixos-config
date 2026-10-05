{
  description = "My NixOS System Config.";

  inputs = {
    nixpkgs-system.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-system-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # User applications can advance without changing system package pins.
    nixpkgs-user.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-user-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs-user";
    };

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs-system";
    };

    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs-system-unstable";
    };

    # Official Pi releases; retain the upstream nixpkgs pin for its build.
    pi = {
      url = "github:earendil-works/pi/stable";
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./flake);
}
