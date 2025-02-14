#!/bin/sh
echo -ne '\033c\033]0;Cosmic_Expansion\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/cosmic_expansion.x86_64" "$@"
