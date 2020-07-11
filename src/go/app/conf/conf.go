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
	Type          string         `hcl:"type,optional"`
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

func (t Theme) CreateIndexTheme(v Variant) string {
	var directories []string
	var descriptions []string
	for _, dir := range v.Directories {
		for _, size := range dir.Sizes {
			directories = append(directories, path.Join(dir.Directory, size))
			trueSize, trueScale := ProcessSizeAndScale(size)
			iconType := dir.Type
			if iconType == "" {
				iconType = v.Type
			}
			desc := fmt.Sprintf(`[%s]
Size=%s
Context=%s
Type=%s`, path.Join(dir.Directory, size), trueSize, strings.Title(dir.Context), strings.Title(iconType))
			descriptions = append(descriptions, desc)
			if trueScale != "" {
				desc += "\nScale=" + trueScale
			}
		}
	}
	return fmt.Sprintf(`[Icon Theme]
Name=%s
Comment=%s
Inherits=hicolor
Directories=%s`, t.Name, t.Description, strings.Join(directories, ","))
}
