
export GO111MODULE=on
GO111MODULE=on

VERSION=0.75
LAUNCH_VERSION=$(VERSION).09
GINGERSHREW_VERSION=68
GINGERSHREW_REVISION=9

GO_COMPILER_OPTS = -a -tags netgo -ldflags '-w -extldflags "-static"'
export CCACHE_DIR=$(PWD)/ccache
export CCACHE_COMPRESS=""

build: gingershrew gen

sums:
	sha256sum gingershrew-68.9.0.en-US.linux-x86_64.tar.bz2
	sha256sum import/gingershrew-68.9.0.en-US.linux-x86_64.tar.bz2

xxd:
	xxd -c 120 gingershrew-68.9.0.en-US.linux-x86_64.tar.bz2 import/gingershrew-68.9.0.en-US.linux-x86_64.tar.bz2

ccache:
	echo "$CCACHE_DIR $CCACHE_COMPRESS"
	ccache --max-size 25G

deps:
	apt-get install -y gcc g++ make patch perl python unzip zip autoconf automake build-essential checkinstall debhelper devscripts dpkg-dev fakeroot gdb-minimal libc6 libc6-dev libtool intltool pbuilder pkg-config ccache cdbs locales debhelper autotools-dev autoconf2.13 zip libx11-dev libx11-xcb-dev libxt-dev libxext-dev libgtk2.0-dev libgtk-3-dev libglib2.0-dev libpango1.0-dev libfontconfig1-dev libfreetype6-dev libstartup-notification0-dev libasound2-dev libcurl4-openssl-dev libdbus-glib-1-dev lsb-release libiw-dev mesa-common-dev libnotify-dev libxrender-dev libpulse-dev nasm yasm unzip dbus-x11 xvfb python python3 clang llvm cargo rustc nodejs

gnuzilla:
	git clone --depth=1 "https://git.savannah.gnu.org/git/gnuzilla.git" -b $(GINGERSHREW_VERSION); true

icecat-setup: gnuzilla gnuzilla-version gnuzilla/output

gnuzilla-version:
	cd gnuzilla && git checkout $(GINGERSHREW_VERSION)

gnuzilla/output:
	cd gnuzilla && ./makeicecat

gingershrew: gnuzilla gnuzilla-version rhz gnuzilla/output gingershrew-linux-workdir gingershrew-linux-configure gingershrew-linux-build gingershrew-linux-package

copy-linux:
	rm -rf gingershrew
	find gnuzilla -name gingershrew-$(GINGERSHREW_VERSION).$(GINGERSHREW_REVISION).0.en-US.linux-x86_64.tar.bz2 -exec cp {} ./ \;
	#find . -name gingershrew-$(GINGERSHREW_VERSION).$(GINGERSHREW_REVISION).0.en-US.linux-x86_64.tar.bz2 -exec tar xjf {} \;
	#find . -name gingershrew-$(GINGERSHREW_VERSION).$(GINGERSHREW_REVISION).0.en-US.linux-x86_64.tar.bz2 -exec cp {} ./gingershrew/ \;

gingershrew-linux-workdir:
	rm -rf gnuzilla/output/src
	cp -rv gnuzilla/output/gingershrew-$(GINGERSHREW_VERSION).$(GINGERSHREW_REVISION).0 gnuzilla/output/src
	cp -v gnuzilla.browser.components.migration.moz.build \
		gnuzilla/output/src/browser/components/migration/moz.build
#	cp -v gnuzilla.devtools.client.netmonitor.src.connector.moz.build \
#		gnuzilla/output/src/devtools/client/netmonitor/src/connector/moz.build

link:
	ln -sf $(PWD)/gnuzilla/output/src-win $(HOME)/workspace/build/src

gingershrew-linux-configure:
	mkdir -p gnuzilla/output/src/obj && cd gnuzilla/output/src/obj && ../configure

gingershrew-linux-build:
	mkdir -p gnuzilla/output/src/obj && cd gnuzilla/output/src/obj && ../mach build

gingershrew-linux-package:
	mkdir -p gnuzilla/output/src/obj && cd gnuzilla/output/src/obj && ../mach package

gingershrew-linux-run:
	mkdir -p gnuzilla/output/src/obj && cd gnuzilla/output/src/obj && ../mach run

export WORKSPACE=$(PWD)/gnuzilla/workspace
WORKSPACE=$(PWD)/gnuzilla/workspace
TOOLCHAIN_DIR=$(HOME)/workspace/moz-toolchain
TOOLTOOL_DIR=$(HOME)/workspace/moz-toolchain
MOZ_FETCHES_DIR=$(HOME)/workspace/moz-toolchain

compiler-win64:
	wget -O $(MOZ_FETCHES_DIR)/clangmingw.tar.zst https://firefox-ci-tc.services.mozilla.com/api/index/v1/task/gecko.cache.level-3.toolchains.v3.linux64-clang-9-mingw-x64.latest/artifacts/public/build/clangmingw.tar.zst
	cd $(MOZ_FETCHES_DIR)/ && tar --zstd -xvf clangmingw.tar.zst 

gingershrew-windows-workdir:
	rm -rf gnuzilla/output/src-win
	cp -rv gnuzilla/output/gingershrew-$(GINGERSHREW_VERSION).$(GINGERSHREW_REVISION).0 gnuzilla/output/src-win
	cp -v gnuzilla.browser.components.migration.moz.build \
		gnuzilla/output/src-win/browser/components/migration/moz.build
#	cd gnuzilla/output/src-win && \
#		./taskcluster/scripts/misc/build-clang-8-mingw.sh x64
#gingershrew-windows-workdir:
#	rm -rf gnuzilla/output/srcwin
#	cp -rv gnuzilla/output/gingershrew-$(GINGERSHREW_VERSION).$(GINGERSHREW_REVISION).0 gnuzilla/output/srcwin
#	cp -v gnuzilla.browser.components.migration.moz.build \
#		gnuzilla/output/srcwin/browser/components/migration/moz.build
	cp -rv mozconfig gnuzilla/output/src-win/.mozconfig


gingershrew-windows-configure:
	mkdir -p gnuzilla/output/src-win/obj && cd gnuzilla/output/src-win/obj && ../configure

gingershrew-windows-build:
	mkdir -p gnuzilla/output/src-win/obj && cd gnuzilla/output/src-win/obj && ../mach build

gingershrew-windows-package:
	mkdir -p gnuzilla/output/src-win/obj && cd gnuzilla/output/src-win/obj && ../mach package

rhz:
	find ./gnuzilla/data -type f -exec sed -i 's|icecat|gingershrew|g' {} \;
	find ./gnuzilla/data -type f -exec sed -i 's|IceCat|GingerShrew|g' {} \;
	find ./gnuzilla/data -type f -exec sed -i 's|IceCat|GingerShrew|g' {} \;
	find ./gnuzilla/data -type f -exec sed -i 's|ICECAT|GINGERSHREW|g' {} \;
	find ./gnuzilla/tools -type f -exec sed -i 's|icecat|gingershrew|g' {} \;
	find ./gnuzilla/tools -type f -exec sed -i 's|IceCat|GingerShrew|g' {} \;
	find ./gnuzilla/tools -type f -exec sed -i 's|IceCat|GingerShrew|g' {} \;
	find ./gnuzilla/tools -type f -exec sed -i 's|ICECAT|GINGERSHREW|g' {} \;
	sed -i 's|ICECAT|GINGERSHREW|g' ./gnuzilla/makeicecat
	sed -i 's|IceCat|GingerShrew|g' ./gnuzilla/makeicecat
	sed -i 's|Icecat|GingerShrew|g' ./gnuzilla/makeicecat
	sed -i 's|icecat|gingershrew|g' ./gnuzilla/makeicecat
	mv -f gnuzilla/data/branding/icecat gnuzilla/data/branding/gingershrew || echo "Already moved"
	mv -f gnuzilla/data/branding/icecatmobile gnuzilla/data/branding/gingershrewmobile || echo "Already moved"
	./rewrite
	find ./gnuzilla/ -type f -exec sed -i 's|GNU GingerShrew|Free GingerShrew|g' {} \;
	sed -i 's|GNU GingerShrew|Free GingerShrew|g' gnuzilla/makeicecat
	find ./gnuzilla/ -type f -exec sed -i 's|From GNU|From A Tiny Rodent|g' {} \;
	sed -i 's|From GNU|From A Tiny Rodent|g' gnuzilla/makeicecat
	find ./gnuzilla/ -type f -exec sed -i 's|GNU Foundation|No Foundation|g' {} \;
	sed -i 's|GNU Foundation|No Foundation|g' gnuzilla/makeicecat
	find ./gnuzilla/ -type f -exec sed -i 's|No Corporation|No Corporation|g' {} \;
	sed -i 's|No Corporation|No Corporation|g' gnuzilla/makeicecat
	sed -i 's|\\>GNU\\|\\>No\\|g' gnuzilla/makeicecat

clean:
	rm -rf gnuzilla \
		gingershrew*.tar.bz2*

gen: copy-linux
	go run --tags generate gen.go

test:
	cd import && GO111MODULE=off go test

fmt:
	find import -name '*.go' -exec gofmt -w -s {} \;
	gofmt -w -s *.go
