package main

import (
	"log"
	"os"

	config "github.com/ThePrimeagen/throbbing-judos/pkg/config"
	"github.com/ThePrimeagen/throbbing-judos/pkg/projector"
	"github.com/urfave/cli/v2"
)

var flags []cli.Flag
func init() {
    flags = []cli.Flag{
        &cli.StringFlag{
            Name:  "config",
            Value: "",
            Usage: "path to a config to use, default will be XDG_CONFIG or HOME.",
        },
        &cli.StringFlag{
            Name:  "pwd",
            Value: "",
            Usage: "what directory to execute projector from.",
        },
    }
}

func generateAction(name, from string) func(*cli.Context) error {
    return func(c *cli.Context) error {
        cfg := config.NewConfig(name, c)
        log.Printf("generateAction(%v) %v", from, cfg)
        projector.Projector(cfg)
        return nil;
    }
}

func generateCommand(name string) *cli.Command {
    return &cli.Command {
        Name: name,
        Flags: flags,
        Action: generateAction(name, "generateCommand"),
    }
}

func main() {
	app := &cli.App{
        Commands: []*cli.Command{
            generateCommand("print"),
            generateCommand("add"),
            generateCommand("rm"),
            generateCommand("link"),
            generateCommand("unlink"),
        },
        Flags: flags,
		Action: generateAction("print", "mainfunc"),
	}

	err := app.Run(os.Args)
	if err != nil {
		log.Fatal(err)
	}
}
