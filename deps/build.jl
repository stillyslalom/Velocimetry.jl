# Set up MATLAB COM server if not in CI environment
if !parse(Bool, lowercase(get(ENV, "CI", "false")))
    Sys.iswindows() && run(`matlabCOM.bat`)
end
