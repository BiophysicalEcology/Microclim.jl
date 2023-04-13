radiation_type = typeof(0.1u"W*m^-2")
zenith_type = typeof(0.1u"°")
snowdepth_type = typeof(0.1u"m")
airtemperature_type = typeof(0.1u"K")
skytemperature_type = typeof(0.1u"K")
relhumidity_type = typeof(0.001)
windspeed_type = typeof(0.1u"m*s^-1")
soiltemperature_type = typeof(0.1u"K")
soilwaterpotential_type = typeof(0.0u"kPa")
soilwatercontent_type = typeof(0.001)
soilhumidity_type = typeof(0.001)

abstract type AbstractMicroclimate end
abstract type AbstractLayeredMicroclimate{S,I,A,R} <: AbstractMicroclimate end
abstract type AbstractMicroclimControl <: AbstractMicroclimate end
abstract type AbstractMicroclimGrid{S,I,A,R} <: AbstractLayeredMicroclimate{S,I,A,R} end
abstract type AbstractMicroclimPoint{S,I,A,R} <: AbstractLayeredMicroclimate{S,I,A,R} end


@udefault_kw @units @limits struct MicroclimControl{RA,RZ,SN,AT,AS,RH,WS,ST,WP,WC,SH} <: AbstractMicroclimControl
    radiation::RA          | 200.0  | W*m^-2 | (500.0, 1200.0)
    zenith::RZ             | 20.0   | °      | (0, 90)
    snowdepth::SN          | 0.0    | m      | (0.0, 10.0)
    airtemperature::AT     | 290.0  | K      | (260.0, 370.0)
    skytemperature::AS     | 290.0  | K      | (260.0, 370.0)
    relhumidity::RH        | 0.7    | _      | (0.0, 1.0)
    windspeed::WS          | 0.1    | m*s^-1 | (0.0, 20.0)
    soiltemperature::ST    | 290.0  | K      | (260.0, 370.0)
    soilwaterpotential::WP | -100.0 | kPa    | (-0.0, -10000.0)
    soilwatercontent::WC   | 0.3    | _      | (0.0, 1.0)
    soilhumidity::SH       | 0.99   | _      | (0.0, 1.0)
end


struct MicroclimGrid{S,I,A,R,RA,RZ,SN,AT,AS,RH,WS,ST,WP,WC,SH} <: AbstractMicroclimGrid{S,I,A,R}
    radiation::RA
    zenith::RZ
    snowdepth::SN
    airtemperature::AT
    skytemperature::AS
    relhumidity::RH
    windspeed::WS
    soiltemperature::ST
    soilwaterpotential::WP
    soilwatercontent::WC
    soilhumidity::SH
end

MicroclimGrid{S,I,A,R}(radiation::RA, zenith::RZ, snowdepth::SN, airtemperature::AT, skytemperature::AS, relhumidity::RH,
                        windspeed::WS, soiltemperature::ST, soilwaterpotential::WP,
                        soilwatercontent::WC, soilhumidity::SH) where {S,I,A,R,RA,RZ,SN,AT,AS,RH,WS,ST,WP,WC,SH} =
    MicroclimGrid{S,I,A,R,RA,RZ,SN,AT,AS,RH,WS,ST,WP,WC,SH}(radiation, zenith, snowdepth, airtemperature,
        skytemperature, relhumidity, windspeed, soiltemperature, soilwaterpotential, soilwatercontent, soilhumidity)


struct MicroclimPoint{S,I,A,R,RA,RZ,SN,AT,AS,RH,WS,ST,WP,WC,SH} <: AbstractMicroclimPoint{S,I,A,R}
    radiation::RA
    zenith::RZ
    snowdepth::SN
    airtemperature::AT
    skytemperature::AS
    relhumidity::RH
    windspeed::WS
    soiltemperature::ST
    soilwaterpotential::WP
    soilwatercontent::WC
    soilhumidity::SH
end

MicroclimPoint{S,I,A,R}(radiation::RA, zenith::RZ, snowdepth::SN, airtemperature::AT, skytemperature::AS, relhumidity::RH,
                        windspeed::WS, soiltemperature::ST, soilwaterpotential::WP,
                        soilwatercontent::WC, soilhumidity::SH) where {S,I,A,R,RA,RZ,SN,AT,AS,RH,WS,ST,WP,WC,SH} =
    MicroclimPoint{S,I,A,R,RA,RZ,SN,AT,AS,RH,WS,ST,WP,WC,SH}(radiation, zenith, snowdepth, airtemperature, skytemperature,
        relhumidity, windspeed, soiltemperature, soilwaterpotential, soilwatercontent, soilhumidity)

# From external data without units
MicroclimPoint{S,I,A,R}(radiation::Vector{<:AbstractFloat}, zenith::Vector{<:AbstractFloat}, snowdepth::Vector{<:AbstractFloat},
                      airtemperature::Matrix{<:AbstractFloat}, skytemperature::Vector{<:AbstractFloat}, relhumidity::Matrix{<:AbstractFloat},
                      windspeed::Matrix{<:AbstractFloat}, soiltemperature::Matrix{<:AbstractFloat},
                      soilwaterpotential::Matrix{<:AbstractFloat}, soilwatercontent::Matrix{<:AbstractFloat}, soilhumidity::Matrix{<:AbstractFloat}
                     ) where {S,I,A,R} = begin
    rad = missing_otherwise(to_radiation, radiation)
    zen = missing_otherwise(to_zenith, zenith)
    snow = missing_otherwise(to_snowdepth, snowdepth)
    airt = missing_otherwise(to_airtemperature, airtemperature)
    skyt = missing_otherwise(to_skytemperature, skytemperature)
    relh = missing_otherwise(to_relhumidity, relhumidity)
    wind = missing_otherwise(to_windspeed, windspeed)
    soilt = missing_otherwise(to_soiltemperature, soiltemperature)
    soilwp = missing_otherwise(to_soilwaterpotential, soilwaterpotential)
    soilwc = missing_otherwise(to_soilwatercontent, soilwatercontent)
    soilrh = missing_otherwise(to_soilhumidity, soilhumidity)

    args = (rad, zen, snow, airt, skyt, relh, wind, soilt, soilwp, soilwc, soilrh)
    if any(ismissing.(args))
        missing
    else
        MicroclimPoint{S,I,A,R,typeof.(args)...}(args...)
    end
end

# From microclim dataset in tuples and a cartesian index
# Requires conversion to float from Int
MicroclimPoint{S,I,A,R}(radiation::Vector, zenith::Vector, snowdepth::Vector, airtemperature::Tuple, skytemperature::Vector,
                        relhumidity::Tuple, windspeed::Tuple, soiltemperature::Tuple,
                        soilwaterpotential::Tuple, soilwatercontent::Tuple, soilhumidity::Tuple, i::CartesianIndex) where {S,I,A,R} = begin
    rad = missing_otherwise_cat(x -> to_radiation(0.1x), radiation, i)
    zen = missing_otherwise_cat(x -> to_zenith(0.1x), zenith, i)
    snow = missing_otherwise_cat(x -> to_snowdepth(0.001x), snowdepth, i)
    airt = missing_otherwise_cat(x -> to_airtemperature(0.1x), airtemperature, i)
    skyt = missing_otherwise_cat(x -> to_skytemperature(0.1x), skytemperature, i)
    relh = missing_otherwise_cat(x -> to_relhumidity(0.001x), relhumidity, i)
    wind = missing_otherwise_cat(x -> to_windspeed(0.1x), windspeed, i)
    soilt = missing_otherwise_cat(x -> to_soiltemperature(0.1x), soiltemperature, i)
    soilwp = missing_otherwise_cat(x -> to_soilwaterpotential(0.1x), soilwaterpotential, i)
    soilwc = missing_otherwise_cat(x -> to_soilwatercontent(0.001x), soilwatercontent, i)
    soilrh = missing_otherwise_cat(x -> to_soilhumidity(0.001x), soilhumidity, i)

    args = (rad, zen, snow, airt, skyt, relh, wind, soilt, soilwp, soilwc, soilrh)
    if any(ismissing.(args))
        missing
    else
        MicroclimPoint{S,I,A,R,typeof.(args)...}(args...)
    end
end

# From MicroclimGrid and a cartesian index
MicroclimPoint(env::AbstractMicroclimGrid{S,I,A,R}, i::CartesianIndex) where {S,I,A,R} =
    MicroclimPoint{S,I,A,R}(radiation(env), zenith(env), snowdepth(env), airtemperature(env),
                   skytemperature(env), relhumidity(env), windspeed(env), soiltemperature(env),
                   soilwaterpotential(env), soilwatercontent(env), soilhumidity(env), i)

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

struct MicroclimInstant{M,T,I} <: AbstractMicroclimInstant
    microclimate::M
    t::T
    interp::I
end
MicroclimInstant(microclim, t, height::Number) = 
    MicroclimInstant(microclim, t, LinearLayerInterpolators(microclim, height))

@inline layermax(layers, x::MicroclimInstant) = layermax(layers, x.t, x.interp.increment)


struct MicroclimateLayers{L<:Tuple}
    layers::L
end


# unit conversions
to_radiation(x) = x * W*m^-2
to_zenith(x) = x * °
to_snowdepth(x) = x * m
to_airtemperature(x) = x * °C |> K
to_skytemperature(x) = x * °C |> K
to_relhumidity(x) = x
to_windspeed(x) = x * m*s^-1
to_soiltemperature(x) = x * °C |> K
to_soilwaterpotential(x) = x * kPa
to_soilwatercontent(x) = x
to_soilhumidity(x) = x

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
for name in (:skytemperature, :radiation, :zenith, :snowdepth)
    eval(quote
        $name(env::AbstractMicroclimate) = env.$name
        $name(env::AbstractMicroclimPoint, t, interp) = lin_interp($name(env), t)
        $name(env::AbstractMicroclimInstant) = lin_interp($name(env.microclimate), env.t)
        $name(env::AbstractMicroclimControl, x, args...) = $name(env)
    end)
end

# Accessor functions for range and increment data
for (name, mode) in ((:airtemperature, :range), (:relhumidity, :range), (:windspeed, :range),
                     (:soiltemperature, :increment), (:soilwaterpotential, :increment),
                     (:soilwatercontent, :increment), (:soilhumidity, :increment))
    eval(quote
        $name(env::AbstractMicroclimate) = env.$name
        $name(env::AbstractMicroclimPoint, t, interp::LinearLayerInterpolators) =
            $name(env::AbstractMicroclimPoint, t, interp.$mode)
        $name(env::AbstractMicroclimPoint, t, height::Number) =
            $name(env, t, $(Symbol(mode, :_interpolator))(height))
        $name(env::AbstractMicroclimInstant) =
            $name(env.microclimate, env.t, env.interp)
        $name(env::AbstractMicroclimInstant, interp::AbstractLayerInterpolator) =
            $name(env.microclimate, env.t, interp)
        $name(env::AbstractMicroclimControl, x, args...) = $name(env)
        $name(env::AbstractMicroclimPoint, t, interp::LinearLayerInterpolator) =
            interp_layer($name(env), t, interp)
    end)
end

# Accessors for weighted mean of 8 layer data
for name in (:soiltemperature, :soilwatercontent, :soilwaterpotential, :soilhumidity)
    eval(quote
        $(Symbol(:mean_, name))(env::AbstractMicroclimPoint, t, x) =
            weightedmean(env, $name(env), t, x)
        $(Symbol(:mean_, name))(env::AbstractMicroclimInstant) =
            weightedmean(env, $name(env.microclimate), env.t, env.interp)
        $(Symbol(:mean_, name))(env::AbstractMicroclimInstant, t::Number) =
            weightedmean(env, $name(env.microclimate), t, env.interp)
        $(Symbol(:mean_, name))(env::AbstractMicroclimInstant, interp::AbstractLayerInterpolator) =
            weightedmean(env, $name(env.microclimate), env.t, interp)
        # No mean for control, just return the control value
        $(Symbol(:mean_, name))(env::AbstractMicroclimControl, args...) = $name(env)
    end)
end
