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
            Links: map[string][]string{},
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

func TestProjectorRemove(t *testing.T) {
    pwd := "/foo/bar"
    cfg := &config.ProjectorConfig {
        Pwd: pwd,
        Config: &config.Config {
            Links: map[string][]string{},
            Projector: map[string]map[string]string{
                pwd: {
                    "foo": "bar",
                    "baz": "thenamesty",
                },
            },
        },
        Operation: config.Remove,
        Terms: []string{"foo"},
    }

    foo, ok := cfg.Config.GetValue(pwd, "foo")
    if !ok {
        t.Errorf("expected to find a value, but config responded with false")
    }
    baz, ok := cfg.Config.GetValue(pwd, "baz")
    if !ok {
        t.Errorf("expected to find a value, but config responded with false")
    }

    if foo != "bar" {
        t.Errorf("expected to find the value bar but found \"%v\"", foo)
    }

    if baz != "thenamesty" {
        t.Errorf("expected to find the value bar but found \"%v\"", baz)
    }

    projector.Projector(cfg)
    _, ok = cfg.Config.GetValue(pwd, "foo")

    if ok {
        t.Errorf("expected to not find the value because it was deleted.")
    }
}


