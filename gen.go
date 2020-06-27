//+build generate

package main

import "github.com/zserge/lorca"

func main() {
	// You can also run "npm build" or webpack here, or compress assets, or
	// generate manifests, or do other preparations for your assets.
	lorca.Embed("gsaa", "parts/aa/chunk.go", "split-gingershrew-68.9.0.en-US.linux-x86_64.tar.bz2.aa")
	lorca.Embed("gsab", "parts/ab/chunk.go", "split-gingershrew-68.9.0.en-US.linux-x86_64.tar.bz2.ab")
	lorca.Embed("gsac", "parts/ac/chunk.go", "split-gingershrew-68.9.0.en-US.linux-x86_64.tar.bz2.ac")
	lorca.Embed("gsad", "parts/ad/chunk.go", "split-gingershrew-68.9.0.en-US.linux-x86_64.tar.bz2.ad")
	lorca.Embed("gsae", "parts/ae/chunk.go", "split-gingershrew-68.9.0.en-US.linux-x86_64.tar.bz2.ae")
	lorca.Embed("gsaf", "parts/af/chunk.go", "split-gingershrew-68.9.0.en-US.linux-x86_64.tar.bz2.af")
	lorca.Embed("gsag", "parts/ag/chunk.go", "split-gingershrew-68.9.0.en-US.linux-x86_64.tar.bz2.ag")
	lorca.Embed("gsah", "parts/ah/chunk.go", "split-gingershrew-68.9.0.en-US.linux-x86_64.tar.bz2.ah")
	lorca.Embed("gsai", "parts/ai/chunk.go", "split-gingershrew-68.9.0.en-US.linux-x86_64.tar.bz2.ai")
	lorca.Embed("gsaj", "parts/aj/chunk.go", "split-gingershrew-68.9.0.en-US.linux-x86_64.tar.bz2.aj")
	lorca.Embed("gsak", "parts/ak/chunk.go", "split-gingershrew-68.9.0.en-US.linux-x86_64.tar.bz2.ak")
	lorca.Embed("gsal", "parts/al/chunk.go", "split-gingershrew-68.9.0.en-US.linux-x86_64.tar.bz2.al")
}
