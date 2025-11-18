# Set or get the `pregnancy.medications` option

Functions to get and set the default medications data frame used in the
[`medications_remaining()`](https://ellakaye.github.io/pregnancy/reference/medications_remaining.md)
function. Settings persist for the current R session only, unless added
to .Rprofile. `set_medications()` sets the "pregnancy.medications"
option and `get_medications()` retrieves it.

## Usage

``` r
set_medications(meds)

get_medications()
```

## Arguments

- meds:

  Data frame containing medication schedule. Must have the following
  columns:

  - medication (character/factor): Name of the medication

  - format (character/factor): Format of the medication (e.g., pill,
    injection)

  - quantity (numeric): Number of units to take per day

  - start_date (Date or character string representing a date, e.g.
    "YYYY-MM-DD"): Date to start taking the medication

  - stop_date (Date or character string representing a date, e.g.
    "YYYY-MM-DD"): Final date on which the medication is taken

  If NULL, will try to use the "pregnancy.medications" option. Required
  if option not set.

## Value

Both functions invisibly return the current medications setting:

- `get_medications()` returns the current setting (a data frame) or NULL
  if not set

- `set_medications()` returns the medications data frame that was set

## See also

- [`medications_remaining()`](https://ellakaye.github.io/pregnancy/reference/medications_remaining.md),
  [medications](https://ellakaye.github.io/pregnancy/reference/medications.md)

## Examples

``` r
# Store original setting (without messages)
original_medications <- getOption("pregnancy.medications")

# Set the option
set_medications(pregnancy::medications)
#> ✔ medications set.
#> ℹ Functions in the pregnancy package will now use this `medications` option.
#> ℹ So, for this R session, you do not need to supply a value to the
#>   `medications` argument (unless you wish to override the option).
#> ℹ To make this `medications` option available in all R sessions, in your
#>   ".Rprofile", set `options(pregnancy.medications = ...)`
#>   where ... is the value of `medications`.
#> ℹ You can edit your ".Rprofile" by calling `usethis::edit_r_profile()`
#> ℹ You can retrieve the `medications` option with `get_medications()`,
#>   or with `getOption('pregnancy.medications')`.

# Get the option
get_medications()
#> Your medications table is set as
#> # A tibble: 14 × 5
#>    medication   format    quantity start_date stop_date 
#>    <chr>        <chr>        <dbl> <date>     <date>    
#>  1 progynova    tablet           3 2025-07-21 2025-07-30
#>  2 LDA          tablet           1 2025-07-21 2025-08-07
#>  3 prednisolone tablet           2 2025-07-26 2025-08-07
#>  4 progynova    tablet           6 2025-08-01 2025-10-11
#>  5 cyclogest    pessary          2 2025-08-03 2025-10-11
#>  6 lubion       injection        1 2025-08-03 2025-10-11
#>  7 clexane      injection        1 2025-08-08 2025-12-05
#>  8 prednisolone tablet           4 2025-08-08 2025-10-11
#>  9 prednisolone tablet           3 2025-10-12 2025-10-14
#> 10 prednisolone tablet           2 2025-10-15 2025-10-17
#> 11 prednisolone tablet           1 2025-10-18 2025-10-20
#> 12 prednisolone tablet           1 2025-10-22 2025-10-22
#> 13 prednisolone tablet           1 2025-10-24 2025-10-24
#> 14 prednisolone tablet           1 2025-10-26 2025-10-26

# Restore original setting (without messages)
options(pregnancy.medications = original_medications)
```
