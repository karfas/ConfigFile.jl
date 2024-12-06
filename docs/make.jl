using Documenter
using ConfigFile

makedocs(
    sitename = "ConfigFile.jl",
    format = Documenter.HTML(
        prettyurls = false,
        edit_link = nothing
    ),
    modules = [ConfigFile],
    pages = [
        "Home" => "index.md",
        "API Reference" => "api.md"
    ],
    remotes = nothing,
    warnonly = [:missing_docs]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
