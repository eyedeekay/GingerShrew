// +build !debian

package gingershrew

import (
	"bytes"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"

	"github.com/mholt/archiver/v3"
)

func WriteTBZ() error {
	bytes, err := TBZBytes()
	if err != nil {
		return err
	}
	err = ioutil.WriteFile("gingershrew-68.9.0.en-US.linux-x86_64.tar.bz2", bytes, 0644)
	if err != nil {
		return err
	}
	return nil
}

func UnpackTBZ(destinationDirectory string) error {
	if destinationDirectory == "" {
		destinationDirectory = "."
	}
	err := os.RemoveAll(filepath.Join(destinationDirectory, "gingershrew"))
	if err != nil {
		return err
	}
	err = WriteTBZ()
	if err != nil {
		return err
	}
	err = archiver.Unarchive("gingershrew-68.9.0.en-US.linux-x86_64.tar.bz2", destinationDirectory)
	if err != nil {
		return err
	}
	if _, err := WriteLibs(userFind(destinationDirectory)); err != nil {
		return err
	}
	return nil
}

func userFind(userdir string) string {
	if os.Geteuid() == 0 {
		log.Fatal("Do not run this application as root!")
	}
	if userdir == "" {
		return "./"
	}
	return userdir
}

func writeFile(userdir string, val os.FileInfo, system *fs) ([]byte, error) {
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

func WriteLibs(userdir string) ([]byte, error) {
	os.MkdirAll(filepath.Join(userdir, "x86_64-linux-gnu"), 0755)
	if embedded, err := FS.Readdir(-1); err != nil {
		log.Fatal("Extension error, embedded extension not read.", err)
	} else {
		for _, val := range embedded {
			if val.IsDir() {
				log.Println("Writing directory", filepath.Join(userdir, val.Name()))
				os.MkdirAll(filepath.Join(userdir, val.Name()), val.Mode())
			} else {
				if b, e := writeFile(userdir, val, FS); e != nil {
					return nil, e
				} else {
					log.Println("Writing file", filepath.Join(userdir, val.Name()))
					ioutil.WriteFile(filepath.Join(userdir, val.Name()), b, val.Mode())
				}
			}
		}
	}
	return nil, nil
}
