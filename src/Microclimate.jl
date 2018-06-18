module Microclimate

using DataFrames
using Unitful


const microclimate_increments = (0.0,2.5,5.0,10.0,15.0,20.0,30.0,50.0,100.0,200.0) .* u"cm"

export niche_setup, 
       niche_interpolate, 
       lin_interpolate, 
       MicroclimateData, 

abstract type AbstractMicroclimateData end

struct MicroclimateData <: AbstractMicroclimateData
  soil::DataFrame
  shadsoil::DataFrame
  metout::DataFrame
  shadmet::DataFrame
  soilmoist::DataFrame
  shadmoist::DataFrame
  humid::DataFrame
  shadhumid::DataFrame
  soilpot::DataFrame
  shadpot::DataFrame
  plant::DataFrame
  shadplant::DataFrame
  RAINFALL::Vector{Float64}
  dim::Int
  ALTT::Float64
  REFL::Float64
  MAXSHADES::Vector{Float64}
  longlat::Vector{Float64}
  nyears::Int
  timeinterval::Int
  minshade::Float64
  maxshade::Float64
  DEP::Vector{Float64}
end

struct LayerInterp
    lower::Int
    upper::Int
    lowerfrac::Float64
    upperfrac::Float64
end


" Calculate current interpolation layers and fraction from NicheMapR data"
layer_setup(height) = begin
    for (i, upper) in enumerate(nichemap_increments)
        if upper > height
            lower = microclimate_increments[i - 1]
            p = (height-lower)/(upper-lower)
            return LayerInterp(i + 1, i + 2, p, 1.0 - p)
        end
    end
    # Otherwise its taller/deeper than we have data, use the largest we have.
    max = length(microclimate_increments) + 2
    return LayerInterp(max, max, 1.0, 0.0)
end

" Interpolate between two layers of environmental data. "
layer_interp(i, data, pos) = begin
    lin_interp(data[i.lower], pos) * i.lowerfrac +
    lin_interp(data[i.upper], pos) * i.upperfrac
end

" Linear interpolation "
lin_interp(array, pos::Number) = begin
    int = floor(Int64, pos)
    frac::Float64 = pos - int
    array[int] * (1 - frac) + array[int + 1] * frac
end
lin_interp(array, pos::Int) = array[pos]

end # module
