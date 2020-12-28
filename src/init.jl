using Pkg.Artifacts

function __init__()
    prana_path = artifact"Prana"
    if !isCI
        cd(prana_path) do
            mat"addpath($(prana_path))"
            mat"prana"
        end
    end
end
