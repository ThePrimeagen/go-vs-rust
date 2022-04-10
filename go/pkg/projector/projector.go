package projector

import (
	"fmt"

	"github.com/ThePrimeagen/throbbing-judos/pkg/config"
)

func add(cfg config.Config) error {

    if len(cfg.Terms) != 2 {
        return fmt.Errorf("invalid argument count (expected 2, found %v)", len(cfg.Terms))
    }

    return nil
}

func Projector(cfg config.Config) {

    switch cfg.Operation {
    case config.Add: add(cfg)
    }
}


