package gingershrew

import (
	"io/ioutil"

	"github.com/eyedeekay/gingershrew/parts/aa"
	"github.com/eyedeekay/gingershrew/parts/ab"
	"github.com/eyedeekay/gingershrew/parts/ac"
	"github.com/eyedeekay/gingershrew/parts/ad"
	"github.com/eyedeekay/gingershrew/parts/ae"
	"github.com/eyedeekay/gingershrew/parts/af"
	"github.com/eyedeekay/gingershrew/parts/ag"
	"github.com/eyedeekay/gingershrew/parts/ah"
	"github.com/eyedeekay/gingershrew/parts/ai"
	"github.com/eyedeekay/gingershrew/parts/aj"
	"github.com/eyedeekay/gingershrew/parts/ak"
	"github.com/eyedeekay/gingershrew/parts/al"
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
