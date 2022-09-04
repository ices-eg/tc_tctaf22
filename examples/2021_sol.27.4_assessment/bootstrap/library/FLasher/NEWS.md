# FLasher 0.6.7

## BUG FIXES

- Ensure max effort input in .Call is numeric.
- Changed tolerance in solver to match all.equal's default: 1.5e-8.
- Getting different spawn seasons to work.
- Setting to zero rec in seasons < spawn.season.
- Fix to discards ratio when discards.n is zero.
- Bug in coertion of FLQuants with iters to fwdControl.
- Add na.rm argument for discard ratio in stf().
- sratio now properly applied for either 1 or 2 sex models in bevholtss3.

# FLasher 0.6.6

## USER-VISIBLE CHANGES

- Minimum value for 'f' or 'fbar' targets has been set at
  sqrt(.Machine$double.eps) ~ 1.5e-08.
- Added sr as FLQuant argument to fwd(FLStock). The vector by year is converted
  into a predictModel with rec~a and a yearly value for a.

## BUG FIXES

- Separation of large Jacobian matrix in solver.cpp was operating as in iters
  were organized target first, but they are iter first.
- Ensure subset of deviances returns an FLQuants.
- solver.cpp update to work properly with biols and fisheries with multiple
  iterations.
- Bug in coertion of FLQuants with iters to fwdControl.

## NEW FEATURES

- FCB(FLBiols, FLFisheries) method class guessfcb and fcb2nit to return a guess
  for FCB.
- stf(FLStocks) simply calls lapply, uses same settings on all elements.
- partialF method returns the partial Fs by fleet for each FLBiol. 

# FLasher 0.6.1

## NEW FEATURES

- fwdControl(FLQuant) also accepts extra target arguments (e.g. relYear).
# FLasher 0.6.0

## NEW FEATURES

- compare() method draws a comparison between targets in a fwdControl
  object and the results returned. Available for FLStock at this moment.
- maxF argument to fwd(FLStock) is implemented through an additional target
  per timestep with max(fbar) = maxF, rather than by an indirect limit of
  the effort calculation. It bis not applied for steps with an f/fbar
  target.
- Functions are now available for the corresponding ssb and biomass targets
  used by fwdControl: ssb_end, biomass_end and biomass_spawn

## BUG FIXES

- Calculation of survivors for stocks/biols with age=0 was not correct.

# FLasher 0.5.0

## NEW FEATURES

- effort_max argument to fwd() set a maximum valuw for effort. Similar to FLash::maxF, as scale of effort values in fwd(FLStock) is set by fbar.
- Certain slots in FLStock are checked for NAs in year before projection to avoid R crashing.
- New stock-recruitment relationship added, survsrr, for low fecundity species (Taylor et al, 2013).
- Projections are now correct for multiple units, either sex or birth seasons.

## USER-VISIBLE CHANGES

- The residuals argument to fwd() is now called 'deviances', and this name is used in all R and C++ code. 'residuals' is still accepted, but will be deprecated in the next minor version.

## BUG FIXES

- SRR predictions now work correctly for 2-sex OMs (FLStock or FLBiol).
- Check for fwdControl rows not being all NA.

# FLasher 0.0.4

## NEW FEATURES

- plot(FLStock, fwdControl) will add to the ggplotFL plot of an FLStock a
  coloured area of the years being projected.

## BUG FIXES

- fwd(FLStock) now returns one more year if quant='ssb_flash' and object has space for it.

## USER-VISIBLE CHANGES

- Added disc.nyears arg to stf() to select years to use for discards ratio calculations.
- If min and max for the very same target are set in separate rows, they are merged.

# FLasher 0.0.3

## BUG FIXES

- Fixed stupid intermittant bug in projection test
- Added stf to Namespace
- Fixed bug setting relMinAge etc and added simple projection tests
- Fixed coerce FLQuant to fwdControl with iters

## DOCUMENTATION

- Edits to mixed fishery vignette and new introductory vignette
