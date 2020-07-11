package filesys

import (
	"context"
	"os"
	"strings"

	"bazil.org/fuse"
	"bazil.org/fuse/fs"
)

type FSRoot struct {
	Parent *FS
}

func (f *FSRoot) Attr(ctx context.Context, a *fuse.Attr) error {
	a.Mode = os.ModeDir | 0755
	return nil
}

var _ = fs.HandleReadDirAller(&FSRoot{})

func (f *FSRoot) ReadDirAll(context.Context) (ret []fuse.Dirent, err error) {
	conf := f.Parent.Config
	for _, theme := range conf.Themes {
		for _, variant := range theme.Variants {
			ret = append(ret, fuse.Dirent{
				Type: fuse.DT_Dir,
				Name: strings.Join([]string{theme.Directory, variant.Directory}, "-"),
			})
		}
	}
	return
}

var _ = fs.NodeRequestLookuper(&FSRoot{})

func (f *FSRoot) Lookup(ctx context.Context, req *fuse.LookupRequest, resp *fuse.LookupResponse) (fs.Node, error) {
	for _, theme := range f.Parent.Config.Themes {
		for _, variant := range theme.Variants {
			if strings.Join([]string{theme.Directory, variant.Directory}, "-") == req.Name {
				return &FSVariant{f.Parent.Config, theme, variant}, nil
			}
		}
	}
	return nil, fuse.ENOENT
}
