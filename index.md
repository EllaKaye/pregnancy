# pregnancy

This is an R package for calculating dates and tracking medications
during pregnancy and fertility treatment. It extends a private, personal
package that I wrote for myself when I was pregnant. It contains
functions and features that I found useful at the time, and others that
I added when adapting the package for general use.

The functionality goes beyond what’s offered by online pregnancy
calculators and apps, plus there are no concerns (unlike with these
sites and apps) about data privacy, tracking or advertising.

## Installation

**pregnancy** is available on CRAN:

``` r
install.packages("pregnancy")
```

You can install the development version from R-universe:

``` r
install.packages("pregnancy", repos = "https://ellakaye.r-universe.dev")
```

Alternatively, install the development version from
[GitHub](https://github.com/EllaKaye/pregnancy) with:

``` r
pak::pak("EllaKaye/pregnancy") 
```

## Usage

This is a quick tour. For a more extensive guide, see the [Get
Started](https://ellakaye.github.io/pregnancy/articles/pregnancy.html)
vignette.

``` r
library(pregnancy)
```

## A note on dates

To easily keep this document fairly up-to-date, and prevent recurring
package build and CRAN failures as time goes by, I have not hard-coded
any dates. Instead, I have calculated everything from the date on which
this README was last built. That was on **November 18, 2025**, so for
the purposes of reading this page, that counts as “today”.

## Date calculations

``` r
# for purpose of README, calculate `start_date` relative to "today"
today <- Sys.Date()
start_date <- today - 192

# invisibly returns a Date object with the estimated due date
# by default, start date of last menstrual period, but other options available
# in practice, the start_date argument will be a known date, e.g. "2025-05-29"
due_date <- calculate_due_date(start_date)
#> ℹ Estimated due date: Saturday, February 14, 2026
#> ℹ Estimated birth period begins: January 24, 2026 (37 weeks)
#> ℹ Estimated birth period ends: February 28, 2026 (42 weeks)
```

``` r
# set the pregnancy.due_date option
# avoids having to pass the due date as argument to other functions
set_due_date(due_date)
#> ✔ Due date set as February 14, 2026
#> ℹ Functions in the pregnancy package will now use this `due_date` option.
#> ℹ So, for this R session, you do not need to supply a value to the `due_date`
#>   argument (unless you wish to override the option).
#> ℹ To make this `due_date` option available in all R sessions, in your
#>   ".Rprofile", set `options(pregnancy.due_date = ...)`
#>   where ... is the value of `due_date`.
#> ℹ You can edit your ".Rprofile" by calling `usethis::edit_r_profile()`
#> ℹ You can retrieve the `due_date` option with `get_due_date()`,
#>   or with `getOption('pregnancy.due_date')`.
```

``` r
# don't need to specify `due_date` since option is set
# invisibly returns number of days into the pregnancy
how_far()
#> ℹ You are 27 weeks and 3 days pregnant.
#> ℹ That's 12 weeks and 4 days until the due date (February 14, 2026).
#> ℹ You are 69% through the pregnancy.
```

``` r
# alternative `on_date`, addressed as "I"
# usually `on_date` will be a fixed date, but given here relative to "today"
how_far(on_date = today + 1, person = 1)
#> ℹ On November 19, 2025, I will be 27 weeks and 4 days pregnant.
```

``` r
# when a given week of the pregnancy is reached
# invisibly returns the Date when that week is reached
date_when(33)
#> ℹ On December 27, 2025, you will be 33 weeks pregnant.
#> ℹ That's 5 weeks and 4 days away.
```

## Tracking medications

``` r
# a simplified medication schedule
meds <- pregnancy:::update_meds_table(pregnancy::medications_simple)
meds
#> # A tibble: 4 × 5
#>   medication format    quantity start_date stop_date 
#>   <chr>      <chr>        <dbl> <date>     <date>    
#> 1 progynova  tablet           3 2025-11-04 2025-11-14
#> 2 progynova  tablet           6 2025-11-15 2025-11-25
#> 3 cyclogest  pessary          2 2025-11-17 2025-11-25
#> 4 clexane    injection        1 2025-11-22 2026-01-19
```

``` r
# how much of each medication is left to take, as of "today"
medications_remaining(meds)
#> # A tibble: 3 × 2
#>   medication quantity
#>   <chr>         <int>
#> 1 clexane          59
#> 2 cyclogest        16
#> 3 progynova        48
```

``` r
# how much medication for a given week 
# (useful if you need to request a prescription to cover a certain time period)
medications_remaining(meds, on_date = today + 3, until_date = today + 10)
#> # A tibble: 3 × 2
#>   medication quantity
#>   <chr>         <int>
#> 1 clexane           7
#> 2 cyclogest        10
#> 3 progynova        30
```

## Global options

[`how_far()`](https://ellakaye.github.io/pregnancy/reference/how_far.md)
and
[`date_when()`](https://ellakaye.github.io/pregnancy/reference/date_when.md)
both need to know the pregnancy due date, and this can be passed
directly to the `due_date` argument. It would be very tedious, however,
to have to enter a due date every time you call these functions over the
course of a pregnancy, especially since that date is constant
throughout. The same holds for the for medications table required for
[`medications_remaining()`](https://ellakaye.github.io/pregnancy/reference/medications_remaining.md).

To avoid this, the pregnancy package makes use of **global options**,
which can be set with the `set_*` family of functions
([`set_due_date()`](https://ellakaye.github.io/pregnancy/reference/due_date-option.md),
[`set_person()`](https://ellakaye.github.io/pregnancy/reference/person.md),
[`set_medications()`](https://ellakaye.github.io/pregnancy/reference/medications-option.md)),
and retrieved with the corresponding `get_*` family of functions
([`get_due_date()`](https://ellakaye.github.io/pregnancy/reference/due_date-option.md),
[`get_person()`](https://ellakaye.github.io/pregnancy/reference/person.md),
[`get_medications()`](https://ellakaye.github.io/pregnancy/reference/medications-option.md)).
These options will persist for the duration of the current R session.

Any global option can be unset by calling its `set_*` function with the
argument `NULL`.

``` r
# a different due date from the earlier example
new_due_date <- today + 180
set_due_date(new_due_date)
#> ✔ Due date set as May 17, 2026
#> ℹ Functions in the pregnancy package will now use this `due_date` option.
#> ℹ So, for this R session, you do not need to supply a value to the `due_date`
#>   argument (unless you wish to override the option).
#> ℹ To make this `due_date` option available in all R sessions, in your
#>   ".Rprofile", set `options(pregnancy.due_date = ...)`
#>   where ... is the value of `due_date`.
#> ℹ You can edit your ".Rprofile" by calling `usethis::edit_r_profile()`
#> ℹ You can retrieve the `due_date` option with `get_due_date()`,
#>   or with `getOption('pregnancy.due_date')`.
```

``` r
how_far()
#> ℹ You are 14 weeks and 2 days pregnant.
#> ℹ That's 25 weeks and 5 days until the due date (May 17, 2026).
#> ℹ You are 36% through the pregnancy.
```

``` r
# check and then unset option
get_due_date()
#> ℹ Your due date is set as May 17, 2026.
set_due_date(NULL)
#> ✔ pregnancy.due_date option set to NULL.
#> ℹ You will need to explicitly pass a value to the `due_date` argument
#>   in functions that use it, or reset the option with `set_due_date()`.
```

### Options in `.Rprofile`

We recommend adding your options to your `.Rprofile` so they persist
across R sessions. R will read in these options at the start of each
session, and you will not need to use the `set_*` family of functions,
nor pass them as arguments to the package functions. The `get_*` family
of functions will still retrieve the options set in `.Rprofile`.

Here’s an example of what that might look like:

``` r
options(
  pregnancy.due_date = "2025-09-16",
  pregnancy.person = "I", # addressed in first person
  pregnancy.medications = tibble::tribble(
  ~medication, ~format, ~quantity, ~start_date, ~stop_date,
  "progynova", "tablet", 3, "2025-08-21", "2025-08-31",
  "progynova", "tablet", 6, "2025-09-01", "2025-09-11",
  "cyclogest", "pessary", 2, "2025-09-03", "2025-09-11",
  "clexane", "injection", 1, "2025-09-08", "2025-11-05"
  ) 
)
```

Note that it is best to avoid creating R objects in your `.Rprofile`,
e.g. a `medications` data frame outside of the call to
[`options()`](https://rdrr.io/r/base/options.html), otherwise that
object will be loaded into your global environment at the start of every
R session.

## Documentation

See package website at <https://ellakaye.github.io/pregnancy/> and also
in the installed package:
[`help(package = "pregnancy")`](https://ellakaye.github.io/pregnancy/reference).
