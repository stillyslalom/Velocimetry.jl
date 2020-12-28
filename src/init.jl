using Pkg.Artifacts

function __init__()
    prana_path = joinpath(artifact"Prana", "prana-0.1.0")
    if !isCI
        cd(prana_path) do
            mat"addpath($(prana_path))"
            mat"prana"
        end
    else
        macro mat_str end
    end
end
