# Microclimate

[![Build Status](https://travis-ci.org/rafaqz/Microclimate.jl.svg?branch=master)](https://travis-ci.org/rafaqz/Microclimate.jl)
[![Coverage Status](https://coveralls.io/repos/rafaqz/Microclimate.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/rafaqz/Microclimate.jl?branch=master)
[![codecov.io](http://codecov.io/github/rafaqz/Microclimate.jl/coverage.svg?branch=master)](http://codecov.io/github/rafaqz/Microclimate.jl?branch=master)

This package downloads, loads and interpolates into the microclim datasets created with NicheMapR, like
[MicroclimOz](https://knb.ecoinformatics.org/view/urn%3Auuid%3Adad8bda1-df43-48e6-bfb1-c9f6e0a4cbaf).

Described in the paper by Michael Kearney: [MicroclimOz – A microclimate data set for Australia,
with example applications](https://doi.org/10.1111/aec.12689)

It is likely to be rewritten as a source for GeoData.jl (which was inspired by
writing this package in the first place). This will give more standard indexing
and behaviour and better tests.
