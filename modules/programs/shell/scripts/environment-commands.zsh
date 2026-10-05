#!/usr/bin/env zsh

# Also clear legacy aliases when reloading configuration in an existing shell.
unalias rebuild rebuild-sys rebuild-user rebuild-home list-gen update 2>/dev/null || true

# Require exactly one target so a typo cannot update all or cross-scope inputs.
function update() {
  if (( $# != 1 )); then
    printf 'Usage: update --system|--user\n' >&2
    return 2
  fi
  case "$1" in
    --system)
      nix flake update nixpkgs-system nixpkgs-system-unstable disko dms flake-parts import-tree --flake @FLAKE_PATH@
      ;;
    --user)
      nix flake update pi home-manager nixpkgs-user nixpkgs-user-unstable --flake @FLAKE_PATH@
      ;;
    -h|--help)
      printf 'Usage: update --system|--user\n'
      ;;
    *)
      printf 'Usage: update --system|--user\n' >&2
      return 2
      ;;
  esac
}

function rebuild() {
  case "${1:-}" in
    --system)
      shift
      sudo nixos-rebuild switch --flake @SYSTEM_FLAKE@ "$@"
      ;;
    --user)
      shift
      home-manager switch --flake @USER_FLAKE@ "$@"
      ;;
    -h|--help)
      printf 'Usage: rebuild --system|--user [additional arguments]\n'
      ;;
    *)
      printf 'Usage: rebuild --system|--user [additional arguments]\n' >&2
      return 2
      ;;
  esac
}

function list-gen() {
  case "${1:-}" in
    --system)
      shift
      sudo nix-env --profile /nix/var/nix/profiles/system --list-generations "$@"
      ;;
    --user)
      shift
      home-manager generations "$@"
      ;;
    -h|--help)
      printf 'Usage: list-gen --system|--user [additional arguments]\n'
      ;;
    *)
      printf 'Usage: list-gen --system|--user [additional arguments]\n' >&2
      return 2
      ;;
  esac
}
