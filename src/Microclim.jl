module Microclim

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

include("interpolation.jl")
include("types.jl")
include("netcdf.jl")
include("files.jl")

end # module
