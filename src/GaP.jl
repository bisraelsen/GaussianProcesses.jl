module GaP
using Optim

VERSION < v"0.4-" && using Docile

@document

# Functions that should be available to package
# users should be explicitly exported here

export GP, predict, SumKernel, ProdKernel, SE, SEIso, SEArd, Periodic, Poly, RQ, RQIso, RQArd, Lin, LinIso, LinArd, Mat, Mat12Is0, Mat12Ard, Mat32Iso, Mat32Ard, Mat52Iso, Mat52Ard, MeanZero, MeanConst, MeanLin, MeanPoly, SumMean, ProdMean, optimize!

# all package code should be included here
include("means/meanFunctions.jl")
include("kernels/kernels.jl")
include("utils.jl")
include("GP.jl")
include("optimize.jl")

# This approach to loading supported plotting packages is taken directly from the "KernelDensity" package
macro glue(pkg)
    path = joinpath(dirname(@__FILE__),"glue",string(pkg,".jl"))
    init = symbol(string(pkg,"_init"))
    quote
        $(esc(init))() = Base.include($path)
        isdefined(Main,$(QuoteNode(pkg))) && $(esc(init))()
    end
end

@glue Gadfly
@glue Winston

end # module
