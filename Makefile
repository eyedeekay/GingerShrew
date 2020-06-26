
export GO111MODULE=on
GO111MODULE=on

VERSION=0.75
LAUNCH_VERSION=$(VERSION).09
GINGERSHREW_VERSION=68
GINGERSHREW_REVISION=9

GO_COMPILER_OPTS = -a -tags netgo -ldflags '-w -extldflags "-static"'

build: setup assets.go
	go build $(GO_COMPILER_OPTS)

gnuzilla:
	git clone --depth=1 "https://git.savannah.gnu.org/git/gnuzilla.git" -b $(GINGERSHREW_VERSION); true

icecat-setup: gnuzilla gnuzilla-version gnuzilla/output

gnuzilla-version:
	cd gnuzilla && git checkout $(GINGERSHREW_VERSION)

gnuzilla/output:
	cd gnuzilla && ./makeicecat

gingershrew: gnuzilla gnuzilla-version rhz gnuzilla/output rhz gingershrew-linux-workdir gingershrew-linux-configure gingershrew-linux-build gingershrew-linux-package

copy-linux:
	rm -rf gingershrew
	find gnuzilla -name gingershrew-$(GINGERSHREW_VERSION).$(GINGERSHREW_REVISION).0.en-US.linux-x86_64.tar.bz2 -exec cp {} ./ \;
	find . -name gingershrew-$(GINGERSHREW_VERSION).$(GINGERSHREW_REVISION).0.en-US.linux-x86_64.tar.bz2 -exec tar xjf {} \;
	rm -rf gingershrew/libs && mkdir -p gingershrew/libs
	cp -v gingershrew/*.so gingershrew/libs
	rm -v gingershrew/*.so
	rm -rf gingershrew/root && mkdir -p gingershrew/root
	-cp -v gingershrew/* gingershrew/root
	#find . -name gingershrew-$(GINGERSHREW_VERSION).$(GINGERSHREW_REVISION).0.en-US.linux-x86_64.tar.bz2 -exec cp {} ./gingershrew/ \;

gingershrew-linux-workdir:
	rm -rf gnuzilla/output/src
	cp -rv gnuzilla/output/gingershrew-$(GINGERSHREW_VERSION).$(GINGERSHREW_REVISION).0 gnuzilla/output/src
	cp -v gnuzilla.browser.components.migration.moz.build \
		gnuzilla/output/src/browser/components/migration/moz.build
#	cp -v gnuzilla.devtools.client.netmonitor.src.connector.moz.build \
#		gnuzilla/output/src/devtools/client/netmonitor/src/connector/moz.build

gingershrew-linux-configure:
	mkdir -p gnuzilla/output/src/obj && cd gnuzilla/output/src/obj && ../configure

gingershrew-linux-build:
	mkdir -p gnuzilla/output/src/obj && cd gnuzilla/output/src/obj && ../mach build

gingershrew-linux-package:
	mkdir -p gnuzilla/output/src/obj && cd gnuzilla/output/src/obj && ../mach package

gingershrew-linux-run:
	mkdir -p gnuzilla/output/src/obj && cd gnuzilla/output/src/obj && ../mach run

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
	sed -i 's|From GNU|From A Tiny Rodent|g' gnuzilla/makeicecat
	sed -i 's|GNU Foundation|No Foundation|g' gnuzilla/makeicecat
	sed -i 's|No Corporation|No Corporation|g' gnuzilla/makeicecat
	sed -i 's|\\>GNU\\|\\>No\\|g' gnuzilla/makeicecat

clean:
	rm -rf chrome extensions features browser defaults fonts gmp-clearkey gtk2 icons libs libs/a libs/b libs/c libs/d libs/e

tar:
	mkdir -p parts/aa parts/ab parts/ac parts/ad parts/ae parts/af
	split -n 6 gingershrew-$(GINGERSHREW_VERSION).$(GINGERSHREW_REVISION).0.en-US.linux-x86_64.tar.bz2 split-gingershrew-$(GINGERSHREW_VERSION).$(GINGERSHREW_REVISION).0.en-US.linux-x86_64.tar.bz2.
	go run --tags generate gen.go

#tar: copy-linux
#	mkdir -p chrome extensions features browser defaults fonts gmp-clearkey gtk2 icons libs libs/a libs/b libs/c libs/d libs/e
#	tar cvzf chrome.tar.gz gingershrew/browser/chrome
#	tar cvzf extensions.tar.gz gingershrew/browser/extensions
#	tar cvzf features.tar.gz gingershrew/browser/features
#	tar cvzf browser.tar.gz gingershrew/browser/*.*
#	tar cvzf defaults.tar.gz gingershrew/defaults
#	tar cvzf fonts.tar.gz gingershrew/fonts
#	tar cvzf gmp-clearkey.tar.gz gingershrew/gmp-clearkey
#	tar cvzf gtk2.tar.gz gingershrew/gtk2
#	tar cvzf icons.tar.gz gingershrew/icons
#	tar cvzf libs.tar.gz gingershrew/libs
#	split -n 5 libs.tar.gz libs.tar.gz.
#	tar cvzf base.tar.gz gingershrew/root
#	ls -lah *.tar.gz
#	go run --tags generate gen.go


