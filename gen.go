//+build generate

package main

import (
	"github.com/zserge/lorca"

	"io/ioutil"
	"log"
	"os"
	"path/filepath"
	"strconv"
	"strings"
)

var icecatdir = "gnuzilla"

var lowercase = "gingershrew"
var CamelCase = "GingerShrew"
var UPPERCASE = "GINGERSHREW"

var Full_Name = "Free GingerShrew"
var Developer = "From A Tiny Rodent"
var Foundation = "No Foundation"
var Corporation = "No Corporation"

var chunkNum = 128

var unpacker = `package REPLACEME

import (
	"bytes"
	"fmt"
	"io"
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

var mozconfig_windows = `
. "$topsrcdir/build/mozconfig.win-common"

unset MAKECAB
unset DUMP_SYMS

. "$topsrcdir/browser/config/mozconfigs/common"

export MOZ_PACKAGE_JSSHELL=1

ac_add_options --target=x86_64-w64-mingw32
ac_add_options --with-toolchain-prefix=x86_64-w64-mingw32-

ac_add_options --disable-warnings-as-errors
MOZ_COPY_PDBS=1
mk_add_options "export WIDL_TIME_OVERRIDE=0"

ac_add_options --enable-proxy-bypass-protection

ac_add_options --disable-webrtc # Bug 1393901
ac_add_options --disable-geckodriver # Bug 1489320
ac_add_options --disable-update-agent # Bug 1561797

HOST_CC="$MOZ_FETCHES_DIR/clang/bin/clang"
HOST_CXX="$MOZ_FETCHES_DIR/clang/bin/clang++"
CC="$MOZ_FETCHES_DIR/clang/bin/x86_64-w64-mingw32-clang"
CXX="$MOZ_FETCHES_DIR/clang/bin/x86_64-w64-mingw32-clang++"
ac_add_options --with-clang-path="$CC"
ac_add_options --with-libclang-path="$MOZ_FETCHES_DIR/clang/lib"
CXXFLAGS="-fms-extensions"
AR=llvm-ar
RANLIB=llvm-ranlib

BINDGEN_CFLAGS="-I$MOZ_FETCHES_DIR/clang/x86_64-w64-mingw32/include/c++/v1 -I$MOZ_FETCHES_DIR/clang/x86_64-w64-mingw32/include"

mk_add_options "export PATH=$MOZ_FETCHES_DIR/clang/bin:$MOZ_FETCHES_DIR/mingw32/bin:$MOZ_FETCHES_DIR/wine/bin:$MOZ_FETCHES_DIR/upx/bin:$MOZ_FETCHES_DIR/fxc2/bin:$MOZ_FETCHES_DIR/binutils/bin:$PATH"

LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}$MOZ_FETCHES_DIR/mingw32/lib64:$MOZ_FETCHES_DIR/clang/lib
mk_add_options "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH"


ac_add_options --with-branding=browser/branding/nightly

. "$topsrcdir/build/mozconfig.common.override"
`

func main() {
	// You can also run "npm build" or webpack here, or compress assets, or
	// generate manifests, or do other preparations for your assets.

	log.Println(generateGoGenerator())
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
	if err := updateAllChunks(); err != nil {
		log.Fatal(err)
	}
	if err := lorca.Embed("gingershrew", "import/libc.go", "lib/lib"); err != nil {
		log.Fatal(err)
	}
}

var libs = calculateChunks()

func updateChunk(chunk string) error {
	err := lorca.Embed("gs"+chunk, "parts/"+chunk+"/chunk_linux.go", GS_VERSION+"."+chunk)
	if err != nil {
		return err
	}
	log.Println("embedded gs" + chunk)
	return nil
}

func updateAllChunks() error {
	for _, lib := range libs {
		updateChunk(lib)
	}
	return nil
}

func calculateChunks() []string {
	/*fileToBeChunked := GS_VERSION
	bytes, err := ioutil.ReadFile(fileToBeChunked)
	if err != nil {
		log.Fatal(err)
	}*/
	var libs []string
	for i := 0; i < chunkNum; i++ {
		libs = append(libs, strconv.Itoa(i))
	}
	return libs
}

func chunkSize() int {
	fileToBeChunked := GS_VERSION
	bytes, err := ioutil.ReadFile(fileToBeChunked)
	if err != nil {
		log.Fatal(err)
	}
	chunkSize := len(bytes) / chunkNum
	return chunkSize
}

func splitBinaries() error {
	fileToBeChunked := GS_VERSION
	bytes, err := ioutil.ReadFile(fileToBeChunked)
	if err != nil {
		return err
	}
	chunkSize := chunkSize()
	for index, lib := range libs {
		start := index * chunkSize
		finish := ((index + 1) * chunkSize)
		if index == chunkNum-1 {
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

func generateGoGenerator() error {
	newfile := `package gingershrew

import (
`
	for index, dir := range libs {
		newfile += "	\"github.com/eyedeekay/GingerShrew/parts/" + dir + "\"\n"
		log.Println(dir, libs[index])
	}

	newfile += ")\n\n"

	newfile += `func TBZBytes() ([]byte, error) {
	var bytes []byte
	`

	for index, dir := range libs {
		newfile += `	b` + dir + `, err := gs` + dir + `.WriteBrowser(gs` + dir + `.FS)
	if err != nil {
		return nil, err
	}
	bytes = append(bytes, b` + dir + `...)
`
		log.Println(dir, libs[index])
	}

	newfile += `	return bytes, nil
}`
	err := ioutil.WriteFile("import/embed_linux.go", []byte(newfile), 0644)
	if err != nil {
		return err
	}
	return err
}
