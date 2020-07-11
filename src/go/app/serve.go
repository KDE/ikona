package app

import (
	"log"
	"os"
	"os/signal"
	"syscall"
	"theme/app/conf"
	"theme/app/filesys"

	"bazil.org/fuse"
	"bazil.org/fuse/fs"
	"github.com/alecthomas/repr"
	"github.com/hashicorp/hcl/v2/hclsimple"
	"github.com/urfave/cli/v2"
)

func Serve(c *cli.Context) error {
	var conf conf.ThemeConfig
	err := hclsimple.DecodeFile(c.Args().First(), nil, &conf)
	if err != nil {
		log.Fatalf("Failed to load configuration: %s", repr.String(err, repr.Indent("\t")))
	}

	conn, err := fuse.Mount(c.Args().Get(1))
	if err != nil {
		log.Fatalf("Failed to mount: %s", err)
	}
	defer conn.Close()

	filesys := filesys.FS{
		Config: conf,
	}
	if err := fs.Serve(conn, &filesys); err != nil {
		log.Fatalf("Failed to serve: %s", err)
	}

	<-conn.Ready

	sc := make(chan os.Signal, 1)
	signal.Notify(sc, syscall.SIGINT, syscall.SIGTERM, os.Interrupt, os.Kill)

	<-sc

	fuse.Unmount(c.Args().Get(1))

	return nil
}
