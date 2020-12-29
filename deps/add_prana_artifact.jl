# Download Prana artifact
using ArtifactUtils, Pkg.Artifacts
add_artifact!(
    "../Artifacts.toml",
    "Prana",
    "https://github.com/stillyslalom/prana/archive/v0.1.0.tar.gz",
    # lazy=true, # need to use LazyArtifacts for this
    force=true,
    clear=false,
)