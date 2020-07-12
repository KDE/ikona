package filesys

import (
	"context"
	"fmt"
	"io"
	"os"
	"os/exec"
	"path"
	"strings"
	"theme/app/conf"

	"bazil.org/fuse"
	"bazil.org/fuse/fs"
)

type FSNode struct {
	Path    PreprocPath
	Conf    conf.ThemeConfig
	Theme   conf.Theme
	Variant conf.Variant
	Context conf.Directory
}

func (f *FSNode) Attr(ctx context.Context, a *fuse.Attr) error {
	a.Mode = 0755
	return nil
}

var _ = fs.NodeOpener(&FSNode{})

func Copy(src, dst string) error {
	in, err := os.Open(src)
	if err != nil {
		return err
	}
	defer in.Close()

	out, err := os.Create(dst)
	if err != nil {
		return err
	}
	defer out.Close()

	_, err = io.Copy(out, in)
	if err != nil {
		return err
	}
	return out.Close()
}

func Preprocess(inputPath string, processors ...conf.Preprocessor) (string, error) {
	outputPath := path.Join(os.TempDir(), RandStr())

	err := Copy(inputPath, outputPath)
	if err != nil {
		return "", err
	}

	for _, preprocessor := range processors {
		kind := preprocessor.Kind
		var err error
		var out []byte
		switch kind {
		case "optimize":
			out, err = exec.Command("ikona-cli", "optimize", "-m", "all", "-i", outputPath).CombinedOutput()
		case "stylesheet-breeze-light":
			out, err = exec.Command("ikona-cli", "class", "-m", "light", "-i", outputPath).CombinedOutput()
		case "stylesheet-breeze-dark":
			out, err = exec.Command("ikona-cli", "class", "-m", "light", "-i", outputPath).CombinedOutput()
		case "convert-breeze-light-to-breeze-dark":
			out, err = exec.Command("ikona-cli", "convert", "-t", "dark", "-i", outputPath).CombinedOutput()
		case "convert-breeze-dark-to-breeze-light":
			out, err = exec.Command("ikona-cli", "convert", "-t", "light", "-i", outputPath).CombinedOutput()
		}
		if err != nil {
			return "", fmt.Errorf("error: %w\nOutput:\n%s", err, string(out))
		}
	}

	return outputPath, nil
}

func (f FSNode) Lookup(ctx context.Context, req *fuse.LookupRequest, resp *fuse.LookupResponse) (fs.Node, error) {
	return nil, nil
}

func (f FSNode) Preprocessors() (ret []conf.Preprocessor) {
	for _, inherit := range f.Variant.Inherits {
		theme := f.Theme.LookupVariant(inherit.From)
		if theme == nil {
			continue
		}
		ret = append(ret, theme.Preprocessors...)
	}
	ret = append(ret, f.Variant.Preprocessors...)
	ret = append(ret, f.Context.Preprocess...)
	ret = append(ret, f.Path.Preprocessors...)
	return
}

func (f *FSNode) Open(ctx context.Context, req *fuse.OpenRequest, resp *fuse.OpenResponse) (fs.Handle, error) {
	path, err := Preprocess(f.Path.Path, f.Preprocessors()...)
	if err != nil {
		println(err.Error())
		return nil, err
	}
	file, err := os.Open(path)
	if err != nil {
		println(err.Error())
		return nil, err
	}
	resp.Flags |= fuse.OpenNonSeekable
	return FSHandle{file}, nil
}

type FSHandle struct {
	r io.ReadCloser
}

var _ = fs.HandleReader(&FSHandle{})
var _ = fs.HandleReleaser(&FSHandle{})

func (f *FSHandle) Release(ctx context.Context, req *fuse.ReleaseRequest) error {
	return f.r.Close()
}

func (f *FSHandle) Read(ctx context.Context, req *fuse.ReadRequest, resp *fuse.ReadResponse) error {
	buf := make([]byte, req.Size)
	n, err := f.r.Read(buf)
	resp.Data = buf[:n]
	return err
}

type FSStringHandle struct {
	str    string
	reader *strings.Reader
}

func FSStringHandleFromString(str string) FSStringHandle {
	return FSStringHandle{
		str,
		strings.NewReader(str),
	}
}

var _ = fs.HandleReader(&FSStringHandle{})
var _ = fs.HandleReleaser(&FSStringHandle{})

func (f *FSStringHandle) Release(ctx context.Context, req *fuse.ReleaseRequest) error {
	return nil
}

func (f *FSStringHandle) Read(ctx context.Context, req *fuse.ReadRequest, resp *fuse.ReadResponse) error {
	buf := make([]byte, req.Size)
	n, err := f.reader.Read(buf)
	resp.Data = buf[:n]
	return err
}
