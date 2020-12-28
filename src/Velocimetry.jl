module Velocimetry

export prana

# Check whether we're running in a CI environment (can't use MATLAB)
const isCI = parse(Bool, lowercase(get(ENV, "CI", "false")))

if !isCI
    try
        using MATLAB
    catch e
        errstr = """Unable to initialize the MATLAB engine. 
                    Check that the MATLAB binary is included in your PATH."""
        @error errstr exception=e
    end
else
    @eval Velocimetry, macro mat_str(expr) end
end

include("init.jl")

"""
    prana()

Launches the MATLAB-based prana interface. Requires a 
working MATLAB installation and successful initialization 
of the MATLAB.jl Julia-MATLAB interface package.
"""
prana() = mat"prana"

end
