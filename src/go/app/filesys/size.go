package filesys

import (
	"context"
	"os"
	"path"
	"path/filepath"
	"strings"
	"theme/app/conf"

	"bazil.org/fuse"
	"bazil.org/fuse/fs"
)

type FSSize struct {
	Size    string
	Conf    conf.ThemeConfig
	Theme   conf.Theme
	Variant conf.Variant
	Context conf.Directory
}

func (f *FSSize) Attr(ctx context.Context, a *fuse.Attr) error {
	a.Mode = os.ModeDir | 0755
	return nil
}

var _ = fs.HandleReadDirAller(&FSRoot{})

func (f *FSSize) ReadDirAll(context.Context) ([]fuse.Dirent, error) {
	var ret []fuse.Dirent
	paths := SearchPaths(f.Conf, f.Theme, f.Variant, f.Context, f.Size)
	for _, searchPath := range paths {
		filepath.Walk(searchPath.Path, func(path string, fi os.FileInfo, err error) error {
			if err != nil {
				return err
			}
			if fi.IsDir() {
				return nil
			}
			if strings.HasSuffix(path, "svg") {
				ret = append(ret, fuse.Dirent{
					Type: fuse.DT_File,
					Name: strings.TrimPrefix(strings.TrimPrefix(path, searchPath.Path), "/"),
				})
			}
			return nil
		})
	}
	return ret, nil
}

var _ = fs.NodeRequestLookuper(&FSVariant{})

func (f *FSSize) Lookup(ctx context.Context, req *fuse.LookupRequest, resp *fuse.LookupResponse) (fs.Node, error) {
	paths := SearchPaths(f.Conf, f.Theme, f.Variant, f.Context, f.Size)
	var resolved PreprocPath
	for _, searchPath := range paths {
		filepath.Walk(searchPath.Path, func(inputPath string, fi os.FileInfo, err error) error {
			if err != nil {
				return err
			}
			if fi.IsDir() {
				return nil
			}
			if strings.HasSuffix(inputPath, "svg") {
				if path.Base(inputPath) == req.Name {
					resolved = PreprocPath{
						Path:          inputPath,
						Preprocessors: searchPath.Preprocessors,
					}
				}
			}
			return nil
		})
	}
	if resolved.Path != "" {
		return &FSNode{resolved, f.Conf, f.Theme, f.Variant, f.Context}, nil
	}
	return nil, fuse.ENOENT
}
