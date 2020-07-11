package filesys

import (
	"context"
	"os"
	"theme/app/conf"

	"bazil.org/fuse"
	"bazil.org/fuse/fs"
)

type FSContext struct {
	Sizes   []string
	Conf    conf.ThemeConfig
	Theme   conf.Theme
	Variant conf.Variant
	Context conf.Directory
}

func (f *FSContext) Attr(ctx context.Context, a *fuse.Attr) error {
	a.Mode = os.ModeDir | 0755
	return nil
}

var _ = fs.HandleReadDirAller(&FSContext{})

func (f *FSContext) ReadDirAll(context.Context) (ret []fuse.Dirent, err error) {
	for _, size := range f.Sizes {
		ret = append(ret, fuse.Dirent{
			Type: fuse.DT_Dir,
			Name: size,
		})
	}
	return
}

var _ = fs.NodeRequestLookuper(&FSContext{})

func (f *FSContext) Lookup(ctx context.Context, req *fuse.LookupRequest, resp *fuse.LookupResponse) (fs.Node, error) {
	for _, size := range f.Sizes {
		if req.Name == size {
			return &FSSize{size, f.Conf, f.Theme, f.Variant, f.Context}, nil
		}
	}
	return nil, fuse.ENOENT
}
