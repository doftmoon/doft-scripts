# SPDX-License-Identifier: MIT
# Copyright (c) 2025 doftmoon
#!/usr/bin/env bash
#
# Small script to softlink all the scripts in the current folder
# Script should work on any bash-default distro
set -euo pipefail

readonly LOCAL_PATH="$HOME/.local/bin"
readonly GLOBAL_PATH='/usr/local/bin'
readonly SCRIPT_DIR=$(pwd)
readonly SCRIPT_NAME=$(basename "${BASH_SOURCE[0]}")

info() {
   echo $1
}

error() {
   echo $1
   exit 1
}

ensure_not_root() {
   [[ $EUID -eq 0 ]] && { error "Don't run as root"; exit 1; }
   echo ""
}

choose_dest() {
   if command -v gum &>/dev/null; then
      gum choose --cursor.foreground 12 --header="" --header.foreground 12 "$@"
   elif command -v fzf &>/dev/null; then
      echo "fzf"
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

link_scripts() {
   if [[ $1 == "local" ]]; then
      linker "$LOCAL_PATH"
   elif [[ $1 == "global" ]]; then
      info "Global chosen. Nothing done."
   fi
}

main() {
   ensure_not_root

   echo "Make a choice"
   local choices=(local global)
   local choice=$(choose_dest "${choices[@]}")
   link_scripts "$choice"
}

main
