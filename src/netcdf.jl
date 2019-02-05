# load32(fpath, varname) = replace(load_netcdf(fpath, varname), -32768=>missing)
# load64(fpath, varname) = replace(load_netcdf(fpath, varname), -2147483647=>missing)

const layers_8 = ("0", "2.5", "5", "10", "20", "30", "50", "100")
const layers_2 = ("1", "120")


" Load multiple years for an index "
load_point(basepath, years, shade, i::CartesianIndex) = 
    MicroclimPoint(load_microclim(basepath, years, shade, i)...)

" Load grids for a single year "
load_grid(basepath, shade, year::Int) = MicroclimGrid(load_microclim(basepath, shade, year)...)

checkdir(loader, basepath, file) = begin
    if isdir(joinpath(basepath, file))
        loader()
    else
        ()
    end
end

"""
Generic microcliate loader. An Int year and no args will return a MicroclimGrid
with full raster layers for asingle year. A range of years within 1990:2017 and a 
CartesianIndex in args will return a MicroclimPoint.
"""
load_microclim(basepath, years, shade, args...) = begin
    check_year(years)

    radiation = checkdir(basepath, "SOLR") do
        load_file(basepath, "SOLR", years, args...)
    end

    snowdepth = checkdir(basepath, "SNOWDEP_$(shade)pctShade") do
        load_file(basepath, (n, y) -> "$(n)_$(shade)pctShade/$(n)_$(shade)pctShade_$(y).nc", "SNOWDEP", years, args...)
    end

    airtemperature = checkdir(basepath, "Tair120cm") do
        load_file(basepath, (n, y) -> "Tair1cm_$(shade)pctShade/$(n)_$(shade)pctShade_$(y).nc", "TA1cm", years, args...),
        load_file(basepath, (n, y) -> "Tair120cm/$(n)_$(y).nc", "TA120cm", years, args...)
    end

    relhumidity = checkdir(basepath, "RH120cm") do
        load_file(basepath, (n, y) -> "$(n)_$(shade)pctShade/$(n)_$(shade)pctShade_$(y).nc", "RH1cm", years, args...),
        load_file(basepath, "RH120cm", years, args...)
    end

    windspeed = checkdir(basepath, "V120cm") do
        load_file(basepath, "V1cm", years, args...),
        load_file(basepath, "V120cm", years, args...)
    end

    soiltemperature = checkdir(basepath, "soil$(shade)cm_$(shade)pctShade") do
        load_folder(basepath, "soil", layers_8, years, shade, args...)
    end

    soilwaterpotential =  checkdir(basepath, "pot$(shade)cm_$(shade)pctShade") do
        load_folder(basepath, "pot", layers_8, years, shade, args...)
    end

    soilwatercontent = checkdir(basepath, "moist$(shade)cm_$(shade)pctShade") do
        load_folder(basepath, "moist", layers_8, years, shade, args...)
    end

    radiation, snowdepth, airtemperature, relhumidity, windspeed, 
    soiltemperature, soilwaterpotential, soilwatercontent
end


check_year(year::Integer) = year >= 1990 && year <= 2017 || error("$year is not between 1990 and 2017")
check_year(years) = check_year(years.start) && check_year(years.stop)


load_file(basepath::String, formatter, name::String, years, args...) =
    load_variable(basepath, formatter, name, name, years, args...)
load_file(basepath::String, name::String, years, args...) =
    load_variable(basepath, (n, y) -> "$(n)/$(n)_$(y).nc", name, name, years, args...)

load_folder(basepath, name, layers, years, shade, args...) =
    tuple((load_variable(basepath, (n, y) -> "$(n)$(l)cm_$(shade)pctShade/$(n)$(l)cm_$(shade)pctShade_$(y).nc", name,
                         "$(name)$(l)cm", years, args...) for l in layers)...)


" load timeseries for a single index "
load_variable(basepath::String, formatter, name::String, varname::String, years, i::CartesianIndex) = begin
    println("Adding $varname for $years at $i")
    combined_dataset = Float64[]
    for year in years
        path = joinpath(basepath, formatter(name, year))
        println(path)
        println(varname)
        annual_datset = [Dataset(path)[varname][i, :]...]
        println(typeof(annual_datset))
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

