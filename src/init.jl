using Pkg.Artifacts

function __init__()
    prana_path = joinpath(artifact"Prana", "prana-2.8.0.beta.r2021.01.19")
    if !isCI
        cd(prana_path) do
            mat"addpath($(prana_path))"
        end
    end
end
