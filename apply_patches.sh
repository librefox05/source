#!/usr/bin/env bash

patches_dir="$1"
src_path="$2"

for patch in $patches_dir; do
  echo "applying $patch"
  cd $src_path
  patch -p1 <$patch
done
