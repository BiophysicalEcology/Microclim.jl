module Microclimate

using Unitful, NCDatasets
using Unitful: W, m, °C, hr, mol, K, s, J, Mg, g, kg, L, kPa, Pa

export AbstractEnvironment,
       AbstractMicroclimEnvironment,
       AbstractMicroclimGrid, MicroclimGrid,
       AbstractMicroclimPoint, MicroclimPoint,
       AbstractMicroclimInstant, MicroclimInstant,
       LinearLayerInterpolator, LinearLayerInterpolators

export radiation, snowdepth, airtemperature, relhumidity, windspeed,
       soiltemperature, soilwaterpotential, soilwatercontent

export mean_soiltemperature, mean_soilwaterpotential, mean_soilwatercontent

export weightedmean, layermax

export load_grid, load_point

radiation_type = typeof(0.1W*m^-2)
snowdepth_type = typeof(0.1m)
airtemperature_type = typeof(0.1K)
relhumidity_type = typeof(0.001)
windspeed_type = typeof(0.1m*s^-1)
soiltemperature_type = typeof(0.1K)
soilwaterpotential_type = typeof(0.0kPa)
soilwatercontent_type = typeof(0.001)

abstract type AbstractEnvironment end
abstract type AbstractMicroclimEnvironment{S,I,A,R} <: AbstractEnvironment end
abstract type AbstractMicroclimGrid{S,I,A,R} <: AbstractMicroclimEnvironment{S,I,A,R} end
abstract type AbstractMicroclimPoint{S,I,A,R} <: AbstractMicroclimEnvironment{S,I,A,R} end

struct MicroclimGrid{S,I,A,R,RA,SN,AT,RH,WS,ST,WP,WC} <: AbstractMicroclimGrid{S,I,A,R}
    radiation::RA
    snowdepth::SN
    airtemperature::AT
    relhumidity::RH
    windspeed::WS
    soiltemperature::ST
    soilwaterpotential::WP
    soilwatercontent::WC

    MicroclimGrid{S,I,A,R}(radiation::RA, snowdepth::SN, airtemperature::AT, relhumidity::RH,
                            windspeed::WS, soiltemperature::ST, soilwaterpotential::WP,
                            soilwatercontent::WC) where {S,I,A,R,RA,SN,AT,RH,WS,ST,WP,WC} =
        new{S,I,A,R,RA,SN,AT,RH,WS,ST,WP,WC}(radiation, snowdepth, airtemperature,
            relhumidity, windspeed, soiltemperature, soilwaterpotential, soilwatercontent)

    MicroclimGrid{S,I,A,R,RA,SN,AT,RH,WS,ST,WP,WC}(radiation::RA, snowdepth::SN, airtemperature::AT, relhumidity::RH,
                            windspeed::WS, soiltemperature::ST, soilwaterpotential::WP,
                            soilwatercontent::WC) where {S,I,A,R,RA,SN,AT,RH,WS,ST,WP,WC} =
        new{S,I,A,R,RA,SN,AT,RH,WS,ST,WP,WC}(radiation, snowdepth, airtemperature,
            relhumidity, windspeed, soiltemperature, soilwaterpotential, soilwatercontent)
end

struct MicroclimPoint{S,I,A,R,RA,SN,AT,RH,WS,ST,WP,WC} <: AbstractMicroclimPoint{S,I,A,R}
    radiation::RA
    snowdepth::SN
    airtemperature::AT
    relhumidity::RH
    windspeed::WS
    soiltemperature::ST
    soilwaterpotential::WP
    soilwatercontent::WC

    MicroclimPoint{S,I,A,R}(radiation::RA, snowdepth::SN, airtemperature::AT, relhumidity::RH,
                            windspeed::WS, soiltemperature::ST, soilwaterpotential::WP,
                            soilwatercontent::WC) where {S,I,A,R,RA,SN,AT,RH,WS,ST,WP,WC} =
        new{S,I,A,R,RA,SN,AT,RH,WS,ST,WP,WC}(radiation, snowdepth, airtemperature,
            relhumidity, windspeed, soiltemperature, soilwaterpotential, soilwatercontent)

    MicroclimPoint{S,I,A,R,RA,SN,AT,RH,WS,ST,WP,WC}(radiation::RA, snowdepth::SN, airtemperature::AT, relhumidity::RH,
                            windspeed::WS, soiltemperature::ST, soilwaterpotential::WP,
                            soilwatercontent::WC) where {S,I,A,R,RA,SN,AT,RH,WS,ST,WP,WC} =
        new{S,I,A,R,RA,SN,AT,RH,WS,ST,WP,WC}(radiation, snowdepth, airtemperature,
            relhumidity, windspeed, soiltemperature, soilwaterpotential, soilwatercontent)
end

abstract type AbstractMicroclimInstant end

struct MicroclimInstant{M,I,T} <: AbstractMicroclimInstant
    microclimate::M
    interp::I
    t::T
end
MicroclimInstant(microclim, height::Number, t) = MicroclimInstant(microclim, LinearLayerInterpolators(microclim, height), t)

# From external data without units
MicroclimPoint{S,I,A,R}(radiation::Vector{<:AbstractFloat}, snowdepth::Vector{<:AbstractFloat}, 
                      airtemperature::Array{<:AbstractFloat}, relhumidity::Array{<:AbstractFloat}, 
                      windspeed::Array{<:AbstractFloat}, soiltemperature::Array{<:AbstractFloat}, 
                      soilwaterpotential::Array{<:AbstractFloat}, soilwatercontent::Array{<:AbstractFloat}
                     ) where {S,I,A,R} = begin

    rad = to_radiation.(radiation)
    snow = to_snowdepth.(snowdepth)
    airt = to_airtemperature.(airtemperature)
    relh = to_relhumidity.(relhumidity)
    wind = to_windspeed.(windspeed)
    soilt = to_soiltemperature.(soiltemperature)
    soilwp = to_soilwaterpotential.(soilwaterpotential)
    soilwc = to_soilwatercontent.(soilwatercontent)

    args = (rad, snow, airt, relh, wind, soilt, soilwp, soilwc)
    MicroclimPoint{I,A,R,typeof.(args)...}(args...)
end

# From microclim dataset in tuples and a cartesian index
# Requires conversion to float from Int
MicroclimPoint{S,I,A,R}(radiation::Vector, snowdepth::Vector, airtemperature::Tuple, 
                        relhumidity::Tuple, windspeed::Tuple, soiltemperature::Tuple, 
                        soilwaterpotential::Tuple, soilwatercontent::Tuple, i::CartesianIndex) where {S,I,A,R} = begin
    rad = to_radiation.(catpoint(radiation, i) .* 0.1)
    snow = to_snowdepth.(catpoint(snowdepth, i) .* 0.001)
    airt = to_airtemperature.(catpoint(airtemperature, i) .* 0.1)
    relh = to_relhumidity.(catpoint(relhumidity, i) .* 0.001)
    wind = to_windspeed.(catpoint(windspeed, i) .* 0.1)
    soilt = to_soiltemperature.(catpoint(soiltemperature, i) .* 0.1)
    soilwp = to_soilwaterpotential.(catpoint(soilwaterpotential, i) .* 0.1)
    soilwc = to_soilwatercontent.(catpoint(soilwatercontent, i) .* 0.001)

    args = (rad, snow, airt, relh, wind, soilt, soilwp, soilwc)
    MicroclimPoint{S,I,A,R,typeof.(args)...}(args...)
end

# From MiriclimGrid and a cartesian index
MicroclimPoint(env::AbstractMicroclimGrid{S,I,A,R}, i::CartesianIndex) where {S,I,A,R} =
    MicroclimPoint{S,I,A,R}(radiation(env), snowdepth(env), airtemperature(env),
                   relhumidity(env), windspeed(env), soiltemperature(env),
                   soilwaterpotential(env), soilwatercontent(env), i)

struct MicroclimateLayers{L<:Tuple}
    layers::L
end


include("interpolation.jl")
include("netcdf.jl")


# unit conversions
to_radiation(x) = x * W*m^-2
to_snowdepth(x) = x * m
to_airtemperature(x) = x * °C |> K
to_relhumidity(x) = x
to_windspeed(x) = x * m*s^-1
to_soiltemperature(x) = x * °C |> K
to_soilwaterpotential(x) = x * kPa
to_soilwatercontent(x) = x

# Get layer specifications from type system
get_shade(layers::AbstractMicroclimEnvironment{S,I,A,R}) where {S,I,A,R} = S
get_increments(layers::AbstractMicroclimEnvironment{S,I,A,R}) where {S,I,A,R} = I
get_nextlayer(layers::AbstractMicroclimEnvironment{S,I,A,R}) where {S,I,A,R} = A
get_range(layers::AbstractMicroclimEnvironment{S,I,A,R}) where {S,I,A,R} = R

@inline catpoint(layers::Tuple{}, i::CartesianIndex) = Float64[]
@inline catpoint(layers::Tuple, i::CartesianIndex) =
    cat([[cat((getindex(y, i, :) for y in l)..., dims=1)...] for l in layers]..., dims=2)
@inline catpoint(layers::Vector, i::CartesianIndex) = cat((getindex(y, i, :) for y in layers)..., dims=1)


# Accessors for single layer data
for name in (:radiation, :snowdepth)
    eval(quote
        $name(env::AbstractEnvironment) = env.$name
        $name(env::AbstractMicroclimPoint, interp, i) = lin_interp($name(env), i)
        $name(env::AbstractMicroclimPoint, i) = lin_interp($name(env.microclimate), i)
        $name(env::AbstractMicroclimInstant) = lin_interp($name(env.microclimate), env.t)
    end)
end

# Accessor functions for range and increment data
for (name, mode) in ((:airtemperature, :range), (:relhumidity, :range), (:windspeed, :range),
                     (:soiltemperature, :increment), (:soilwaterpotential, :increment),
                     (:soilwatercontent, :increment))
    eval(quote
        $name(env::AbstractMicroclimEnvironment) = env.$name
        $name(env::AbstractMicroclimPoint, interp::LinearLayerInterpolators, i) =
            $name(env::AbstractMicroclimPoint, interp.$mode, i)
        $name(env::AbstractMicroclimPoint, interp::LinearLayerInterpolator, i) =
            interp_layer($name(env), interp, i)
        $name(env::AbstractMicroclimPoint, height::Number, i) =
            $name(env, $(Symbol(mode, :_interpolator))(height), i)
        $name(env::AbstractMicroclimInstant) =
            $name(env.microclimate, env.interp, env.t)
        $name(env::AbstractMicroclimInstant, i::Number) =
            $name(env.microclimate, env.interp, i)
        $name(env::AbstractMicroclimInstant, interp::AbstractLayerInterpolator) =
            $name(env.microclimate, interp, env.t)
    end)
end

# Accessors for weighted mean of 8 layer data
for name in (:soiltemperature, :soilwatercontent, :soilwaterpotential)
    eval(quote
        $(Symbol(:mean_, name))(env::AbstractMicroclimPoint, x, i) =
            weightedmean(env, $name(env), x, i)
        $(Symbol(:mean_, name))(env::AbstractMicroclimInstant) =
            weightedmean(env, $name(env.microclimate), env.interp, env.t)
        $(Symbol(:mean_, name))(env::AbstractMicroclimInstant, i::Number) =
            weightedmean(env, $name(env.microclimate), env.interp, i)
        $(Symbol(:mean_, name))(env::AbstractMicroclimInstant, interp::AbstractLayerInterpolator) =
            weightedmean(env, $name(env.microclimate), interp, env.t)
    end)
end


end # module
