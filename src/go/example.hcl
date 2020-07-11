theme "breeze" {
    name = "Breeze"
    description = "Breeze by the KDE VDG"

    variant "light" {
        type = "scalable"

        preprocess "optimize" {}

        directory "actions" {
            context = "actions"
            sizes = [ "12", "16", "16@2x", "22", "22@2x", "24", "24@2x", "32", "32@2x", "64", "symbolic" ]

            preprocess "stylesheet-breeze-light" {}
        }
        directory "animations" {
            context = "animations"
            sizes = [ "16", "16@2x", "22" ]

            preprocess "stylesheet-breeze-light" {}
        }
        directory "applications" {
            context = "applications"
            sizes = [ "16", "16@2x", "22", "22@2x", "32", "48" ]
        }
        directory "applets" {
            context = "applets"
            sizes = [ "22", "48", "64", "128", "256" ]
        }
        directory "categories" {
            context = "categories"
            sizes = [ "32" ]
        }
        directory "devices" {
            context = "devices"
            sizes = [ "16", "16@2x", "22", "22@2x", "64", "symbolic" ]
        }
        directory "emblems" {
            context = "emblems"
            sizes = [ "8", "16", "16@2x", "22", "22@2x", "symbolic" ]

            type = "fixed"
        }
        directory "emoticons" {
            context = "emoticons"
            sizes = [ "22", "22@2x" ]

            type = "fixed"
        }
        directory "mimetypes" {
            context = "mimetypes"
            sizes = [ "16", "16@2x", "22", "22@2x", "32", "64" ]
        }
        directory "places" {
            context = "places"
            sizes = [ "16", "16@2x", "22", "22@2x", "32", "64", "symbolic" ]
        }
        directory "status" {
            context = "status"
            sizes = [ "16", "16@2x", "22", "22@2x", "24", "32", "64", "symbolic" ]
        }
    }
    variant "dark" {
        name = "Breeze Dark"
        type = "scalable"

        inherit "light" {
            preprocess "convert-breeze-light-to-breeze-dark" {}
        }
    }
}