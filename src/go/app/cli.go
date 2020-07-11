package app

import (
	"os"

	"github.com/urfave/cli/v2"
)

func Main() {
	app := cli.App{
		Name:  "theme",
		Usage: "Ikona Theme processor",
		Commands: []*cli.Command{
			{
				Name:   "serve",
				Usage:  "Serve a theme described by a config file at a location",
				Action: Serve,
			},
		},
	}
	app.Run(os.Args)
}
