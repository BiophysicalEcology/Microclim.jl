module MicroclimateTests

using Microclimate, Unitful, Test
using Microclimate: lin_interp_range, lin_interp_increment, layer_prop, max_height, layer_size
using Unitful: W, m, °C, K, s, g, L, kPa

rad = [10000, 9000]
snow = [10, 9]
airt = ([250], [300])
ws = ([20, 30], [30, 40])
rh = ([700, 500], [800, 600])
soilt = ([200,190], [180,170], [160,150], [140,130], [120,110], [100,90], [80,70], [60,50])
soilwp = ([-1000.0], [-2000])
soilwc = ([200, 400], [300, 500], [200, 400], [300, 500], [200, 400], [300, 500], [200, 400], [300, 500])


@testset "ranges" begin
    h = (1.2m - 0.01m) / 2 + 0.01m
    interp = lin_interp_range(h)

    @test interp == LinearLayerInterpolator(2, 0.5)

    @test interp_layer(interp, ws, 1) == 25
    @test interp_layer(interp, ws, 2) == 35
    @test interp_layer(interp, airt, 1) == 275.0

end

@testset "increments" begin
    h = 0.075m
    interp = lin_interp_increment(h)
    @test interp.layer == 4
    @test interp.frac ≈ 0.5

    @test interp_layer(interp, soilt, 1) == 150
end


@testset "MicroclimPoint" begin
    env = MicroclimPoint(rad, snow, airt, rh, ws, soilt, soilwp, soilwc)
    half = (1.2m - 0.01m) / 2 + 0.01m

    @test radiation(env, lin_interp_range(1.2m), 1) == 1000.0W*m^-2
    @test_broken snowdepth(env, lin_interp_range(1.2m), 1) == 1m

    @testset "ranges interpolate" begin
        @test airtemperature(env, lin_interp_range(0.01m), 1) == 25.0°C |> K
        @test airtemperature(env, lin_interp_range(half), 1) == 27.5°C |> K
        @test airtemperature(env, lin_interp_range(1.2m), 1) == 30.0°C |> K
        @test windspeed(env, lin_interp_range(1.2m), 2) == 4.0m*s^-1
        @test relhumidity(env, lin_interp_range(1.2m), 2) == 0.6
    end

    @testset "increments interpolate" begin
        @test soiltemperature(env, lin_interp_increment(0.0m), 1) == 20.0°C |> K
        @test soiltemperature(env, lin_interp_increment(0.075m), 1) == 15.0°C |> K
        @test soiltemperature(env, lin_interp_increment(0.1m), 2) == 13.0°C |> K
        @test soiltemperature(env, lin_interp_increment(0.40m), 1) == 9.0°C |> K
        @test soiltemperature(env, lin_interp_increment(0.5m), 1) == 8.0°C |> K
        @test soiltemperature(env, lin_interp_increment(1.0m), 2) == 5.0°C |> K

        @test soilwaterpotential(env, lin_interp_increment(0.0m), 1) == -1000kPa
        @test soilwatercontent(env, lin_interp_increment(0.0m), 2) == 0.4
    end

    @testset "float indices are linearly interpolated in the time dimension" begin
        @test windspeed(env, lin_interp_range(1.2m), 1.5) == 3.5m*s^-1
        @test relhumidity(env, lin_interp_range(1.2m), 1.5) == 0.7
        @test relhumidity(env, lin_interp_range(half), 1.5) == 0.65
    end

    @testset "handles heights larger than avbailable" begin
        @test soiltemperature(env, lin_interp_increment(2.0m), 1) == 6.0°C |> K
        @test airtemperature(env, lin_interp_range(2.0m), 1) == 30.0°C |> K
    end

    @testset "weighted mean" begin
        @test weightedmean(soilwatercontent(env), 0.0125m, 1) ≈ 0.2
        mid = sum([0.2, 0.3, 0.2, 0.3] .* (layer_size[1:4] ./ 0.15m))
        @test weightedmean(soilwatercontent(env), 0.15m, 1) == mid
        max = sum([0.2, 0.3, 0.2, 0.3, 0.2, 0.3, 0.2, 0.3] .* layer_prop)
        @test weightedmean(soilwatercontent(env), 1.5m, 1) == max
        @test weightedmean(soilwatercontent(env), 2.0m, 1) == max
    end
    @testset "max" begin
        @test layermax(soiltemperature(env), lin_interp_increment(2.0m), 1) == 20.0°C |> K
    end
end

end
