package config

import (
	"encoding/json"
	"io/ioutil"
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
    Links MapOfStrings `json:"links"`
    Projector map[string]MapOfStrings `json:"projector"`
}

func getConfigFromFile(path string) (*Config, error) {
    if _, err := os.Stat(path); os.IsNotExist(err) {
        {
            f, err := os.Create(path)
            if err != nil {
                return nil, err
            }
            defer func() {
                log.Println("Defer");
                f.Close()
            }()

            _, err = f.WriteString("{\"links\": {}, \"projector\": {}}\n")
            if err != nil {
                return nil, err
            }

            f.Sync()
        }
        log.Println("Post Defer");
    }

    content, err := ioutil.ReadFile(path)
    if err != nil {
        return nil, err
    }

    var config Config
    json.Unmarshal(content, &config)

    return &config, nil
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

func getPWDPath(pwd string) (string, error) {
	if pwd == "" {
		oswd, err := os.Getwd()
		if err != nil {
            return "", err
		}

		pwd = oswd
	}

    return pwd, nil
}

func getConfigPath(config string) (string, error) {
	if config == "" {
		configHome, err := os.UserConfigDir()
		if err != nil {
            return "", err
		}
		config = configHome
	}

    return config, nil
}

func NewConfig(cmd string, opts Opts) (*ProjectorConfig, error) {
    pwd, err := getPWDPath(opts.String("pwd"))
    if err != nil {
        return nil, err
    }

    config, err := getConfigPath(opts.String("config"))
    if err != nil {
        return nil, err
    }

    cfg, err := getConfigFromFile(config)
    if err != nil {
        log.Fatalf("Unable to read config file: %+v\n", err)
    }

	return &ProjectorConfig {
        Pwd: pwd,
        Config: *cfg,
        Operation: nameToOperation(cmd),
        Terms: opts.Args().Tail(),
    }, nil
}
