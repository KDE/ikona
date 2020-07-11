package filesys

import (
	"path"
	"theme/app/conf"

	"bazil.org/fuse/fs"
)

type FS struct {
	Config conf.ThemeConfig
}

func (f *FS) Root() (fs.Node, error) {
	return &FSRoot{f}, nil
}

type PreprocPath struct {
	Path          string
	Preprocessors []conf.Preprocessor
}

func SearchPaths(conf conf.ThemeConfig, theme conf.Theme, variant conf.Variant, context conf.Directory, size string) []PreprocPath {
	var ret []PreprocPath
	ret = append(ret, PreprocPath{
		Path: path.Join(theme.Directory, variant.Directory, context.Directory, size),
	})
	for _, from := range variant.Inherits {
		if inheritFrom := theme.LookupVariant(from.From); inheritFrom != nil {
			ret = append(ret, PreprocPath{
				Path:          path.Join(theme.Directory, inheritFrom.Directory, context.Directory, size),
				Preprocessors: from.Preprocess,
			})
		}
	}
	return ret
}
