module Microclimate

using Unitful, NCDatasets
using Unitful: W, m, °C, hr, mol, K, s, J, Mg, g, kg, L, kPa, Pa

export AbstractEnvironment, 
       AbstractMicroclimEnvironment,
       AbstractMicroclimGrid, MicroclimGrid, 
       AbstractMicroclimPoint, MicroclimPoint,
       radiation, snowdepth, airtemperature, relhumidity, windspeed,
       soiltemperature, soilwaterpotential, soilwatercontent,
       LinearLayerInterpolator,
       interp_layer,
       interp_increment, interp_range,
       lin_interp,
       weightedmean,
       layermax,
       load_grid,
       load_point


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

MicroclimPoint(radiation, snowdepth, airtemperature, relhumidity, windspeed,
               soiltemperature, soilwaterpotential, soilwatercontent) = begin
    fields = (to_radiation.(radiation),
              (), # to_snowdepth.(snowdepth),
              map(x -> to_airtemperature.(x), airtemperature),
              map(x -> to_relhumidity.(x), relhumidity),
              map(x -> to_windspeed.(x), windspeed),
              map(x -> to_soiltemperature.(x), soiltemperature),
              map(x -> to_soilwaterpotential.(x), soilwaterpotential),
              map(x -> to_soilwatercontent.(x), soilwatercontent))

    MicroclimPoint{typeof.(fields)...}(fields...)
end

MicroclimPoint(radiation, snowdepth, airtemperature, relhumidity, windspeed,
               soiltemperature, soilwaterpotential, soilwatercontent,
               i::CartesianIndex) = begin
    fields = (to_radiation.(radiation[i, :]),
              (), # to_snowdepth.(snowdepth[i, :]),
              map(x -> to_airtemperature.(x[i, :]), airtemperature),
              map(x -> to_relhumidity.(x[i, :]), relhumidity),
              map(x -> to_windspeed.(x[i, :]), windspeed),
              map(x -> to_soiltemperature.(x[i, :]), soiltemperature),
              map(x -> to_soilwaterpotential.(x[i, :]), soilwaterpotential),
              map(x -> to_soilwatercontent.(x[i, :]), soilwatercontent))

    MicroclimPoint{typeof.(fields)...}(fields...)
end

MicroclimPoint(env::AbstractMicroclimGrid, i::CartesianIndex) = begin
    MicroclimPoint(radiation(env), snowdepth(env), airtemperature(env),
                   relhumidity(env), windspeed(env), soiltemperature(env),
                   soilwaterpotential(env), soilwatercontent(env), i)
end

# unit conversions
to_radiation(x) = x * 0.1W*m^-2
to_snowdepth(x) = x * 0.1m
to_airtemperature(x) = x * 0.1 * °C |> K
to_relhumidity(x) = x * 0.001
to_windspeed(x) = x * 0.1m*s^-1
to_soilwaterpotential(x) = x * kPa
to_soiltemperature(x) = x * 0.1 * °C |> K
to_soilwatercontent(x) = x * 0.001


include("interpolation.jl")
include("netcdf.jl")


radiation(env::AbstractMicroclimEnvironment) = env.radiation
radiation(env::AbstractMicroclimPoint, interp, i) = lin_interp(radiation(env), i)

snowdepth(env::AbstractMicroclimEnvironment) = env.snowdepth
snowdepth(env::AbstractMicroclimPoint, interp, i) = lin_interp(snowdepth(env), i)

airtemperature(env::AbstractMicroclimEnvironment) = env.airtemperature
airtemperature(env::AbstractMicroclimPoint, interp, i) = interp_layer(interp, airtemperature(env), i)

relhumidity(env::AbstractMicroclimEnvironment) = env.relhumidity
relhumidity(env::AbstractMicroclimPoint, interp, i) = interp_layer(interp, relhumidity(env), i)

windspeed(env::AbstractMicroclimEnvironment) = env.windspeed
windspeed(env::AbstractMicroclimPoint, interp, i) = interp_layer(interp, windspeed(env), i)

soiltemperature(env::AbstractMicroclimEnvironment) = env.soiltemperature
soiltemperature(env::AbstractMicroclimPoint, interp, i) = interp_layer(interp, soiltemperature(env), i)

soilwaterpotential(env::AbstractMicroclimEnvironment) = env.soilwaterpotential
soilwaterpotential(env::AbstractMicroclimPoint, interp, i) = interp_layer(interp, soilwaterpotential(env), i)

soilwatercontent(env::AbstractMicroclimEnvironment) = env.soilwatercontent
soilwatercontent(env::AbstractMicroclimPoint, interp, i) = interp_layer(interp, soilwatercontent(env), i)

end # module
