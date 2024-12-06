using Documenter
using ConfigFile

makedocs(
    sitename = "ConfigFile.jl",
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", "false") == "true",
        canonical = "https://karfas.github.io/ConfigFile.jl",
        edit_link = "main"
    ),
    modules = [ConfigFile],
    pages = [
        "Home" => "index.md",
        "API Reference" => "api.md"
    ]
)

deploydocs(
    repo = "github.com/karfas/ConfigFile.jl.git",
    devbranch = "main",
    push_preview = true
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
