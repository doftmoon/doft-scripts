#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# Copyright (c) 2025 doftmoon
#
# Small script to softlink all the scripts in the current folder
# Script should work on any bash-default distro
set -euo pipefail

readonly LOCAL_PATH="$HOME/.local/bin"
readonly GLOBAL_PATH='/usr/local/bin'
readonly CURRENT_DIR=$(pwd)
readonly SCRIPT_DIR="$CURRENT_DIR"
readonly SCRIPT_NAME=$(basename "${BASH_SOURCE[0]}")

info() {
   if command -v gum &>/dev/null; then
      gum style --foreground 10 "$1"
   else
      echo -e "\e[32mINFO:\e[0m $1"
   fi
}

error() {
   if command -v gum &>/dev/null; then
      gum style --foreground 9 "$1" >&2
   else
      echo -e "\e[31mERROR:\e[0m $1" >&2
   fi
   exit 1
}

choose() {
   local prompt="$1"
   shift
   if command -v gum &>/dev/null; then
      gum choose --cursor.foreground 12 --header="$prompt" --header.foreground 12 "$@"
   elif command -v fzf &>/dev/null; then
      printf "%s\n" "$@" |
         fzf --prompt='$prompt' \
            --height=20% \
            --border --cycle
   else
      select opt in "$@"; do [[ -n "$opt" ]] && { echo "$opt"; break; }; done
   fi
}

linker() {
   local dest_path="$1"

   for script_path in "$SCRIPT_DIR"/*; do
      script_file=$(basename "$script_path")

      if [[ "$script_file" == "$SCRIPT_NAME" ]]; then
         continue
      fi

      if [[ ! -x "$script_path" ]]; then
         continue
      fi

      ln -sf "$script_path" "$dest_path/$script_file"
   done

   info "Scripts succesfully linked with: $dest_path"
}

main() {
   [[ $EUID -eq 0 ]] && { error "Don't run as root"; exit 1; }

   local choice=""

   if [[ "$#" -gt 0 ]]; then
      choice="$1"
   fi

   if [[ "$choice" == "" ]]; then
      echo "Make a choice"
      local choices=(local global)
      choice=$(choose "Choose where to link scripts" "${choices[@]}")
   fi

   if [[ "$choice" == "local" ]]; then
      mkdir -p "$LOCAL_PATH"
      linker "$LOCAL_PATH"
   elif [[ "$choice" == "global" ]]; then
      linker "$GLOBAL_PATH"
   else
      error "Unknown or unsupported choice. Aborting."
   fi
}

main "$@"
