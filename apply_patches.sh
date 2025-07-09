#!/usr/bin/env bash

patches_dir="$1"
src_path="$2"

for patch in $patches_dir/*.patch; do
  cd $src_path
  if patch --dry-run --reverse --force -p1 <$patch >/dev/null 2>&1; then
    echo "$patch already applied - skipping."
  else
    echo "applying $patch"
    patch -p1 <$patch
  fi
done
