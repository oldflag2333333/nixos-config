#!/usr/bin/env zsh
set -eu

commandsFile="$1"
systemFlake="$2"
userFlake="$3"
flakePath="$4"

alias rebuild-sys='false'
alias rebuild-user='false'
alias list-gen='false'
alias update='false'
source "$commandsFile"

[[ -z "${aliases[rebuild-sys]-}" ]]
[[ -z "${aliases[rebuild-user]-}" ]]
[[ -z "${aliases[list-gen]-}" ]]
[[ -z "${aliases[update]-}" ]]

typeset -a calls
typeset -i stubStatus=0

# Never run actual updates, deployments or profile commands in this test.
function sudo() {
  calls=(sudo "$@")
  return "$stubStatus"
}
function home-manager() {
  calls=(home-manager "$@")
  return "$stubStatus"
}
function nix() {
  calls=(nix "$@")
  return "$stubStatus"
}
function assert_call() {
  local -a expected=("$@")
  [[ "${#calls}" -eq "${#expected}" ]]
  local i
  for (( i = 1; i <= ${#expected}; i++ )); do
    [[ "${calls[$i]}" == "${expected[$i]}" ]]
  done
}

update --system
assert_call nix flake update nixpkgs-system nixpkgs-system-unstable disko dms flake-parts import-tree --flake "$flakePath"

update --user
assert_call nix flake update pi home-manager nixpkgs-user nixpkgs-user-unstable --flake "$flakePath"

calls=()
if update --user nixpkgs-system >/dev/null 2>&1; then
  exit 1
else
  [[ "$?" -eq 2 ]]
fi
[[ "${#calls}" -eq 0 ]]

calls=()
if update --system --user >/dev/null 2>&1; then
  exit 1
else
  [[ "$?" -eq 2 ]]
fi
[[ "${#calls}" -eq 0 ]]

rebuild --system --show-trace
assert_call sudo nixos-rebuild switch --flake "$systemFlake" --show-trace

rebuild --user --argstr label "two words"
assert_call home-manager switch --flake "$userFlake" --argstr label "two words"

list-gen --system
assert_call sudo nix-env --profile /nix/var/nix/profiles/system --list-generations

list-gen --user
assert_call home-manager generations

for cmd in update rebuild list-gen; do
  for flag in "" --invalid; do
    calls=()
    if [[ -z "$flag" ]]; then
      if "$cmd" >/dev/null 2>&1; then
        exit 1
      else
        [[ "$?" -eq 2 ]]
      fi
    elif "$cmd" "$flag" >/dev/null 2>&1; then
      exit 1
    else
      [[ "$?" -eq 2 ]]
    fi
    [[ "${#calls}" -eq 0 ]]
  done
  for flag in --help -h; do
    calls=()
    "$cmd" "$flag" >/dev/null
    [[ "${#calls}" -eq 0 ]]
  done
done

stubStatus=7
if update --user && rebuild --user; then
  exit 1
else
  [[ "$?" -eq 7 ]]
fi
assert_call nix flake update pi home-manager nixpkgs-user nixpkgs-user-unstable --flake "$flakePath"

if rebuild --user; then
  exit 1
else
  [[ "$?" -eq 7 ]]
fi
if list-gen --system; then
  exit 1
else
  [[ "$?" -eq 7 ]]
fi
