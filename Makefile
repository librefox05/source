
version = 140.0.4
cwd = $(shell pwd)
ff_source_dir = $(abspath firefox-$(version))
ff_patches_dir = $(ff_source_dir)/patches
ff_source_tarball = firefox-$(version).tar.xz

fetchsource:
	wget -q --show-progress "https://archive.mozilla.org/pub/firefox/releases/$(version)/source/firefox-$(version).source.tar.xz" -O $(ff_source_tarball)

untar:
	tar -xf $(ff_source_tarball)

copyfiles:
	rm -rf $(ff_patches_dir)/browser/branding/librefox || true
	rm -rf $(ff_source_dir)/mozconfig  || true
	rm -rf $(ff_patches_dir) || true
	cp -r browser/branding/librefox $(ff_source_dir)/browser/branding
	cp -r patches $(ff_source_dir)/
	cp -r browser/base/content/aboutDialog.xhtml $(ff_source_dir)/browser/base/content/
	cp mozconfig $(ff_source_dir)/

patch:
	./apply_patches.sh $(ff_patches_dir) $(ff_source_dir)

clobber:
	cd $(ff_source_dir) && ./mach clobber

build:
	cd $(ff_source_dir) && \
	./mach --no-interactive bootstrap --application-choice browser && \
	./mach build && \
	./mach package

# repacking
obj_out = $(ff_source_dir)/obj-x86_64-pc-linux-gnu/dist/librefox-*.tar.xz
repack_dir = $(cwd)/repacking
out_dir = $(cwd)/out
settings_url = https://github.com/librefox05/settings

repack:
	rm -rf $(repack_dir)
	mkdir $(repack_dir) $(out_dir)
	tar -xf $(obj_out) -C $(repack_dir)
	cd $(repack_dir) && \
		git clone $(settings_url) custom_settings && \
		cp -r custom_settings/* $(repack_dir)/librefox && \
		rm -rf custom_settings && \
		cd $(out_dir) && \
	  tar -cJf librefox-x86_64-$(version).tar.xz -C $(repack_dir) librefox

clean:
	rm -rf $(ff_source_tarball) $(ff_source_dir) $(out_dir) $(repack_dir)

prepare: fetchsource untar copyfiles

buildclean: clean prepare patch build repack

buildover: copyfiles build repack
