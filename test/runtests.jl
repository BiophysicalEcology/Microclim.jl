module MicroclimateTests

using Microclimate, Unitful, Test
using Microclimate: range_interpolator, increment_interpolator, layer_prop, max_height, layer_size, interp_layer
using Unitful: W, m, °C, K, s, g, L, kPa

rad = [10000.0, 9000.0]
snow = [10.0, 9.0]
airt = ([250.0, 240.0], [300.0, 290.0])
ws = ([10.0, 20.0], [30.0, 40.0])
rh = ([700.0, 500.0], [800.0, 600.0])
soilt = ([200.0, 190.0], [180.0,170.0], [160.0,150.0], [140.0,130.0], 
         [120.0,110.0], [100.0,90.0], [80.0,70.0], [60.0,50.0])
soilwp = ([-1000.0, -900.0], [-1200.0, -800.0], [-1100.0, -700.0], [-1300.0, -600.0], 
          [-1000.0, -900.0], [-1200.0, -800.0], [-1100.0, -700.0], [-1300.0, -600.0])
soilwc = ([200.0, 400.0], [300.0, 500.0], [200.0, 400.0], [300.0, 500.0], 
          [200.0, 400.0], [300.0, 500.0], [200.0, 400.0], [300.0, 500.0])


@testset "MicroclimPoint" begin
    env = MicroclimPoint(rad, snow, airt, rh, ws, soilt, soilwp, soilwc)
    half = (1.2m - 0.01m) / 2 + 0.01m
    typeof(env)

    windspeed(env)
    °C.(soiltemperature(env))

    @test radiation(env, range_interpolator(1.2m), 1) == 1000.0W*m^-2
    @test snowdepth(env, range_interpolator(1.2m), 1) == 1m

    @testset "ranges interpolate" begin
        @test airtemperature(env, range_interpolator(0.01m), 1) |> °C == 25.0°C
        @test airtemperature(env, range_interpolator(half), 1) |> °C == 27.5°C 
        @test airtemperature(env, range_interpolator(1.2m), 1) |> °C == 30.0°C
        @test windspeed(env, range_interpolator(1.2m), 2) == 4.0m*s^-1
        @test relhumidity(env, range_interpolator(1.2m), 2) == 0.6
    end

    @testset "increments interpolate" begin
        @test soiltemperature(env, increment_interpolator(0.0m), 1) |> °C == 20.0°C
        @test soiltemperature(env, increment_interpolator(0.075m), 1) |> °C == 15.0°C
        @test soiltemperature(env, increment_interpolator(0.1m), 2) |> °C == 13.0°C
        @test soiltemperature(env, increment_interpolator(0.40m), 1) |> °C == 9.0°C
        @test soiltemperature(env, increment_interpolator(0.5m), 1) |> °C == 8.0°C
        @test soiltemperature(env, increment_interpolator(1.0m), 2) |> °C == 5.0°C

        @test soilwaterpotential(env, increment_interpolator(0.0m), 1) == -1000kPa
        @test soilwatercontent(env, increment_interpolator(0.0m), 2) == 0.4
    end

    @testset "float indices are linearly interpolated in the time dimension" begin
        @test windspeed(env, range_interpolator(1.2m), 1.5) == 3.5m*s^-1
        @test relhumidity(env, range_interpolator(1.2m), 1.5) == 0.7
        @test relhumidity(env, range_interpolator(half), 1.5) == 0.65
    end

    @testset "handles heights larger than avbailable" begin
        @test soiltemperature(env, increment_interpolator(2.0m), 1) == 6.0°C |> K
        @test airtemperature(env, range_interpolator(2.0m), 1) == 30.0°C |> K
    end

    @testset "weighted mean" begin
        @test weightedmean(soilwatercontent(env), 0.0125m, 1) ≈ 0.2
        mid = sum([0.2, 0.3, 0.2, 0.3] .* (layer_size[1:4] ./ 0.15m))
        @test weightedmean(soilwatercontent(env), 0.15m, 1) == mid
        max = sum([0.2, 0.3, 0.2, 0.3, 0.2, 0.3, 0.2, 0.3] .* layer_prop)
        @test weightedmean(soilwatercontent(env), 1.5m, 1) == max
        @test weightedmean(soilwatercontent(env), 2.0m, 1) == max

        @test mean_soilwatercontent(env, 1.5m, 1) == max
        mean_soilwaterpotential(env, 1.5m, 1)
        mean_soiltemperature(env, 1.5m, 1)
    end

    @testset "max" begin
        @test layermax(soiltemperature(env), increment_interpolator(2.0m), 1) == 20.0°C |> K
    end

end

@testset "MicroclimInstant" begin
    point = MicroclimPoint(rad, snow, airt, rh, ws, soilt, soilwp, soilwc)

    instant = MicroclimInstant(point, 1.2m, 1)
    @test radiation(instant) == 1000W*m^-2
    @test snowdepth(instant) == 1.0m

    @test airtemperature(instant) |> °C == 30°C
    @test relhumidity(instant) == 0.8
    @test windspeed(instant) == 3m/s

    instant = MicroclimInstant(point, 1.0m, 2)
    @test soiltemperature(instant) |> °C == 5°C
    @test soilwaterpotential(instant) == -600.0kPa
    @test soilwatercontent(instant) == 0.5
end

end
