#!/usr/bin/env bash

version=140.0.2
ff_source_tarball=firefox-${version}.tar.xz
wget -q --show-progress "https://archive.mozilla.org/pub/firefox/releases/${version}/source/firefox-${version}.source.tar.xz" -O ${ff_source_tarball}
