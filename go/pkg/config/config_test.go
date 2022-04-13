package config_test

import (
	"os"
	"testing"

	"github.com/ThePrimeagen/throbbing-judos/pkg/config"
)

func TestGetConfigPathDefault(t *testing.T) {

    foundConfig, err := config.Config_getConfigPath("")

    if err != nil {
        t.Errorf("did not expect an error %v", err)
    }

    configHome, err := os.UserConfigDir()

    if err != nil {
        t.Errorf("did not expect an error %v", err)
    }

    if foundConfig != configHome {
        t.Errorf("expected pwd == configHome and it didnt %s == %s", foundConfig, configHome)
    }
}

func TestGetConfigPathProvided(t *testing.T) {

    foundConfig, err := config.Config_getConfigPath("/foo")

    if err != nil {
        t.Errorf("did not expect an error %v", err)
    }

    if foundConfig != "/foo" {
        t.Errorf("expected pwd == configHome and it didnt %s == /foo", foundConfig)
    }
}



