# Agent Guide for NixOS Configuration

This repository contains a Flake with independently deployed NixOS systems and standalone Home Manager user environments for `desktop` and `minisforum`.

## Project Structure

- `flake.nix`: The entry point for the flake. Defines inputs and outputs.
- `hosts/`: Host-specific configurations (e.g., `minisforum`); `hosts/_user.nix` is the single shared username/email definition, imported by system and user declarations. Keep personal identity values out of reusable module defaults.
- `hosts/<host>/user.nix`: Declarative user identity and application selections for that host; no application implementation belongs here. These files are auto-discovered by `flake/hosts.nix`.
- `modules/`: Reusable NixOS and Home Manager modules.
    - `infra/`: System infrastructure and its associated user configuration.
    - `profiles/`: Scenario-level profiles (general, desktop, hyprland).
    - `programs/`: Self-contained programs; terminal tools are grouped under `programs/shell/`.
    - Export system configuration as `flake.nixosModules.<name>` and user configuration as `flake.homeModules.<name>`; mixed features export both from their owning file.
    - Nested `.nix` modules are discovered recursively via `import-tree`; use `/_` paths for private Nix helpers that should not be auto-imported.
    - No `modules/home/` tree exists; Home Manager configuration lives in the modules that own it.
- `flake/home-configurations.nix`: Defines `repo.userEnvironments` and assembles Home Manager outputs/checks; keep output assembly separate from user configuration.
- `modules/infra/user-environment.nix`: Owns only the common Home Manager base module and its user/host options.
- `homeConfigurations."oldflag@<host>"`: Standalone Home Manager outputs built from `repo.userEnvironments`. Do not reintroduce the NixOS Home Manager integration or a second configuration owner.
- Keep collection names plural (`userEnvironments`, `homeModules`, `desktopSettings`); use singular `config`, `setting`, and `userService` for individual capabilities. User-side compositor switches are `config.enable`; Fcitx5 uses `setting.enable`, and DMS uses `userService.enable`. System installation switches remain `enable`.
- `overlays/`: Custom package overlays.
- `pkgs/`: Custom packages defined in this flake.

## Build and Test Commands

Since this is a system configuration, "building" usually means building the system derivation or checking the flake.

### Core Commands

**Git add before build.**

- **Build System**:
  ```bash
  nixos-rebuild build --flake .#desktop
  ```
- **Apply Configuration** (Switch):
  ```bash
  sudo nixos-rebuild switch --flake .#desktop
  ```
- **Build User Environment** (no activation):
  ```bash
  nix build '.#homeConfigurations."oldflag@desktop".activationPackage' --out-link result-home-desktop
  ```
- **Apply User Configuration** (only when asked):
  ```bash
  home-manager switch --flake .#oldflag@desktop
  ```
- **Check Flake Integrity**:
  ```bash
  nix flake check
  ```
- **Format Nix Files**:
  Use `nixfmt` to format .nix files.
  ```bash
  nixfmt .
  ```

### Testing Changes
- There is no unit test suite for the config itself.
- Build both system and user outputs for changes touching both layers. Flake checks include both hosts\' user activation packages.
- Routine user updates use only `pi`, `home-manager`, `nixpkgs-user` and `nixpkgs-user-unstable`; system pins must not advance accidentally.
- See README.md for first-migration ordering. Do not activate or switch without authorization.

## Code Style Guidelines

### Nix Language
- **Indentation**: Use **2 spaces** for indentation.
- **Formatting**: Format your code to match existing files. Lists and attribute sets should be clearly structured.
- **Naming**:
    - Use `camelCase` for variable names and custom option definitions.
    - Package names usually follow the upstream package name (often kebab-case).
- **Imports**: Use relative paths for local imports.
- **Variables**: Use `let ... in` blocks for local bindings. Use `inherit` to shorten attribute sets when possible.
- **Comments**: Use `#` for comments. Explain *why* a complex configuration exists, not just what it is.

**Example:**
```nix
{ pkgs, ... }:
let
  myVar = "value";
in
{
  programs.git = {
    enable = true;
    userName = "My Name";
    # Use inherit when keys match variable names
    inherit (pkgs) git-lfs;
  };
}
```

### Shell Scripts
- **Shebang**: Ensure scripts have a proper shebang (e.g., `#!/usr/bin/env bash` or `#!/usr/bin/env zsh`).
- **Permissions**: Ensure scripts are executable if they are meant to be run directly.

## Agent Workflows

### Modifying Configuration
1.  **Locate**: Find the relevant module in `modules/` or the host config in `hosts/`. Do not define everything in `default.nix`. Home Manager configuration lives directly in the module that owns it (in `modules/infra/` or `modules/programs/`), not in a separate tree.
2.  **Edit**: Apply changes adhering to the style guide.
3.  **Verify**: Run `nix flake check` or `nixos-rebuild build` (if possible/allowed) to ensure the configuration evaluates correctly.

### Adding New Packages
1.  Check system packages in `nixpkgs-system` / `nixpkgs-system-unstable`, and user packages in `nixpkgs-user` / `nixpkgs-user-unstable`.
2.  Add it to the relevant `home.packages` or `environment.systemPackages` list in the appropriate module.
3.  If it requires configuration, create a module in `modules/infra/` or `modules/programs/`; export its user configuration via `flake.homeModules.<name>` and enable it in `hosts/<host>/user.nix`. Do not add a separate `modules/home/` subtree.

### Error Handling
- If a build fails, analyze the Nix error trace. It usually points to the exact line number and nature of the error (e.g., missing semicolon, undefined variable).
- Ensure all brackets `{ }` and parentheses `( )` are balanced.

## Dependencies
- **Nix**: The package manager and language.
- **Home Manager**: Manages user environment.
- **Git**: Version control.

---
*Generated by OpenCode*
