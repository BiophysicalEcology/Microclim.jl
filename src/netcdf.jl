# load32(fpath, varname) = replace(load_netcdf(fpath, varname), -32768=>missing)
# load64(fpath, varname) = replace(load_netcdf(fpath, varname), -2147483647=>missing)

const layers_8 = ("0", "2.5", "5", "10", "20", "30", "50", "100")
const layers_2 = ("1", "120")


" Load multiple years for an index "
load_point(basepath, years, i::CartesianIndex) = MicroclimPoint(load_microclim(basepath, years, i)...)

" Load grids for a single year "
load_grid(basepath, year::Int) = MicroclimGrid(load_microclim(basepath, year)...)

"""
Generic microcliate loader. An Int year and no args will return a MicroclimGrid
with full raster layers for asingle year. A range of years within 1990:2017 and a 
CartesianIndex in args will return a MicroclimPoint.
"""
load_microclim(basepath, years, args...) = begin
    check_year(years)

    radiation = load_file(basepath, "SOLR", years, args...)
    snowdepth = ()
    airtemperature = load_file(basepath, (n, y) -> "Tair1cm_0pctShade/$(n)_0pctShade_$(y).nc", "TA1cm", years, args...),
                     load_file(basepath, (n, y) -> "Tair120cm/$(n)_$(y).nc", "TA120cm", years, args...)
    relhumidity = load_file(basepath, (n, y) -> "$(n)_0pctShade/$(n)_0pctShade_$(y).nc", "RH1cm", years, args...),
                  load_file(basepath, "RH120cm", years, args...)
    windspeed = load_file(basepath, "V1cm", years, args...),
                load_file(basepath, "V120cm", years, args...)
    soiltemperature = load_folder(basepath, "soil", layers_8, years, args...)
    soilwaterpotential = load_folder(basepath, "pot", layers_8, years, args...)
    soilwatercontent = ()

    radiation, snowdepth, airtemperature, relhumidity, windspeed, 
    soiltemperature, soilwaterpotential, soilwatercontent
end


check_year(year::Integer) = year >= 1990 && year <= 2017 || error("$year is not between 1990 and 2017")
check_year(years) = check_year(years.start) && check_year(years.stop)


load_file(basepath::String, formatter, name::String, years, args...) =
    load_variable(basepath, formatter, name, name, years, args...)
load_file(basepath::String, name::String, years, args...) =
    load_variable(basepath, (n, y) -> "$(n)/$(n)_$(y).nc", name, name, years, args...)

load_folder(basepath, name, layers, years, args...) =
    tuple((load_variable(basepath, (n, y) -> "$(n)$(l)cm_0pctShade/$(n)$(l)cm_0pctShade_$(y).nc", name,
                         "$(name)$(l)cm", years, args...) for l in layers)...)


" load timeseries for a single index "
load_variable(basepath::String, formatter, name::String, varname::String, years, i::CartesianIndex) = begin
    println("Adding $varname for $years at $i")
    combined_dataset = Float64[]
    for year in years
        path = joinpath(basepath, formatter(name, year))
        annual_datset = Dataset(path)[varname][i, :]
        combined_dataset = vcat(combined_dataset, annual_datset)
    end
    combined_dataset
end
" load timeseries for the whole grid "
load_variable(basepath::String, formatter, name::String, varname::String, year::Integer) = begin
    println("Adding $varname for $year")
    path = joinpath(basepath, formatter(name, year))
    Dataset(path)[varname]
end

