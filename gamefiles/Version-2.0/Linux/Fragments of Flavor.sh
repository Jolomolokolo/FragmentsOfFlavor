#!/bin/sh
echo -ne '\033c\033]0;Fragment of Flavor\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Fragments of Flavor.x86_64" "$@"
