using Velocimetry
using Documenter

makedocs(;
    modules=[Velocimetry],
    authors="Alex Ames <alexander.m.ames@gmail.com> and contributors",
    repo="https://github.com/stillyslalom/Velocimetry.jl/blob/{commit}{path}#L{line}",
    sitename="Velocimetry.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://stillyslalom.github.io/Velocimetry.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/stillyslalom/Velocimetry.jl",
    devbranch="main"
)
