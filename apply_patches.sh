#!/bin/bash

patches_dir="$1"
src_path="$2"

if [[ ! -d "$patches_dir" || ! -d "$src_path" ]]; then
  echo "Usage: $0 <patches_dir> <src_path>"
  exit 1
fi

for patch in "$patches_dir"/*.patch; do
  cd "$src_path" || exit 1
  if patch --dry-run -p1 <"$patch" >/dev/null 2>&1; then
    echo "Applying $(basename "$patch")"
    patch -p1 <"$patch"
  else
    echo "$(basename "$patch") already applied or cannot be applied cleanly - skipping."
  fi
done
