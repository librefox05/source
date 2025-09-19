#
# mksource: get firefox source archive and configure it to be built as librefox
# breakfast: clean up previously downloaded source, dirs and configure source and build
# dinner: use the already available source, configure it, and build
#
version = 143.0.1
cwd = $(shell pwd)
srcdir = $(abspath firefox-$(version))
patchesdir = $(srcdir)/patches
src_tarball = firefox-$(version).tar.xz
obj_out = $(srcdir)/obj-x86_64-pc-linux-gnu/dist/librefox-*.tar.xz
bundle_dir = $(cwd)/forge
out_dir = $(cwd)/out
settings_url = https://github.com/librefox05/settings

.PHONY: getsrc untar configure patch clobber build bundle clean mksource breakfast dinner sweep

getsrc:
	wget -q --show-progress "https://archive.mozilla.org/pub/firefox/releases/$(version)/source/firefox-$(version).source.tar.xz" -O $(src_tarball)

untar:
	tar -xf $(src_tarball)

configure:
	rm -rf $(patchesdir)/browser/branding/librefox || true
	rm -rf $(srcdir)/mozconfig  || true
	rm -rf $(patchesdir) || true
	cp -r browser/branding/librefox $(srcdir)/browser/branding
	cp -r patches $(srcdir)/
	cp -r browser/base/content/aboutDialog.xhtml $(srcdir)/browser/base/content/
	cp mozconfig $(srcdir)/

patch:
	./apply_patches.sh $(patchesdir) $(srcdir)

clobber:
	cd $(srcdir) && ./mach clobber

build:
	cd $(srcdir) && \
	./mach --no-interactive bootstrap --application-choice browser && \
	./mach build && \
	./mach package

bundle:
	rm -rf $(bundle_dir)
	mkdir $(bundle_dir) $(out_dir)
	tar -xf $(obj_out) -C $(bundle_dir)
	cd $(bundle_dir) && \
		git clone $(settings_url) custom_settings && \
		cp -r custom_settings/* $(bundle_dir)/librefox && \
		rm -rf custom_settings && \
		cd $(out_dir) && \
	  tar -cJf librefox-x86_64-$(version).tar.xz -C $(bundle_dir) librefox

clean:
	rm -rf $(src_tarball) || true
	rm -rf $(srcdir) || true
	rm -rf $(out_dir) || true
	rm -rf $(bundle_dir) || true

sweep:
	rm -rf $(out_dir) || true
	rm -rf $(bundle_dir) || true

mksource: getsrc untar configure

breakfast: clean mksource patch build bundle

dinner: sweep configure patch build bundle
