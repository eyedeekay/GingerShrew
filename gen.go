//+build generate

package main

import "github.com/zserge/lorca"

func main() {
	// You can also run "npm build" or webpack here, or compress assets, or
	// generate manifests, or do other preparations for your assets.
	lorca.Embed("gingershrew", "chrome/chrome.go", "chrome.tar.gz")
	lorca.Embed("gingershrew", "extensions/extensions.go", "extensions.tar.gz")
	lorca.Embed("gingershrew", "features/features.go", "features.tar.gz")
	lorca.Embed("gingershrew", "browser/browser.go", "browser.tar.gz")
	lorca.Embed("gingershrew", "defaults/defaults.go", "defaults.tar.gz")
	lorca.Embed("gingershrew", "fonts/fonts.go", "fonts.tar.gz")
	lorca.Embed("gingershrew", "gmp-clearkey/gmp-clearkey.go", "gmp-clearkey.tar.gz")
	lorca.Embed("gingershrew", "gtk2/gtk2.go", "gtk2.tar.gz")
	lorca.Embed("gingershrew", "icons/icons.go", "icons.tar.gz")
	lorca.Embed("gingershrew", "libs/a/libsa.go", "libs.tar.gz.aa")
	lorca.Embed("gingershrew", "libs/b/libsb.go", "libs.tar.gz.ab")
	lorca.Embed("gingershrew", "libs/c/libsc.go", "libs.tar.gz.ac")
	lorca.Embed("gingershrew", "libs/d/libsd.go", "libs.tar.gz.ad")
	lorca.Embed("gingershrew", "libs/e/libse.go", "libs.tar.gz.ae")
	lorca.Embed("gingershrew", "base/base.go", "base.tar.gz")
}
