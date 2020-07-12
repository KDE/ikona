package filesys

import (
	"context"
	"theme/app/conf"

	"bazil.org/fuse"
	"bazil.org/fuse/fs"
)

type FSIndexNode struct {
	Theme   conf.Theme
	Variant conf.Variant
}

func (f *FSIndexNode) Attr(ctx context.Context, a *fuse.Attr) error {
	a.Mode = 0755
	a.Size = uint64(len([]byte(f.Theme.CreateIndexTheme(f.Variant))))
	return nil
}

func (f *FSIndexNode) Lookup(ctx context.Context, req *fuse.LookupRequest, resp *fuse.LookupResponse) (fs.Node, error) {
	return nil, nil
}

var _ = fs.NodeOpener(&FSIndexNode{})

func (f *FSIndexNode) Open(ctx context.Context, req *fuse.OpenRequest, resp *fuse.OpenResponse) (fs.Handle, error) {
	handle := FSStringHandleFromString(f.Theme.CreateIndexTheme(f.Variant))
	resp.Flags |= fuse.OpenNonSeekable
	return &handle, nil
}
