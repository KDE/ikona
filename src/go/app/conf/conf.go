package conf

import (
	"fmt"
	"path"
	"strings"
)

type Preprocessor struct {
	Kind string `hcl:",label"`
}

type Directory struct {
	Directory  string         `hcl:",label"`
	Context    string         `hcl:"context"`
	Type       string         `hcl:"type,optional"`
	Sizes      []string       `hcl:"sizes"`
	Preprocess []Preprocessor `hcl:"preprocess,block"`
}

type Inherit struct {
	From       string         `hcl:",label"`
	Preprocess []Preprocessor `hcl:"preprocess,block"`
}

type Variant struct {
	Directory     string         `hcl:",label"`
	Type          string         `hcl:"type"`
	Name          string         `hcl:"name,optional"`
	Description   string         `hcl:"description,optional"`
	Preprocessors []Preprocessor `hcl:"preprocess,block"`
	Directories   []Directory    `hcl:"directory,block"`
	Inherits      []Inherit      `hcl:"inherit,block"`
}

type Theme struct {
	Directory   string    `hcl:",label"`
	Name        string    `hcl:"name"`
	Description string    `hcl:"description"`
	Variants    []Variant `hcl:"variant,block"`
}

type ThemeConfig struct {
	Themes []Theme `hcl:"theme,block"`
}

func (t Theme) LookupVariant(name string) *Variant {
	for _, variant := range t.Variants {
		if variant.Directory == name {
			return &variant
		}
	}
	return nil
}

func ProcessSizeAndScale(s string) (size, scale string) {
	if !strings.Contains(s, "@") {
		return s, ""
	}
	parts := strings.Split(s, "@")
	if len(parts) >= 2 {
		return parts[0], strings.TrimPrefix(parts[1], "x")
	}
	return s, ""
}

func (t Theme) AllDirs(v Variant) []Directory {
	var ret []Directory
	ret = append(ret, v.Directories...)
	for _, inherits := range v.Inherits {
		lookedUp := t.LookupVariant(inherits.From)
		if lookedUp == nil {
			continue
		}
		ret = append(ret, lookedUp.Directories...)
	}
	return ret
}

func (t Theme) NameFor(v Variant) string {
	if v.Name != "" {
		return v.Name
	}
	return t.Name
}

func (t Theme) DescFor(v Variant) string {
	if v.Name != "" {
		return v.Description
	}
	return t.Description
}

func (t Theme) TypeFor(v Variant, d Directory) string {
	if d.Type != "" {
		return d.Type
	}
	if v.Type != "" {
		return v.Type
	}
	return ""
}

func (v Variant) TypeFor(d Directory) string {

	return v.Type
}

func (t Theme) CreateIndexTheme(v Variant) string {
	var directories []string
	var descriptions []string
	for _, dir := range t.AllDirs(v) {
		for _, size := range dir.Sizes {
			directories = append(directories, path.Join(dir.Directory, size))
			trueSize, trueScale := ProcessSizeAndScale(size)
			desc := fmt.Sprintf(`[%s]
Size=%s
Context=%s
Type=%s`, path.Join(dir.Directory, size), trueSize, strings.Title(dir.Context), strings.Title(v.TypeFor(dir)))
			if trueScale != "" {
				desc += "\nScale=" + trueScale
			}
			descriptions = append(descriptions, desc)
		}
	}
	return fmt.Sprintf(`[Icon Theme]
Name=%s
Comment=%s
Inherits=hicolor
Directories=%s

%s`, t.NameFor(v), t.DescFor(v), strings.Join(directories, ","), strings.Join(descriptions, "\n\n"))
}
