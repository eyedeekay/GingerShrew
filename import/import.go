package gingershrew

import (
	"io/ioutil"
	"os"
	"path/filepath"

	"github.com/mholt/archiver/v3"

	"github.com/eyedeekay/GingerShrew/parts/aa"
	"github.com/eyedeekay/GingerShrew/parts/ab"
	"github.com/eyedeekay/GingerShrew/parts/ac"
	"github.com/eyedeekay/GingerShrew/parts/ad"
	"github.com/eyedeekay/GingerShrew/parts/ae"
	"github.com/eyedeekay/GingerShrew/parts/af"
	"github.com/eyedeekay/GingerShrew/parts/ag"
	"github.com/eyedeekay/GingerShrew/parts/ah"
	"github.com/eyedeekay/GingerShrew/parts/ai"
	"github.com/eyedeekay/GingerShrew/parts/aj"
	"github.com/eyedeekay/GingerShrew/parts/ak"
	"github.com/eyedeekay/GingerShrew/parts/al"
)

func TBZBytes() ([]byte, error) {
	var bytes []byte
	ba, err := gsaa.WriteBrowser(gsaa.FS)
	if err != nil {
		return nil, err
	}
	bytes = append(bytes, ba...)
	bb, err := gsab.WriteBrowser(gsab.FS)
	if err != nil {
		return nil, err
	}
	bytes = append(bytes, bb...)
	bc, err := gsac.WriteBrowser(gsac.FS)
	if err != nil {
		return nil, err
	}
	bytes = append(bytes, bc...)
	bd, err := gsad.WriteBrowser(gsad.FS)
	if err != nil {
		return nil, err
	}
	bytes = append(bytes, bd...)
	be, err := gsae.WriteBrowser(gsae.FS)
	if err != nil {
		return nil, err
	}
	bytes = append(bytes, be...)
	bf, err := gsaf.WriteBrowser(gsaf.FS)
	if err != nil {
		return nil, err
	}
	bytes = append(bytes, bf...)
	bg, err := gsag.WriteBrowser(gsag.FS)
	if err != nil {
		return nil, err
	}
	bytes = append(bytes, bg...)
	bh, err := gsah.WriteBrowser(gsah.FS)
	if err != nil {
		return nil, err
	}
	bytes = append(bytes, bh...)
	bi, err := gsai.WriteBrowser(gsai.FS)
	if err != nil {
		return nil, err
	}
	bytes = append(bytes, bi...)
	bj, err := gsaj.WriteBrowser(gsaj.FS)
	if err != nil {
		return nil, err
	}
	bytes = append(bytes, bj...)
	bk, err := gsak.WriteBrowser(gsak.FS)
	if err != nil {
		return nil, err
	}
	bytes = append(bytes, bk...)
	bl, err := gsal.WriteBrowser(gsal.FS)
	if err != nil {
		return nil, err
	}
	bytes = append(bytes, bl...)
	return bytes, nil
}

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
	return nil
}
