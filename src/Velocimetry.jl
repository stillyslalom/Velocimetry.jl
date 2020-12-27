module Velocimetry

try
    using MATLAB
catch e
    errstr = """Unable to initialize the MATLAB engine. 
                Check that the MATLAB binary is included in your PATH."""
    @error errstr exception=e
end

include("init.jl")
# __init__()

function main()
    return nothing
end

end
