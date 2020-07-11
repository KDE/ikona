package filesys

import (
	"context"
	"os"
	"theme/app/conf"

	"bazil.org/fuse"
	"bazil.org/fuse/fs"
)

type FSVariant struct {
	Conf    conf.ThemeConfig
	Theme   conf.Theme
	Variant conf.Variant
}

var _ = fs.Node(&FSVariant{})

func (f *FSVariant) Attr(ctx context.Context, attr *fuse.Attr) error {
	attr.Mode = os.ModeDir | 0755
	return nil
}

var _ = fs.HandleReadDirAller(&FSVariant{})

func (f *FSVariant) ReadDirAll(context.Context) (ret []fuse.Dirent, err error) {
	for _, inherit := range f.Variant.Inherits {
		variant := f.Theme.LookupVariant(inherit.From)
		if variant == nil {
			continue
		}
		for _, dir := range variant.Directories {
			ret = append(ret, fuse.Dirent{
				Type: fuse.DT_Dir,
				Name: dir.Directory,
			})
		}
	}
	for _, dir := range f.Variant.Directories {
		ret = append(ret, fuse.Dirent{
			Type: fuse.DT_Dir,
			Name: dir.Directory,
		})
	}
	return
}

var _ = fs.NodeRequestLookuper(&FSVariant{})

func (f *FSVariant) Lookup(ctx context.Context, req *fuse.LookupRequest, resp *fuse.LookupResponse) (fs.Node, error) {
	for _, inherit := range f.Variant.Inherits {
		variant := f.Theme.LookupVariant(inherit.From)
		if variant == nil {
			continue
		}
		for _, dir := range variant.Directories {
			if dir.Directory == req.Name {
				return &FSContext{dir.Sizes, f.Conf, f.Theme, f.Variant, dir}, nil
			}
		}
	}
	for _, dir := range f.Variant.Directories {
		if dir.Directory == req.Name {
			return &FSContext{dir.Sizes, f.Conf, f.Theme, f.Variant, dir}, nil
		}
	}
	return nil, fuse.ENOENT
}
