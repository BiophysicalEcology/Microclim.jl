const increments = (0.0, 0.025, 0.05, 0.1, 0.2, 0.3, 0.5, 1.0) .* m
const layer_size = (0.0125, 0.025, 0.0375, 0.075, 0.1, 0.15, 0.35, 0.75) .* m
const layer_bounds = (0.0125, 0.0375, 0.075, 0.15, 0.25, 0.4, 0.75, 1.5) .* m
const max_height = sum(layer_size)
const layer_prop = layer_size ./ max_height
const water_fraction_to_M = 1.0m^3*m^-3 * 1kg*L^-1 / 18.0g*mol^-1

const microclim_range = (0.01, 1.2) .* m

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
LinearLayerInterpolators(height) =
    LinearLayerInterpolators(range_interpolator(height), increment_interpolator(height), height)


" Calculate current interpolation layers and fraction from NicheMapR data"
increment_interpolator(height) = begin
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

range_interpolator(height) = begin
    lower, upper = microclim_range
    h = min(max(height, lower), upper)
    frac = (h - lower)/(upper - lower)
    LinearLayerInterpolator(2, frac)
end


" Interpolate between two layers of environmental data. "
interp_layer(layers, interp, i) =
    lin_interp(layers, i, interp.layer - 1) * (oneunit(interp.frac) - interp.frac) +
    lin_interp(layers, i, interp.layer) * interp.frac

layermax(layers, interp, i) = begin
    val = layers[1][i]
    for l = 2:interp.layer
        val = max(val, layers[l][i])
    end
    val
end

weightedmean(layers, inpterp::LinearLayerInterpolators, i) = 
    weightedmean(layers, inpterp.height, i)
weightedmean(layers, height::Number, i) = begin
    wmean = zero(layers[1][1])
    h = min(height, max_height)
    # sum all layers < height, after size adjustment
    for l = 1:length(layer_bounds)
        if h < layer_bounds[l]
            # add the last, fractional layer
            frac = 1 - ((layer_bounds[l] - h) / layer_size[l])
            wmean + lin_interp(layers, i, l) * layer_size[l] / h * frac
            break
        end
        # multiply layer value by the fraction of height covered by the layer
        wmean += lin_interp(layers, i, l) * layer_size[l] / h
    end
    wmean
end

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
