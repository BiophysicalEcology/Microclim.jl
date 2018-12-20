module Microclimate

using DataFrames,
      TypedTables, 
      Unitful

import Base: convert

export LayerInterp,
       layer_interp,
       lin_interp,
       MicroclimateTables,
       MicroclimateData

const microclimate_increments = (0.0,2.5,5.0,10.0,15.0,20.0,30.0,50.0,100.0,200.0) .* Unitful.cm

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

struct MicroclimateTables{A,B,C,D,E,F,G,H,I,J,K,L} <: AbstractMicroclimateData
    soil::A
    shadsoil::B
    metout::C
    shadmet::D
    soilmoist::E
    shadmoist::F
    humid::G
    shadhumid::H
    soilpot::I
    shadpot::J
    plant::K
    shadplant::L
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
LayerInterp(height) = begin
    for (i, upper) in enumerate(microclimate_increments)
        if upper > height
            lower = microclimate_increments[i - 1]
            p = (height-lower)/(upper-lower)
            return LayerInterp(i + 1, i + 2, p, 1.0 - p)
        end
    end
    # Otherwise its taller/deeper than we have data, use the largest we have.
    max = length(microclimate_increments) + 2
    LayerInterp(max, max, 1.0, 0.0)
end

" Interpolate between two layers of environmental data. "
layer_interp(interp, table, pos) = begin
    table[pos][interp.lower] * interp.lowerfrac +
    table[pos][interp.upper] * interp.upperfrac
end

# lin_interp(array::AbstractArray, pos) = begin
#     int = floor(Int64, pos)
#     frac::Float64 = pos - int
#     array[int]::Float64 * (1 - frac) + array[int + 1]::Float64 * frac
# end
# lin_interp(array, pos::Int) = array[pos]
" Linear interpolation "
@inline lin_interp(column, pos) = begin
    int = floor(Int64, pos)
    frac::Float64 = pos - int
    column[int+1] * (1 - frac) + column[int] * frac
end
@inline lin_interp(column, pos::Int) = column[pos]

Base.convert(::Type{MicroclimateTables}, x) =
    MicroclimateTables(
      Table(x.soil),
      Table(x.shadsoil),
      Table(x.metout),
      Table(x.shadmet),
      Table(x.soilmoist),
      Table(x.shadmoist),
      Table(x.humid),
      Table(x.shadhumid),
      Table(x.soilpot),
      Table(x.shadpot),
      Table(x.plant),
      Table(x.shadplant),
      x.RAINFALL,
      x.dim,
      x.ALTT,
      x.REFL,
      x.MAXSHADES,
      x.longlat,
      x.nyears,
      x.timeinterval,
      x.minshade,
      x.maxshade,
      x.DEP
    )

end # module
