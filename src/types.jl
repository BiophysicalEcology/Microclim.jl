radiation_type = typeof(0.1W*m^-2)
snowdepth_type = typeof(0.1m)
airtemperature_type = typeof(0.1K)
relhumidity_type = typeof(0.001)
windspeed_type = typeof(0.1m*s^-1)
soiltemperature_type = typeof(0.1K)
soilwaterpotential_type = typeof(0.0kPa)
soilwatercontent_type = typeof(0.001)

abstract type AbstractMicroclimate end
abstract type AbstractLayeredMicroclimate{S,I,A,R} <: AbstractMicroclimate end
abstract type AbstractMicroclimControl <: AbstractMicroclimate end
abstract type AbstractMicroclimGrid{S,I,A,R} <: AbstractLayeredMicroclimate{S,I,A,R} end
abstract type AbstractMicroclimPoint{S,I,A,R} <: AbstractLayeredMicroclimate{S,I,A,R} end


@udefault_kw @units @limits struct MicroclimControl{RA,SN,AT,RH,WS,ST,WP,WC} <: AbstractMicroclimControl
    radiation::RA          | 200.0  | W*m^-2 | (500.0, 1200.0)
    snowdepth::SN          | 0.0    | m      | (0.0, 10.0)
    airtemperature::AT     | 290.0  | K      | (260.0, 370.0)
    relhumidity::RH        | 0.7    | _      | (0.0, 1.0)
    windspeed::WS          | 0.1    | m*s^-1 | (0.0, 20.0)
    soiltemperature::ST    | 290.0  | K      | (260.0, 370.0)
    soilwaterpotential::WP | -100.0 | kPa    | (-0.0, -10000.0)
    soilwatercontent::WC   | 0.3    | _      | (0.0, 1.0)
end


struct MicroclimGrid{S,I,A,R,RA,SN,AT,RH,WS,ST,WP,WC} <: AbstractMicroclimGrid{S,I,A,R}
    radiation::RA
    snowdepth::SN
    airtemperature::AT
    relhumidity::RH
    windspeed::WS
    soiltemperature::ST
    soilwaterpotential::WP
    soilwatercontent::WC
end

MicroclimGrid{S,I,A,R}(radiation::RA, snowdepth::SN, airtemperature::AT, relhumidity::RH,
                        windspeed::WS, soiltemperature::ST, soilwaterpotential::WP,
                        soilwatercontent::WC) where {S,I,A,R,RA,SN,AT,RH,WS,ST,WP,WC} =
    MicroclimGrid{S,I,A,R,RA,SN,AT,RH,WS,ST,WP,WC}(radiation, snowdepth, airtemperature,
        relhumidity, windspeed, soiltemperature, soilwaterpotential, soilwatercontent)


struct MicroclimPoint{S,I,A,R,RA,SN,AT,RH,WS,ST,WP,WC} <: AbstractMicroclimPoint{S,I,A,R}
    radiation::RA
    snowdepth::SN
    airtemperature::AT
    relhumidity::RH
    windspeed::WS
    soiltemperature::ST
    soilwaterpotential::WP
    soilwatercontent::WC
end

MicroclimPoint{S,I,A,R}(radiation::RA, snowdepth::SN, airtemperature::AT, relhumidity::RH,
                        windspeed::WS, soiltemperature::ST, soilwaterpotential::WP,
                        soilwatercontent::WC) where {S,I,A,R,RA,SN,AT,RH,WS,ST,WP,WC} =
    MicroclimPoint{S,I,A,R,RA,SN,AT,RH,WS,ST,WP,WC}(radiation, snowdepth, airtemperature,
        relhumidity, windspeed, soiltemperature, soilwaterpotential, soilwatercontent)

# From external data without units
MicroclimPoint{S,I,A,R}(radiation::Vector{<:AbstractFloat}, snowdepth::Vector{<:AbstractFloat},
                      airtemperature::Matrix{<:AbstractFloat}, relhumidity::Matrix{<:AbstractFloat},
                      windspeed::Matrix{<:AbstractFloat}, soiltemperature::Matrix{<:AbstractFloat},
                      soilwaterpotential::Matrix{<:AbstractFloat}, soilwatercontent::Matrix{<:AbstractFloat}
                     ) where {S,I,A,R} = begin
    rad = missing_otherwise(to_radiation, radiation)
    snow = missing_otherwise(to_snowdepth, snowdepth)
    airt = missing_otherwise(to_airtemperature, airtemperature)
    relh = missing_otherwise(to_relhumidity, relhumidity)
    wind = missing_otherwise(to_windspeed, windspeed)
    soilt = missing_otherwise(to_soiltemperature, soiltemperature)
    soilwp = missing_otherwise(to_soilwaterpotential, soilwaterpotential)
    soilwc = missing_otherwise(to_soilwatercontent, soilwatercontent)

    args = (rad, snow, airt, relh, wind, soilt, soilwp, soilwc)
    if any(ismissing.(args))
        missing
    else
        MicroclimPoint{S,I,A,R,typeof.(args)...}(args...)
    end
end

# From microclim dataset in tuples and a cartesian index
# Requires conversion to float from Int
MicroclimPoint{S,I,A,R}(radiation::Vector, snowdepth::Vector, airtemperature::Tuple,
                        relhumidity::Tuple, windspeed::Tuple, soiltemperature::Tuple,
                        soilwaterpotential::Tuple, soilwatercontent::Tuple, i::CartesianIndex) where {S,I,A,R} = begin
    rad = missing_otherwise_cat(x -> to_radiation(0.1x), radiation, i)
    snow = missing_otherwise_cat(x -> to_snowdepth(0.001x), snowdepth, i)
    airt = missing_otherwise_cat(x -> to_airtemperature(0.1x), airtemperature, i)
    relh = missing_otherwise_cat(x -> to_relhumidity(0.001x), relhumidity, i)
    wind = missing_otherwise_cat(x -> to_windspeed(0.1x), windspeed, i)
    soilt = missing_otherwise_cat(x -> to_soiltemperature(0.1x), soiltemperature, i)
    soilwp = missing_otherwise_cat(x -> to_soilwaterpotential(0.1x), soilwaterpotential, i)
    soilwc = missing_otherwise_cat(x -> to_soilwatercontent(0.001x), soilwatercontent, i)

    args = (rad, snow, airt, relh, wind, soilt, soilwp, soilwc)
    if any(ismissing.(args))
        missing
    else
        MicroclimPoint{S,I,A,R,typeof.(args)...}(args...)
    end
end

# From MiriclimGrid and a cartesian index
MicroclimPoint(env::AbstractMicroclimGrid{S,I,A,R}, i::CartesianIndex) where {S,I,A,R} =
    MicroclimPoint{S,I,A,R}(radiation(env), snowdepth(env), airtemperature(env),
                   relhumidity(env), windspeed(env), soiltemperature(env),
                   soilwaterpotential(env), soilwatercontent(env), i)

missing_otherwise(f, d) =
    (length(d) == 0 || any(ismissing.(d))) ? missing : f.(d) 

missing_otherwise_cat(f, ds::Tuple, i) = begin
    maybedata = map(d -> missing_otherwise_cat(f, d, i), ds)
    if any(map(ismissing, maybedata))
        missing
    else
        hcat(maybedata...)
    end
end
missing_otherwise_cat(f, d, i) =
    if length(d) == 0 
        nothing
    else
        p = catpoint(d, i)
        any(ismissing.(p)) ? missing : f.(p) 
    end


@inline layer_sizes(env::MicroclimPoint{S,I,NL,R}) where {S,I,NL,R} = layer_sizes(zero(NL), I, NL)
@inline layer_bounds(env::MicroclimPoint{S,I,NL,R}) where {S,I,NL,R} = layer_bounds(I, NL)


abstract type AbstractMicroclimInstant end

struct MicroclimInstant{M,I,T} <: AbstractMicroclimInstant
    microclimate::M
    interp::I
    t::T
end
MicroclimInstant(microclim, height::Number, t) = 
    MicroclimInstant(microclim, LinearLayerInterpolators(microclim, height), t)

@inline layermax(layers, x::MicroclimInstant) = layermax(layers, x.interp.increment, x.t)


struct MicroclimateLayers{L<:Tuple}
    layers::L
end


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
get_shade(layers::AbstractLayeredMicroclimate{S,I,A,R}) where {S,I,A,R} = S
get_increments(layers::AbstractLayeredMicroclimate{S,I,A,R}) where {S,I,A,R} = I
get_nextlayer(layers::AbstractLayeredMicroclimate{S,I,A,R}) where {S,I,A,R} = A
get_range(layers::AbstractLayeredMicroclimate{S,I,A,R}) where {S,I,A,R} = R

@inline catpoint(layers::Tuple{}, i::CartesianIndex) = Float64[]
@inline catpoint(layers::Tuple, i::CartesianIndex) =
    cat([[cat((y[i, :] for y in l)..., dims=1)...] for l in layers]..., dims=2)
@inline catpoint(layers::Vector, i::CartesianIndex) = 
    cat((getindex(y, i, :) for y in layers)..., dims=1)


# Accessors for single layer data
for name in (:radiation, :snowdepth)
    eval(quote
        $name(env::AbstractMicroclimate) = env.$name
        $name(env::AbstractMicroclimPoint, interp, i) = lin_interp($name(env), i)
        $name(env::AbstractMicroclimPoint, i) = lin_interp($name(env.microclimate), i)
        $name(env::AbstractMicroclimInstant) = lin_interp($name(env.microclimate), env.t)
        $name(env::AbstractMicroclimControl, x, args...) = $name(env)
    end)
end

# Accessor functions for range and increment data
for (name, mode) in ((:airtemperature, :range), (:relhumidity, :range), (:windspeed, :range),
                     (:soiltemperature, :increment), (:soilwaterpotential, :increment),
                     (:soilwatercontent, :increment))
    eval(quote
        $name(env::AbstractMicroclimate) = env.$name
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
        $name(env::AbstractMicroclimControl, x, args...) = $name(env)
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
        # No mean for control, just return the control value
        $(Symbol(:mean_, name))(env::AbstractMicroclimControl, args...) = $name(env)
    end)
end
