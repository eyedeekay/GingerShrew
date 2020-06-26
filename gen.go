//+build generate

package main

import "github.com/zserge/lorca"

func main() {
	// You can also run "npm build" or webpack here, or compress assets, or
	// generate manifests, or do other preparations for your assets.
	/*lorca.Embed("chrome", "chrome/chrome.go", "chrome.tar.gz")
	lorca.Embed("extensions", "extensions/extensions.go", "extensions.tar.gz")
	lorca.Embed("features", "features/features.go", "features.tar.gz")
	lorca.Embed("browser", "browser/browser.go", "browser.tar.gz")
	lorca.Embed("defaults", "default/defaults.go", "defaults.tar.gz")
	lorca.Embed("fonts", "fonts/fonts.go", "fonts.tar.gz")
	lorca.Embed("gmpclearkey", "gmp-clearkey/gmp-clearkey.go", "gmp-clearkey.tar.gz")
	lorca.Embed("gtk2", "gtk2/gtk2.go", "gtk2.tar.gz")
	lorca.Embed("icons", "icons/icons.go", "icons.tar.gz")
	lorca.Embed("libsa", "libs/a/libsa.go", "libs.tar.gz.aa")
	lorca.Embed("libsb", "libs/b/libsb.go", "libs.tar.gz.ab")
	lorca.Embed("libsc", "libs/c/libsc.go", "libs.tar.gz.ac")
	lorca.Embed("libsd", "libs/d/libsd.go", "libs.tar.gz.ad")
	lorca.Embed("libse", "libs/e/libse.go", "libs.tar.gz.ae")
	lorca.Embed("base", "base/base.go", "base.tar.gz")*/
	lorca.Embed("gsaa", "parts/aa/chunk.go", "split-gingershrew-68.9.0.en-US.linux-x86_64.tar.bz2.aa")
	lorca.Embed("gsab", "parts/ab/chunk.go", "split-gingershrew-68.9.0.en-US.linux-x86_64.tar.bz2.ab")
	lorca.Embed("gsac", "parts/ac/chunk.go", "split-gingershrew-68.9.0.en-US.linux-x86_64.tar.bz2.ac")
	lorca.Embed("gsad", "parts/ad/chunk.go", "split-gingershrew-68.9.0.en-US.linux-x86_64.tar.bz2.ad")
	lorca.Embed("gsae", "parts/ae/chunk.go", "split-gingershrew-68.9.0.en-US.linux-x86_64.tar.bz2.ae")
	lorca.Embed("gsaf", "parts/af/chunk.go", "split-gingershrew-68.9.0.en-US.linux-x86_64.tar.bz2.af")
}
