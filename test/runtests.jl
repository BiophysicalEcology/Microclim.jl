using Microclimate, Unitful, Test
using Microclimate: range_interpolator, increment_interpolator, interp_layer, layer_sizes,
                    layer_props, layer_bounds, max_height, lin_interp
using Unitful: W, m, °C, K, s, g, L, kPa

const layerincrements = (0.0, 0.025, 0.05, 0.1, 0.2, 0.3, 0.5, 1.0) .* m
const layerrange = (0.01, 1.20) .* m
const nextlayer = 2.0m

rad = [1000.0, 900.0]W*m^-2
snow = [1.0, 0.9]m
airt = [25.0 24.0 
        30.0 29.0]°C .|> K
ws = [1.0 2.0
      3.0 4.0]m*s^-1
rh = [0.7 0.5 
      0.8 0.6]
soilt = [20.0 19.0 18.0 17.0 16.0 15.0 14.0 13.0
         12.0 11.0 10.0 9.0  8.0  7.0  6.0  5.0]°C .|> K
soilwp = [-100.0 -90.0 -120.0 -80.0 -110.0 -70.0 -130.0 -60.0
          -100.0 -90.0 -120.0 -80.0 -110.0 -70.0 -130.0 -60.0]kPa
soilwc = [0.2 0.3 0.2 0.3 0.2 0.3 0.2 0.3
          0.4 0.5 0.4 0.5 0.4 0.5 0.4 0.5]

@testset "MicroclimPoint" begin
    env = MicroclimPoint{100,layerincrements,nextlayer,layerrange}(rad, snow, airt, rh, ws, soilt, soilwp, soilwc)
    half = (1.2m - 0.01m) / 2 + 0.01m

    @test all(layer_sizes(env) .≈ (0.0125, 0.025, 0.0375, 0.075, 0.1, 0.15, 0.35, 0.75) .* m)
    @test all(layer_bounds(env) .≈ (0.0125, 0.0375, 0.075, 0.15, 0.25, 0.4, 0.75, 1.5) .* m)
    @test max_height(env) == 1.5m
    @test layer_props(env) == layer_sizes(env) ./ 1.5m

    @test radiation(env, 1, range_interpolator(env, 1.2m)) == 1000.0W*m^-2
    @test snowdepth(env, 1, range_interpolator(env, 1.2m)) == 1.0m

    @testset "ranges interpolate" begin
        @test airtemperature(env, 1, range_interpolator(env, 0.01m)) |> °C == 25.0°C
        @test airtemperature(env, 1, range_interpolator(env, half)) |> °C == 24.5°C
        @test airtemperature(env, 1, range_interpolator(env, 1.2m)) |> °C == 24.0°C
        @test windspeed(env, 2, range_interpolator(env, 1.2m)) == 4.0m*s^-1
        @test relhumidity(env, 2, range_interpolator(env, 1.2m)) == 0.6
    end

    @testset "increments interpolate" begin
        @test soiltemperature(env, 1, increment_interpolator(env, 0.0m)) |> °C == 20.0°C
        @test soiltemperature(env, 1, increment_interpolator(env, 0.075m)) |> °C == 17.5°C
        @test soiltemperature(env, 2, increment_interpolator(env, 0.1m)) |> °C == 9.0°C
        @test soiltemperature(env, 1, increment_interpolator(env, 0.40m)) |> °C == 14.50°C
        @test soiltemperature(env, 1, increment_interpolator(env, 0.5m)) |> °C == 14.0°C
        @test soiltemperature(env, 2, increment_interpolator(env, 1.0m)) |> °C == 5.0°C
        @test soilwaterpotential(env, 1, increment_interpolator(env, 0.0m)) == -100kPa
        @test soilwatercontent(env, 2, increment_interpolator(env, 0.0m)) == 0.4
    end

    @testset "float indices are linearly interpolated in the time dimension" begin
        @test windspeed(env, 1.5, range_interpolator(env, 1.2m)) == 3.0m*s^-1
        @test relhumidity(env, 1.75, range_interpolator(env, 1.2m)) == 0.575
        @test relhumidity(env, 1.5, range_interpolator(env, half)) == 0.65
    end

    @testset "handles heights larger than available" begin
        @test soiltemperature(env, 1, increment_interpolator(env, 2.0m)) == 13.0°C
        @test airtemperature(env, 1, range_interpolator(env, 2.0m)) |> °C == 24.0°C
    end

    @testset "weighted mean" begin
        @test weightedmean(env, soilwatercontent(env), 1, 0.0125m) ≈ 0.2
        mid = sum([0.2, 0.3, 0.2, 0.3] .* (layer_sizes(env)[1:4] ./ 0.15m))
        @test weightedmean(env, soilwatercontent(env), 1, 0.15m) ≈ mid
        max = sum([0.2, 0.3, 0.2, 0.3, 0.2, 0.3, 0.2, 0.3] .* layer_props(env))
        @test weightedmean(env, soilwatercontent(env), 1, 1.5m) ≈ max
        @test weightedmean(env, soilwatercontent(env), 1, 2.0m) ≈ max
        @test mean_soilwatercontent(env, 1, 1.5m) ≈ max
        mean_soilwaterpotential(env, 1, 1.5m)
        mean_soiltemperature(env, 1, 1.5m)
    end

    @testset "max" begin
        @test layermax(soiltemperature(env), 1, increment_interpolator(env, 2.0m)) |> °C == 20.0°C
    end

end

@testset "MicroclimInstant" begin
    point = MicroclimPoint{100,layerincrements,nextlayer,layerrange}(
        rad, snow, airt, rh, ws, soilt, soilwp, soilwc
    )
    instant = MicroclimInstant(point, 1, 1.2m)
    @test radiation(instant) == 1000W*m^-2
    @test snowdepth(instant) == 1.0m

    @test airtemperature(instant) == 24°C
    @test relhumidity(instant) == 0.5
    @test windspeed(instant) == 2m/s

    instant = MicroclimInstant(point, 2, 1.0m)
    @test soiltemperature(instant) |> °C == 5°C
    @test soilwaterpotential(instant) == -60.0kPa
    @test soilwatercontent(instant) == 0.5
end
