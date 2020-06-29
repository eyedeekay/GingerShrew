
export GO111MODULE=on
GO111MODULE=on

VERSION=0.75
LAUNCH_VERSION=$(VERSION).09
GINGERSHREW_VERSION=68
GINGERSHREW_REVISION=9

GO_COMPILER_OPTS = -a -tags netgo -ldflags '-w -extldflags "-static"'

build: gingershrew gen

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
	#find . -name gingershrew-$(GINGERSHREW_VERSION).$(GINGERSHREW_REVISION).0.en-US.linux-x86_64.tar.bz2 -exec tar xjf {} \;
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
	rm -rfv gnuzilla \
		gingershrew*.tar.bz2*

gen:
	go run --tags generate gen.go

test:
	cd import && GO111MODULE=off go test


