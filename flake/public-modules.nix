{ inputs, ... }:
{
  imports = [
    inputs.home-manager.flakeModules.home-manager
    (inputs.import-tree ../modules)
  ];
}
