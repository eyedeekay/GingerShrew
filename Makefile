
export GO111MODULE=on
GO111MODULE=on

VERSION=0.75
LAUNCH_VERSION=$(VERSION).09
GINGERSHREW_VERSION=78
GINGERSHREW_REVISION=10

GO_COMPILER_OPTS = -a -tags netgo -ldflags '-w -extldflags "-static"'
export CCACHE_DIR=$(PWD)/ccache
export CCACHE_COMPRESS=""

build: gingershrew gen

docker: docker-build docker-clean docker-run docker-copy

docker-build:
	docker build -f Dockerfile.linux -t eyedeekay.unbrandedbrowser .

docker-run:
	docker run -it --name eyedeekay.unbrandedbrowser eyedeekay.unbrandedbrowser

docker-copy:
	docker cp eyedeekay.unbrandedbrowser:/home/user/GingerShrew/ GingerShrew/

docker-clean:
	docker rm -f eyedeekay.unbrandedbrowser

sums:
	sha256sum gingershrew-$(GINGERSHREW_VERSION).$(GINGERSHREW_REVISION).0.en-US.linux-x86_64.tar.bz2
	sha256sum import/gingershrew-$(GINGERSHREW_VERSION).$(GINGERSHREW_REVISION).0.en-US.linux-x86_64.tar.bz2

xxd:
	xxd -c 120 gingershrew-$(GINGERSHREW_VERSION).$(GINGERSHREW_REVISION).0.en-US.linux-x86_64.tar.bz2 import/gingershrew-$(GINGERSHREW_VERSION).$(GINGERSHREW_REVISION).0.en-US.linux-x86_64.tar.bz2

ccache:
	echo "$CCACHE_DIR $CCACHE_COMPRESS"
	ccache --max-size 25G

deps:
	apt-get install -y gcc g++ make patch perl python unzip zip autoconf automake build-essential checkinstall debhelper devscripts dpkg-dev fakeroot gdb libc6 libc6-dev libtool intltool pbuilder pkg-config ccache cdbs locales debhelper autotools-dev autoconf2.13 zip libx11-dev libx11-xcb-dev libxt-dev libxext-dev libgtk2.0-dev libgtk-3-dev libglib2.0-dev libpango1.0-dev libfontconfig1-dev libfreetype6-dev libstartup-notification0-dev libasound2-dev libcurl4-openssl-dev libdbus-glib-1-dev lsb-release libiw-dev mesa-common-dev libnotify-dev libxrender-dev libpulse-dev nasm yasm unzip dbus-x11 xvfb python python3 clang llvm cargo rustc nodejs mercurial rename

gnuzilla:
	git clone --depth=1 "https://git.savannah.gnu.org/git/gnuzilla.git"; true

icecat-setup: gnuzilla gnuzilla-version gnuzilla/output

gnuzilla-version:
	cd gnuzilla && git checkout $(GINGERSHREW_VERSION) || git checkout master && git checkout -b $(GINGERSHREW_VERSION); true

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
	find ./gnuzilla/ -type f -exec sed -i 's|GNU Project|No Project|g' {} \;
	sed -i 's|GNU Project|No Project|g' gnuzilla/makeicecat
	find ./gnuzilla/ -type f -exec sed -i 's|No Corporation|No Corporation|g' {} \;
	sed -i 's|No Corporation|No Corporation|g' gnuzilla/makeicecat
	find ./gnuzilla/ -type f -exec sed -i 's|www.gnu.org|github.com/eyedeekay/GingerShrew|g' {} \;
	sed -i 's|www.gnu.org|github.com/eyedeekay/GingerShrew|g' gnuzilla/makeicecat
	sed -i 's|\\>GNU\\|\\>No\\|g' gnuzilla/makeicecat

#libatk1.0-0 (>= 1.12.4)
#libgdk-pixbuf2.0-0 (>= 2.22.0), 
#libglib2.0-0 (>= 2.37.3), 
#libgtk-3-0 (>= 3.0.0), 
#libpango-1.0-0 (>= 1.14.0), libstdc++6 (>= 9), libvpx6 (>= 1.8.0), libx11-6, libx11-xcb1 (>= 2:1.6.10), libxcb-shm0, libxcb1, libxcomposite1 (>= 1:0.4.5), li#bxdamage1 (>= 1:1.1), libxext6, libxfixes3, libxrender1, zlib1g (>= 1:1.2.11.dfsg), fontconfig, procps, debianutils (>= 1.16)

libdir:
	rm -rf lib && mkdir -p lib
	apt-get download libc6 libc6-dev libnspr4 libnspr4-dev libnss3 libnss3-dev libcairo-gobject2 libcairo2-dev libffi7 libnss3-dev libfontconfig1 libfontconfig1-dev libfreetype6 libfreetype6-dev libgtk-3-0 libgtk-3-dev libglib2.0-0 libglib2.0-dev libpango-1.0 libpango1.0-dev zlib1g zlib1g-dev
	dpkg -x libc6_2*.deb ./lib
	dpkg -x libc6-dev_2*.deb ./lib
	dpkg -x libcairo2-dev_1*.deb ./lib
	dpkg -x libcairo-gobject2*.deb ./lib
	dpkg -x libffi7_3*.deb ./lib
	dpkg -x libfontconfig1_2*.deb ./lib
	dpkg -x libfontconfig1-dev_2*.deb ./lib
	dpkg -x libfreetype6_2*.deb ./lib
	dpkg -x libfreetype6-dev_2*.deb ./lib
	dpkg -x libglib2.0-0_2*.deb ./lib
	dpkg -x libglib2.0-dev_2*.deb ./lib
	dpkg -x libgtk-3-0_3*.deb ./lib
	dpkg -x libgtk-3-dev_3*.deb ./lib
	dpkg -x libnspr4_2*.deb ./lib
	dpkg -x libnspr4-dev_2*.deb ./lib
	dpkg -x libnss3_2*.deb ./lib
	dpkg -x libnss3-dev_2*.deb ./lib
	dpkg -x libpango-1.0-0_1.*.deb ./lib
	dpkg -x libpango1.0-dev_1*.deb ./lib
	dpkg -x zlib1g_1*.deb ./lib
	dpkg -x zlib1g-dev_1*.deb ./lib


clean:
	rm -rf gnuzilla \
		gingershrew*.tar.bz2*

version:
	@echo "//+build generate" | tee version.go
	@echo "" | tee -a version.go
	@echo "package main" | tee -a version.go
	@echo "" | tee -a version.go
	@echo "var GS_VERSION = \"gingershrew-$(GINGERSHREW_VERSION).$(GINGERSHREW_REVISION).0.en-US.linux-x86_64.tar.bz2\"" | tee -a version.go
	@echo "" | tee -a version.go


gen: version copy-linux libdir
	go run --tags generate gen.go version.go

test:
	cd import && GO111MODULE=off go test

fmt:
	find import -name '*.go' -exec gofmt -w -s {} \;
	gofmt -w -s *.go
