package projector_test

import (
	"testing"

	"github.com/ThePrimeagen/throbbing-judos/pkg/config"
	"github.com/ThePrimeagen/throbbing-judos/pkg/projector"
)

func TestProjectorAdd(t *testing.T) {
    pwd := "/foo/bar"
    cfg := &config.ProjectorConfig {
        Pwd: pwd,
        Config: &config.Config {
            Links: map[string]string{},
            Projector: map[string]map[string]string{},
        },
        Operation: config.Add,
        Terms: []string{"foo", "bar"},
    }

    projector.Projector(cfg)

    value, ok := cfg.Config.GetValue(pwd, "foo")
    if !ok {
        t.Errorf("expected to find a value, but config responded with false")
    }

    if value != "bar" {
        t.Errorf("expected to find the value bar but found \"%v\"", value)
    }
}


