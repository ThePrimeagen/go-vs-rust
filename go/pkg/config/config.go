package config

import (
	"fmt"
	"log"
	"os"

	"github.com/urfave/cli/v2"
)

type Opts interface {
	String(string) string
	Args() cli.Args
}

type Operation int

const (
	Add Operation = iota
	Remove
	Link
	Unlink
	Print
)

type ProjectorConfig struct {
	Pwd    string
	Config Config

	Operation Operation
	Terms     []string
}

type MapOfStrings = map[string]string
type Config struct {
    links MapOfStrings
    projector map[string]MapOfStrings
}

func nameToOperation(cmd string) Operation {
    switch (cmd) {
    case "add": return Add
    case "rm": return Remove
    case "link": return Link
    case "unlink": return Unlink
    }
    return Print
}

func NewConfig(cmd string, opts Opts) ProjectorConfig {
	pwd := opts.String("pwd")
	if pwd == "" {
		oswd, err := os.Getwd()
		if err != nil {
			log.Fatalf("%+v\n", err)
		}

		pwd = oswd
	}

	config := opts.String("config")
    fmt.Printf("NewConfig %v %v\n", config, opts)
	if config == "" {
		configHome, err := os.UserConfigDir()
		if err != nil {
			log.Fatalf("Your operating system sucks so much, it does not have a config home.  Go cry in windows child.  Unless you use Arch, then go cry in maidenless. %+v\n", err)
		}
		config = configHome
	}

	return ProjectorConfig {
        Pwd: pwd,
        Config: config,
        Operation: nameToOperation(cmd),
        Terms: opts.Args().Tail(),
    }
}
