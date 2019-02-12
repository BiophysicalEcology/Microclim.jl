const water_fraction_to_M = 1.0m^3*m^-3 * 1kg*L^-1 / 18.0g*mol^-1


abstract type AbstractLayerInterpolator end

struct LinearLayerInterpolator <: AbstractLayerInterpolator
    layer::Int
    frac::Float64
end

struct LinearLayerInterpolators{H} <: AbstractLayerInterpolator
    range::LinearLayerInterpolator
    increment::LinearLayerInterpolator
    height::H
end
LinearLayerInterpolators(env, height) =
    LinearLayerInterpolators(range_interpolator(env, height), increment_interpolator(env, height), height)


layer_sizes(env) = begin
    increments = get_increments(env)
    next = get_nextlayer(env)
    inc1 = (0.0m, increments..., next)
    tuple(collect((inc1[i+1] + inc1[i])/2 - (inc1[i-1] + inc1[i])/2 for i in 2:length(increments)+1)...)
end

layer_bounds(env) = begin
    increments = get_increments(env)
    next = get_nextlayer(env)
    inc1 = (increments..., next)
    tuple(collect((inc1[i+1] + inc1[i])/2 for i in 1:length(increments))...)
end
max_height(env) = sum(layer_sizes(env))
layer_props(env) = layer_sizes(env) ./ max_height(env)


" Calculate current interpolation layers and fraction from NicheMapR data"
increment_interpolator(env, height) = begin
    increments = get_increments(env)
    for (i, upper_height) in enumerate(increments)
        if upper_height > height
            lower_height = increments[i - 1]
            frac = (height - lower_height)/(upper_height - lower_height)
            return LinearLayerInterpolator(i, frac)
        end
    end
    # Otherwise it's taller/deeper than we have data, so use the largest we have.
    LinearLayerInterpolator(lastindex(increments), 1.0)
end

range_interpolator(env, height) = begin
    lower, upper = get_range(env)
    h = min(max(height, lower), upper)
    frac = (h - lower)/(upper - lower)
    LinearLayerInterpolator(2, frac)
end


" Interpolate between two layers of environmental data. "
interp_layer(layers, interp, i) =
    lin_interp(layers, i, interp.layer - 1) * (oneunit(interp.frac) - interp.frac) +
    lin_interp(layers, i, interp.layer) * interp.frac


" Linear interpolation "
@inline lin_interp(vector::Vector, i) = begin
    int = floor(Int64, i)
    frac::Float64 = i - int
    vector[int+1] * (1 - frac) + vector[int] * frac
end
@inline lin_interp(matrix::Matrix, i, j) = begin
    int = floor(Int64, i)
    frac::Float64 = i - int
    matrix[int+1, j] * (1 - frac) + matrix[int, j] * frac
end
@inline lin_interp(vector::Vector, i::Int) = vector[i]
@inline lin_interp(matrix::Matrix, i::Int, j) = matrix[i, j]


weightedmean(env, layers, inpterp::LinearLayerInterpolators, i) = 
    weightedmean(env, layers, inpterp.height, i)
weightedmean(env, layers, height::Number, i) = begin
    wmean = zero(layers[1][1])m
    lbounds = layer_bounds(env)
    lsizes = layer_sizes(env)
    h = min(height, max_height(env))
    # sum all layers < height, after size adjustment
    for l = 1:length(lbounds)
        if h > lbounds[l]
            # add the whole layer 
            wmean += lin_interp(layers, i, l) * lsizes[l]
        else
            # add the last fractional layer and break the loop
            frac = 1 - ((lbounds[l] - h) / lsizes[l])
            wmean += lin_interp(layers, i, l) * lsizes[l] * frac
            break
        end
    end
    wmean / h
end

layermax(layers, interp, i) = begin
    val = layers[1][i]
    for l = 2:interp.layer
        val = max(val, layers[l][i])
    end
    val
end
