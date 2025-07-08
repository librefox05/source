#!/usr/bin/env bash

version = 140.0.2
ff_source_dir = $(abspath firefox-$(version))
ff_patches_dir = $(ff_source_dir)/patches
ff_source_tarball = firefox-$(version).tar.xz

fetchsrc:
	wget -q --show-progress "https://archive.mozilla.org/pub/firefox/releases/$(version)/source/firefox-$(version).source.tar.xz" -O $(ff_source_tarball)
	tar -xf $(ff_source_tarball)

copyfiles:
	cp -r browser/branding/librefox $(ff_source_dir)/browser/branding/librefox
	cp -r patches $(ff_source_dir)/
	cp mozconfig $(ff_source_dir)/

patch:
	./apply_patches.sh $(ff_patches_dir) $(ff_source_dir)

build:
	cd $(ff_source_dir) && \
	./mach --no-interactive bootstrap --application-choice browser && \
	./mach build && \
	./mach package

clean:
	rm -rf $(ff_source_tarball) $(ff_source_dir)

prepare: fetchsrc copyfiles
