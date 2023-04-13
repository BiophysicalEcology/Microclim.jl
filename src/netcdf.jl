const LAYERINCREMENTS = (0.0, 0.025, 0.05, 0.1, 0.2, 0.3, 0.5, 1.0) .* m
const LAYERNAMES = ("0", "2.5", "5", "10", "20", "30", "50", "100")
const NEXTLAYER = 2.0m
const LAYERRANGE = (0.01, 1.20) .* m


" Load multiple years for an index "
load_point(basepath::String, years::AbstractVector, shade::Int, i::CartesianIndex, skip=()) = 
    MicroclimPoint{shade,LAYERINCREMENTS,NEXTLAYER,LAYERRANGE}(load_microclim(basepath, years, shade, skip, i)...)

" Load grids for a single year "
load_grid(basepath::String, years::AbstractVector, shade::Int, skip=()) = 
    MicroclimGrid{shade,LAYERINCREMENTS,NEXTLAYER,LAYERRANGE}(load_microclim(basepath, years, shade, skip)...)

ifhasdir(loader, basepath, file, empty) = 
    if isdir(joinpath(basepath, file))
        loader()
    else
        println("$file does not exits. Skipping and returning $empty.")
        empty
    end

"""
Generic microcliate loader. An Int year and no args will return a MicroclimGrid
with full raster layers for a single year. A range of years within 1990:2017 and a 
CartesianIndex in args will return a MicroclimPoint.
"""
load_microclim(basepath, years, shade, skip, args...) = begin
    check_year(years)

    radiation = :radiation in skip ? [] : load_file(basepath, "SOLR", years, args...)

    zenith = :zenith in skip ? [] : 
        load_file((n, y) -> "$(n)/$(n).nc", basepath, "ZEN", years, args...)

    snowdepth = :snowdepth in skip ? [] : 
        load_file((n, y) -> "$(n)/$(shade)pctShade/$(n)_$(shade)pctShade_$(y).nc", basepath, "SNOWDEP", years, args...)

    airtemperature = :airtemperature in skip ? () : 
        load_file((n, y) -> "Tair1cm/$(shade)pctShade/$(n)_$(shade)pctShade_$(y).nc", basepath, "TA1cm", years, args...),
        load_file(basepath, "TA120cm", years, args...)

    skytemperature = :skytemperature in skip ? [] : 
        load_file((n, y) -> "$(n)/$(shade)pctShade/$(n)_$(shade)pctShade_$(y).nc", basepath, "TSKYC", years, args...)

    relhumidity = :relhumidity in skip ? () :
        load_file((n, y) -> "$(n)/$(shade)pctShade/$(n)_$(shade)pctShade_$(y).nc", basepath, "RH1cm", years, args...),
        load_file(basepath, "RH120cm", years, args...)

    windspeed = :windspeed in skip ? () :
        load_file(basepath, "V1cm", years, args...), 
        load_file(basepath, "V120cm", years, args...)

    soiltemperature = :soiltemperature in skip ? () : load_folder(basepath, "soil", LAYERNAMES, years, shade, args...)
    soilwaterpotential = :soilwaterpotential in skip ? () : load_folder(basepath, "pot", LAYERNAMES, years, shade, args...)
    soilwatercontent = :soilwatercontent in skip ? () : load_folder(basepath, "moist", LAYERNAMES, years, shade, args...)
    soilhumidity = :soilhumidity in skip ? () : load_folder(basepath, "hum", LAYERNAMES, years, shade, args...)

    radiation, zenith, snowdepth, airtemperature, skytemperature, relhumidity, windspeed, 
    soiltemperature, soilwaterpotential, soilwatercontent, soilhumidity
end


check_year(year::Integer) = year >= 1990 && year <= 2017 || error("$year is not between 1990 and 2017")
check_year(years) = check_year(years.start) && check_year(years.stop)


load_file(formatter::Function, basepath::String, name::String, years, args...) =
    load_variable(formatter, basepath, name, name, years, args...)
load_file(basepath::String, name::String, years, args...) = begin
    formatter = (n, y) -> "$(n)/$(n)_$(y).nc"
    load_variable(formatter, basepath, name, name, years, args...)
end

load_folder(basepath, name, layers, years, shade, args...) =
    ((load_variable(basepath, name, "$(name)$(l)cm", years, args...) do n, y 
         "$(n)$(l)cm/$(shade)pctShade/$(n)$(l)cm_$(shade)pctShade_$(y).nc"
     end for l in layers)...,)


"load timeseries for a single index"
load_variable(formatter::Function, basepath::String, name::String, varname::String, years,  i::CartesianIndex) = begin
    println("Adding $varname for $years at $i")
    combined_data = Float64[]
    for year in years
        path = joinpath(basepath, formatter(name, year))
        year_data = [get_yeardata(path, varname)[i, :]...]
        combined_data = vcat(combined_data, year_data)
    end
    combined_data
end
"load timeseries for a single index"
load_variable(formatter::Function, basepath::String, name::String, varname::String, years,  i::CartesianIndex) = begin
    println("Adding $varname for $years at $i")
    combined_data = Float64[]
    if varname == "ZEN"
        for year in years            
            if year in [1900:4:2100;]
                formatter = (n) -> "$(n)/$(n)_leap.nc"  
             path = joinpath(basepath, formatter(name))
             year_data = [get_yeardata(path, varname)[i, :]...]
            else
                formatter = (n) -> "$(n)/$(n).nc"  
                path = joinpath(basepath, formatter(name))
                year_data = [get_yeardata(path, varname)[i, :]...]
            end   
            combined_data = vcat(combined_data, year_data)
        end
        combined_data
    else
    for year in years
        path = joinpath(basepath, formatter(name, year))
        year_data = [get_yeardata(path, varname)[i, :]...]
        combined_data = vcat(combined_data, year_data)
    end
end
    combined_data
end

"load timeseries for the whole grid"
load_variable(formatter::Function, basepath::String, name::String, varname::String, years) = begin
    println("Adding $varname for $years for complete grid")
    if varname == "ZEN"
        # Initialise for the first year, as the eltype is variable
        if years[1] in [1900:4:2100;]
            formatter = (n) -> "$(n)/$(n)_leap.nc"  
            path1 = joinpath(basepath, formatter(name))
            years_vector = [get_yeardata(path1, varname)]
        else
            formatter = (n) -> "$(n)/$(n).nc"  
            path1 = joinpath(basepath, formatter(name))
            years_vector = [get_yeardata(path1, varname)]
        end

        # Add the rest of the years, if there are any
        for i in 2:length(years)
            if years[i] in [1900:4:2100;]
                formatter = (n) -> "$(n)/$(n)_leap.nc"  
                path = joinpath(basepath, formatter(name, years[i]))
                push!(years_vector, get_yeardata(path, varname))
            else
                formatter = (n) -> "$(n)/$(n).nc"  
                path = joinpath(basepath, formatter(name, years[i]))
                push!(years_vector, get_yeardata(path, varname))
            end
        end
    else
        # Initialise for the first year, as the eltype is variable
        path1 = joinpath(basepath, formatter(name, years[1]))
        years_vector = [get_yeardata(path1, varname)]

        # Add the rest of the years, if there are any
        for i in 2:length(years)
            path = joinpath(basepath, formatter(name, years[i]))
            push!(years_vector, get_yeardata(path, varname))
        end
    end
    # Return a vector of NCDatasets for each year
    years_vector
end

function get_yeardata(path, varname) 
    println("Retrieving ", varname, " from ", path)
    Dataset(path)[varname][:,:,:]
end
