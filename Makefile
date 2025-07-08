#!/usr/bin/env bash

version = 140.0.2
ff_source_dir = firefox-$(version)
ff_patches_dir = $(abspath $(ff_source_dir)/patches)
ff_source_tarball = firefox-$(version).tar.xz

fetchsrc:
	wget -q --show-progress "https://archive.mozilla.org/pub/firefox/releases/$(version)/source/firefox-$(version).source.tar.xz" -O $(ff_source_tarball)

copyfiles:
	cp -r browser/branding/librefox $(ff_source_dir)/browser/branding/librefox
	cp -r patches $(ff_source_dir)/

patches:
	./apply_patches.sh $(ff_patches_dir) $(ff_source_dir)

build:
	./mach bootstrap --application-choice=browser
	./mach build
	./mach package

prepare: fetchsrc copyfiles
