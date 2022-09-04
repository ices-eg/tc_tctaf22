
# FLFishery 0.3.6

## BUG FIXES

- Fix to effort in coercion of FLStock to FLFishery

# FLFishery 0.3.5

## NEW FEATURES

- plot(FLIndices) show the catch and effort series by fishery and catch.

# FLFishery 0.1.6

## NEW FEATURES

- New .travis.yml file deploys OSX package

## BUG FIXES

- Coerced FLFishery from FLStock now has correct hperiod.
- Improved coertion FLStock to FLFishery, effort series now calculated as harvest/catch.sel

# FLFishery 0.1.3

## NEW FEATURES

- harvest(FLBiol, FLFishery/FLFisheries) methods have been added.

## USER-VISIBLE CHANGES

- coerce(FLStock) to FLFishery calculates effort as the mean across the minfbasr:maxfbar range of the ratio between F and catch.q.
