package projector

import (
	"fmt"

	"github.com/ThePrimeagen/throbbing-judos/pkg/config"
)

func add(cfg *config.ProjectorConfig) error {

    if len(cfg.Terms) != 2 {
        return fmt.Errorf("invalid argument count (expected 2, found %v)", len(cfg.Terms))
    }

    cfg.Config.AddValue(cfg.Pwd, cfg.Terms[0], cfg.Terms[1])

    return nil
}

func remove(cfg *config.ProjectorConfig) error {

    if len(cfg.Terms) != 1 {
        return fmt.Errorf("invalid argument count (expected 2, found %v)", len(cfg.Terms))
    }

    cfg.Config.RemoveValue(cfg.Pwd, cfg.Terms[0])

    return nil
}

func Projector(cfg *config.ProjectorConfig) error {

    var err error
    switch cfg.Operation {
    case config.Add: err = add(cfg)
    case config.Remove: err = remove(cfg)
    }

    return err
}


