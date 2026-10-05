{ inputs, ... }:
let
  lib = inputs.nixpkgs-system.lib;

  hostNames = builtins.attrNames (
    lib.filterAttrs (
      name: type:
      type == "directory"
      && !(lib.hasPrefix "_" name)
      && builtins.pathExists (../hosts + "/${name}/default.nix")
    ) (builtins.readDir ../hosts)
  );

  hostModuleFiles = builtins.concatLists (
    map (
      name:
      let
        hostDir = ../hosts + "/${name}";
        hostEntries = builtins.readDir hostDir;
        nixFiles = builtins.filter (
          file: hostEntries.${file} == "regular" && !(lib.hasPrefix "_" file) && lib.hasSuffix ".nix" file
        ) (builtins.attrNames hostEntries);
      in
      map (file: hostDir + "/${file}") nixFiles
    ) hostNames
  );
in
{
  imports = hostModuleFiles;
}
