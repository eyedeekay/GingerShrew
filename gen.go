//+build generate

package main

import (
	"github.com/zserge/lorca"

	"io/ioutil"
	"log"
	"os"
	"path/filepath"
	"strings"
)

var icecatdir = "gnuzilla"

var lowercase = "gingershrew"
var CamelCase = "GingerShrew"
var UPPERCASE = "GINGERSHREW"

var Full_Name = "Free GingerShrew"
var Developer = "From A Tiny Rodent"
var Foundation = "No Foundation"
var Corporation ="No Corporation"


var unpacker = `package REPLACEME

import (
	"bytes"
	"fmt"
	"io"
//	"io/ioutil"
	"log"
	"os"
	"path/filepath"
)

func userFind() string {
	if os.Geteuid() == 0 {
		log.Fatal("Do not run this application as root!")
	}
	if un, err := os.UserHomeDir(); err == nil {
		os.MkdirAll(filepath.Join(un, "i2p"), 0755)
		return un
	}
	return ""
}

var userdir = filepath.Join(userFind(), "/i2p/firefox-profiles")

func writeFile(val os.FileInfo, system *fs) ([]byte, error) {
	if !val.IsDir() {
		file, err := system.Open(val.Name())
		if err != nil {
			return nil, err
		}
		sys := bytes.NewBuffer(nil)
		if _, err := io.Copy(sys, file); err != nil {
			return nil, err
		} else {
			return sys.Bytes(), nil
		}
	} else {
		log.Println(filepath.Join(userdir, val.Name()), "ignored", "contents", val.Sys())
	}
	return nil, fmt.Errorf("undefined unpacker error")
}

func WriteBrowser(FS *fs) ([]byte, error) {
	if embedded, err := FS.Readdir(-1); err != nil {
		log.Fatal("Extension error, embedded extension not read.", err)
	} else {
		for _, val := range embedded {
			if val.IsDir() {
				os.MkdirAll(filepath.Join(userdir, val.Name()), val.Mode())
			} else {
				return writeFile(val, FS)
			}
		}
	}
	return nil, nil
}
`

func main() {
	// You can also run "npm build" or webpack here, or compress assets, or
	// generate manifests, or do other preparations for your assets.

	if err := deleteDirectories(); err != nil {
		log.Fatal(err)
	}
	if err := createDirectories(); err != nil {
		log.Fatal(err)
	}
	if err := generateGoUnpacker(); err != nil {
		log.Fatal(err)
	}
	if err := splitBinaries(); err != nil {
		log.Fatal(err)
	}
	lorca.Embed("gsaa", "parts/aa/chunk.go", "gingershrew-68.9.0.en-US.linux-x86_64.tar.bz2.aa")
	log.Println("embedded gsaa")
	lorca.Embed("gsab", "parts/ab/chunk.go", "gingershrew-68.9.0.en-US.linux-x86_64.tar.bz2.ab")
	log.Println("embedded gsab")
	lorca.Embed("gsac", "parts/ac/chunk.go", "gingershrew-68.9.0.en-US.linux-x86_64.tar.bz2.ac")
	log.Println("embedded gsac")
	lorca.Embed("gsad", "parts/ad/chunk.go", "gingershrew-68.9.0.en-US.linux-x86_64.tar.bz2.ad")
	log.Println("embedded gsad")
	lorca.Embed("gsae", "parts/ae/chunk.go", "gingershrew-68.9.0.en-US.linux-x86_64.tar.bz2.ae")
	log.Println("embedded gsae")
	lorca.Embed("gsaf", "parts/af/chunk.go", "gingershrew-68.9.0.en-US.linux-x86_64.tar.bz2.af")
	log.Println("embedded gsaf")
	lorca.Embed("gsag", "parts/ag/chunk.go", "gingershrew-68.9.0.en-US.linux-x86_64.tar.bz2.ag")
	log.Println("embedded gsag")
	lorca.Embed("gsah", "parts/ah/chunk.go", "gingershrew-68.9.0.en-US.linux-x86_64.tar.bz2.ah")
	log.Println("embedded gsah")
	lorca.Embed("gsai", "parts/ai/chunk.go", "gingershrew-68.9.0.en-US.linux-x86_64.tar.bz2.ai")
	log.Println("embedded gsai")
	lorca.Embed("gsaj", "parts/aj/chunk.go", "gingershrew-68.9.0.en-US.linux-x86_64.tar.bz2.aj")
	log.Println("embedded gsaj")
	lorca.Embed("gsak", "parts/ak/chunk.go", "gingershrew-68.9.0.en-US.linux-x86_64.tar.bz2.ak")
	log.Println("embedded gsak")
	lorca.Embed("gsal", "parts/al/chunk.go", "gingershrew-68.9.0.en-US.linux-x86_64.tar.bz2.al")
	log.Println("embedded gsal")
}

var dirs = []string{
	"parts/aa",
	"parts/ab",
	"parts/ac",
	"parts/ad",
	"parts/ae",
	"parts/af",
	"parts/ag",
	"parts/ah",
	"parts/ai",
	"parts/aj",
	"parts/ak",
	"parts/al",
}

var libs = []string{
	"aa",
	"ab",
	"ac",
	"ad",
	"ae",
	"af",
	"ag",
	"ah",
	"ai",
	"aj",
	"ak",
	"al",
}

func splitBinaries() error {
	fileToBeChunked := "gingershrew-68.9.0.en-US.linux-x86_64.tar.bz2"
	bytes, err := ioutil.ReadFile(fileToBeChunked)
	if err != nil {
		return err
	}
	chunkSize := len(bytes) / 12
	for index, lib := range libs {
		start :=  index * chunkSize
		finish := ((index+1) * chunkSize)
		if index == 11 {
			finish = len(bytes)
		}
		outBytes := bytes[start:finish]
		err := ioutil.WriteFile(fileToBeChunked+"."+lib, outBytes, 0644)
		if err != nil {
			return err
		}
		log.Printf("Started at: %d,  Ended at: %d", start, finish)
	}
	return nil
}

func deleteDirectories() error {
	for _, dir := range libs {
		err := os.RemoveAll(filepath.Join("parts", dir))
		if err != nil {
			return err
		}
	}
	return nil
}

func createDirectories() error {
	for _, dir := range libs {
		err := os.MkdirAll(filepath.Join("parts", dir), 0755)
		if err != nil {
			return err
		}
	}
	return nil
}

func generateGoUnpacker() error {
	for index, dir := range libs {
		contents := strings.Replace(unpacker, "REPLACEME", "gs"+libs[index], -1)
		if err := ioutil.WriteFile(filepath.Join("parts", dir, "unpacker.go"), []byte(contents), 0644); err != nil {
			return err
		}
	}
	return nil
}
