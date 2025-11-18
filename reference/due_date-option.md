# Set or get the `pregnancy.due_date` option

Functions to get and set the default due date used throughout the
package. This affects calculations in various functions that determine
pregnancy progress and timing. Settings persist for the current R
session only, unless added to .Rprofile. `set_due_date()` sets the
"pregnancy.due_date" option and `get_due_date()` retrieves it.

## Usage

``` r
set_due_date(due_date)

get_due_date()
```

## Arguments

- due_date:

  A Date or character string representing a date, e.g. "YYYY-MM-DD",
  specifying the estimated due date, or NULL to unset the option.

## Value

Both functions invisibly return the current due date setting:

- get_due_date() returns the current setting (a Date object) or NULL if
  not set

- set_due_date() returns the due date value that was set

## See also

- [`calculate_due_date()`](https://ellakaye.github.io/pregnancy/reference/calculate_due_date.md)
  to calculate a due date based on other dates

- [`how_far()`](https://ellakaye.github.io/pregnancy/reference/how_far.md)
  and other functions that use the due date for calculations

## Examples

``` r
# Store original setting (without messages)
original_due_date <- getOption("pregnancy.due_date")

# Check current setting
get_due_date()
#> ! You do not have `pregnancy.due_date` set as an option.
#> ℹ You can set it with `set_due_date()`.
#> ℹ You can also pass a value directly to the `due_date` argument where required.

# Set due date and check again
set_due_date("2025-09-15")
#> ✔ Due date set as September 15, 2025
#> ℹ Functions in the pregnancy package will now use this `due_date` option.
#> ℹ So, for this R session, you do not need to supply a value to the `due_date`
#>   argument (unless you wish to override the option).
#> ℹ To make this `due_date` option available in all R sessions, in your
#>   ".Rprofile", set `options(pregnancy.due_date = ...)`
#>   where ... is the value of `due_date`.
#> ℹ You can edit your ".Rprofile" by calling `usethis::edit_r_profile()`
#> ℹ You can retrieve the `due_date` option with `get_due_date()`,
#>   or with `getOption('pregnancy.due_date')`.
get_due_date()
#> ℹ Your due date is set as September 15, 2025.

# Restore original setting (without messages)
options(pregnancy.due_date = original_due_date)
```
