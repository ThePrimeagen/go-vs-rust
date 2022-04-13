package config

import (
	"encoding/json"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"

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
	Config *Config

	Operation Operation
	Terms     []string
}

type MapOfStrings = map[string]string
type Config struct {
    Links map[string][]string `json:"links"`
    Projector map[string]MapOfStrings `json:"projector"`
}

func (c *Config) AddValue(pwd, key, value string) {
    var path MapOfStrings
    if _, found := c.Projector[pwd]; !found {
        c.Projector[pwd] = map[string]string{}
        path = c.Projector[pwd]
    }

    path[key] = value
}

func (c *Config) getValue(pwd, key string) (string, bool) {
    if _, ok := c.Projector[pwd]; !ok {
        return "", false
    }

    val, ok := c.Projector[pwd][key]
    return val, ok
}

func (c *Config) GetValue(pwd, key string) (string, bool) {
    for {
        if val, ok := c.getValue(pwd, key); ok {
            return val, true
        }

        pwd_next := filepath.Dir(pwd)
        if pwd == pwd_next {
            break
        }

        pwd = pwd_next
    }

    if linkSet, ok := c.Links[pwd]; ok {
        for _, link := range linkSet {
            if val, ok := c.getValue(link, key); ok {
                return val, true
            }
        }
    }

    return "", false
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
        Config: cfg,
        Operation: nameToOperation(cmd),
        Terms: opts.Args().Tail(),
    }, nil
}
