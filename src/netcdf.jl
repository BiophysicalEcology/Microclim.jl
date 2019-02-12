const layerincrements = (0.0, 0.025, 0.05, 0.1, 0.2, 0.3, 0.5, 1.0) .* m
const layernames = ("0", "2.5", "5", "10", "20", "30", "50", "100")
const nextlayer = 2.0m
const layerrange = (0.01, 1.20) .* m


" Load multiple years for an index "
load_point(basepath, years, shade, i::CartesianIndex) = 
    MicroclimPoint{layerincrements,nextlayer,layerrange}(load_microclim(basepath, years, shade, i)...)

" Load grids for a single year "
load_grid(basepath, shade, years) = 
    MicroclimGrid{layerincrements,nextlayer,layerrange}(load_microclim(basepath, shade, years)...)

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
        load_folder(basepath, "soil", layernames, years, shade, args...)
    end

    soilwaterpotential = checkdir(basepath, "pot$(shade)cm_$(shade)pctShade") do
        load_folder(basepath, "pot", layernames, years, shade, args...)
    end

    soilwatercontent = checkdir(basepath, "moist$(shade)cm_$(shade)pctShade") do
        # load_folder(basepath, "moist", layernames, years, shade, args...)
        ()
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
load_variable(basepath::String, formatter, name::String, varname::String, years,  i::CartesianIndex) = begin
    println("Adding $varname for $years at $i")
    combined_data = Float64[]
    for year in years
        path = joinpath(basepath, formatter(name, year))
        println(path, "\n", varname)
        year_data = [Dataset(path)[varname][i, :]...]
        println(typeof(year_data))
        combined_data = vcat(combined_data, year_data)
    end
    combined_data
end

# " load timeseries for a single index "
load_variable(basepath::String, formatter, name::String, varname::String, years) = begin
    println("Adding $varname for $years for complete grid")

    # Initialise for the first year, as the eltype is variable
    path1 = joinpath(basepath, formatter(name, years[1]))
    years_vector = [Dataset(path1)[varname]]

    # Add the rest of the years, if there are any
    for i in 2:length(years)
        path = joinpath(basepath, formatter(name, years[i]))
        push!(years_vector, get_yeardata(path, varname))
    end

    # Return a vector of NCDatasets for each year
    years_vector
end

function get_yeardata(path, varname) 
    println("Retrieving ", varname, " from ", path)
    Dataset(path)[varname]
end
