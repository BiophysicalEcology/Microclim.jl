
using Microclimate
using Plots

using Unitful, 
      NCDatasets, 
      FieldMetadata, 
      FieldDefaults

using Unitful: W, m, °C, hr, mol, K, s, J, Mg, g, kg, L, kPa, Pa, °

import FieldMetadata: default, units, limits, @units, @limits

export AbstractMicroclimate,
       AbstractLayeredMicroclimate,
       AbstractMicroclimGrid, MicroclimGrid,
       AbstractMicroclimPoint, MicroclimPoint,
       AbstractMicroclimInstant, MicroclimInstant,
       AbstractMicroclimControl, MicroclimControl,
       LinearLayerInterpolator, LinearLayerInterpolators

export radiation, snowdepth, airtemperature, skytemperature, relhumidity, windspeed,
       soiltemperature, soilwaterpotential, soilwatercontent, soilhumidity

export mean_soiltemperature, mean_soilwaterpotential, mean_soilwatercontent, mean_soilhumidity

export weightedmean, layermax

export load_grid, load_point

export download_microclim

include("c://git/Microclimate.jl/src/interpolation.jl")
include("c://git/Microclimate.jl/src/types.jl")
include("c://git/Microclimate.jl/src/netcdf.jl")
include("c://git/Microclimate.jl/src/files.jl")

basepath = "c:/Spatial_Data/microclimOz"
years = 2000:2000
shade = 0
envgrid = load_grid(basepath, years, shade)
envpoint = load_point(basepath, years, shade, CartesianIndex(65, 35))

plot(envgrid.zenith[1][65, 35, 1:24])
plot(envpoint.radiation[1:24])

t1 = MicroclimPoint(envgrid, CartesianIndex(65, 35))
t2 = MicroclimPoint(envgrid, CartesianIndex(60, 35))
t3 = MicroclimPoint(envgrid, CartesianIndex(55, 35))

plot(t1.zenith[1:24])