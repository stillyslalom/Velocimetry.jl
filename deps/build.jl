# Download Prana artifact
using ArtifactUtils, Pkg.Artifacts
add_artifact!(
    "../Artifacts.toml",
    "Prana",
    "https://github.com/stillyslalom/prana/archive/v0.1.0.tar.gz",
    lazy=true,
    force=true,
)

# Set up MATLAB COM server if not in CI environment
if !parse(Bool, lowercase(get(ENV, "CI", "false")))
    Sys.iswindows() && run(`matlabCOM.bat`)
end
