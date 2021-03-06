import PyPlot


function plot1D(gp::GP; clim::Tuple{Float64, Float64}=(minimum(gp.x), maximum(gp.x)), CI::Float64=1.96, res::Int=1000)

    sx = (clim[2]-clim[1])/(res-1)
    x=collect(clim[1]:sx:clim[2])
    mu, Sigma = predict(gp, x)
    conf = CI*sqrt(Sigma)
    u = mu + conf
    l = mu - conf
    
    fig = PyPlot.figure("Gaussian Process Regression")
    ax = fig[:add_subplot](1,1,1)
    ax[:set_xlim](xmin=clim[1], xmax=clim[2])
    ax[:set_ylim](ymin=minimum(l), ymax=maximum(u))

    ax[:plot](x,mu,label="Mean function")       #plot the mean function
    ax[:scatter](gp.x,gp.y,marker="o",label="Observations",color="black")  #plot the observations
    ax[:plot](x,l,label="Confidence Region",color="red")            # plot the confidence region
    ax[:plot](x,u,color="red")
    PyPlot.legend(loc = "best", fontsize=15);
end


function plot2D(gp::GP; clim::Tuple{Float64, Float64, Float64, Float64} = (minimum(gp.x[1,:]), maximum(gp.x[1,:]), minimum(gp.x[2,:]), maximum(gp.x[2,:])), res::Int=50)
    
    x = linspace(clim[1], clim[2], res)
    y = linspace(clim[3], clim[4], res)
    xgrid = repmat(x', res, 1 )
    ygrid = repmat(y, 1, res )
    
    mu = predict(gp,[vec(xgrid)';vec(ygrid)'])[1]
    zgrid  = reshape(mu,res,res)

    fig = PyPlot.figure("Contour Plot of Gaussian Process Regression")
    ax = fig[:add_subplot](1,1,1)
    ax[:set_xlim](xmin=clim[1], xmax=clim[2])
    ax[:set_ylim](ymin=clim[3], ymax=clim[4])
    ax[:contour](xgrid,ygrid,zgrid)
    ax[:scatter](gp.x[1,:],gp.x[2,:],marker="o",label="Observations",color="black")  #plot the observations
end

function PyPlot.plot(gp::GP; kwargs...)
    d, n = size(gp.x)
    PyPlot.close()
    if d>2
        error("Only 1D and 2D plots are permitted")
    elseif d==1
        plot1D(gp; kwargs...)
    elseif d==2
        plot2D(gp; kwargs...)
    end
end
