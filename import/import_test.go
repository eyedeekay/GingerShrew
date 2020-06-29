package gingershrew

import (
	"testing"
)

func TestWriteTBZ(t *testing.T) {
	if err := WriteTBZ(); err != nil {
		t.Fatal(err)
	}
	t.Log("Success")
}
