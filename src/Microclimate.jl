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
abstract type AbstractMicroclimEnvironment <: AbstractEnvironment end
abstract type AbstractMicroclimGrid <: AbstractMicroclimEnvironment end
abstract type AbstractMicroclimPoint <: AbstractMicroclimEnvironment end

struct MicroclimGrid{R,S,AT,RH,V,ST,WP,WC} <: AbstractMicroclimGrid
    radiation::R
    snowdepth::S
    airtemperature::AT
    relhumidity::RH
    windspeed::V
    soiltemperature::ST
    soilwaterpotential::WP
    soilwatercontent::WC
end

struct MicroclimPoint{R,S,AT,RH,V,ST,WP,WC} <: AbstractMicroclimPoint
    radiation::R
    snowdepth::S
    airtemperature::AT
    relhumidity::RH
    windspeed::V
    soiltemperature::ST
    soilwaterpotential::WP
    soilwatercontent::WC
end

abstract type AbstractMicroclimInstant <: AbstractMicroclimPoint end

struct MicroclimInstant{M,I,T} <: AbstractMicroclimInstant
    microclimate::M
    interp::I
    t::T
end
MicroclimInstant(microclim, height::Number, t) = MicroclimInstant(microclim, LinearLayerInterpolators(height), t)

MicroclimPoint(radiation::Vector{<:AbstractFloat}, snowdepth, airtemperature, relhumidity, windspeed,
               soiltemperature, soilwaterpotential, soilwatercontent) = begin
    fields = (to_radiation.(radiation),
              to_snowdepth.(snowdepth),
              [to_airtemperature(x[i]) for i in 1:length(airtemperature[1]), x in airtemperature],
              [to_relhumidity(x[i]) for i in 1:length(relhumidity[1]), x in relhumidity],
              [to_windspeed(x[i]) for i in 1:length(windspeed[1]), x in windspeed],
              [to_soiltemperature(x[i]) for i in 1:length(soiltemperature[1]), x in soiltemperature],
              [to_soilwaterpotential(x[i]) for i in 1:length(soilwaterpotential[1]), x in soilwaterpotential],
              [to_soilwatercontent(x[i]) for i in 1:length(soilwatercontent[1]), x in soilwatercontent])
    MicroclimPoint(fields...)
end

MicroclimPoint(radiation, snowdepth, airtemperature, relhumidity, windspeed,
               soiltemperature, soilwaterpotential, soilwatercontent,
               ind::CartesianIndex) = begin
    fields = (to_radiation.(radiation[ind, :]),
              to_snowdepth.(snowdepth[ind, :]),
              [to_airtemperature(x[ind, i]) for i in 1:length(airtemperature[1]), x in airtemperature],
              [to_relhumidity(x[ind, i]) for i in 1:length(relhumidity[1]), x in relhumidity],
              [to_windspeed(x[ind, i]) for i in 1:length(windspeed[1]), x in windspeed],
              [to_soiltemperature(x[ind, i]) for i in 1:length(soiltemperature[1]), x in soiltemperature],
              [to_soilwaterpotential(x[ind, i]) for i in 1:length(soilwaterpotential[1]), x in soilwaterpotential],
              [to_soilwatercontent(x[ind, i]) for i in 1:length(soilwatercontent[1]), x in soilwatercontent])
    MicroclimPoint(fields...)
end

MicroclimPoint(env::AbstractMicroclimGrid, i::CartesianIndex) =
    MicroclimPoint(radiation(env), snowdepth(env), airtemperature(env),
                   relhumidity(env), windspeed(env), soiltemperature(env),
                   soilwaterpotential(env), soilwatercontent(env), i)

struct MicroclimateLayers{L<:Tuple} 
    layers::L
end

# unit conversions
to_radiation(x) = x * 0.1W*m^-2
to_snowdepth(x) = x * 0.1m
to_airtemperature(x) = x * 0.1 * °C |> K
to_relhumidity(x) = x * 0.001
to_windspeed(x) = x * 0.1m*s^-1
to_soiltemperature(x) = x * 0.1 * °C |> K
to_soilwaterpotential(x) = x * 0.1kPa
to_soilwatercontent(x) = x * 0.001


include("interpolation.jl")
include("netcdf.jl")

# Accessors for single layer data
for name in (:radiation, :snowdepth)
    eval(quote
        $name(env::AbstractEnvironment) = env.$name
        $name(env::AbstractMicroclimPoint, interp, i) = lin_interp($name(env), i)
        $name(env::AbstractMicroclimPoint, i) = lin_interp($name(env.microclimate), i)
        $name(env::AbstractMicroclimInstant) = lin_interp($name(env.microclimate), env.t)
    end)
end

# Accessor functions for 2 and 8 layer data
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
            weightedmean($name(env), x, i)
        $(Symbol(:mean_, name))(env::AbstractMicroclimInstant) =
            weightedmean($name(env.microclimate), env.interp, env.t)
        $(Symbol(:mean_, name))(env::AbstractMicroclimInstant, i::Number) =
            weightedmean($name(env.microclimate), env.interp, i)
        $(Symbol(:mean_, name))(env::AbstractMicroclimInstant, interp::AbstractLayerInterpolator) =
            weightedmean($name(env.microclimate), interp, env.t)
    end)
end


end # module
