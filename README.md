
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pregnancy <a href="https://ellakaye.github.io/pregnancy/"><img src="man/figures/logo.png" align="right" height="137" alt="pregnancy website" /></a>

<!-- badges: start -->

[![R-CMD-check](https://github.com/EllaKaye/pregnancy/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/EllaKaye/pregnancy/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/EllaKaye/pregnancy/branch/main/graph/badge.svg)](https://app.codecov.io/gh/EllaKaye/pregnancy?branch=main)
<!-- badges: end -->

This is an R package for calculating dates and tracking medications
during pregnancy and fertility treatment. It extends a private, personal
package that I wrote for myself when I was pregnant. It contains
functions and features that I found useful at the time, and others that
I added when adapting the package for general use.

The functionality goes beyond what’s offered by online pregnancy
calculators and apps, plus there are no concerns(unlike with these sites
and apps) about data privacy, tracking or advertising.

> This R package is in the latter stages of development, with a view to
> release in early March 2025. The main functionality is now in place.
> Still to do: improved documentation, vignette(s), better test
> coverage, improve some of messages in some utils functions.

## Installation

You can install the development version of pregnancy from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes") 
remotes::install_github("EllaKaye/pregnancy") 
```

## Usage

This is a quick tour. For a more extensive guide, see the [Get
Started](https://ellakaye.github.io/pregnancy/articles/pregnancy.html)
vignette, `vignette("pregnancy")`.

``` r
library(pregnancy)
```

## Date calculations

The `calculate_due_date()` function estimates the pregnancy due date.
The `start_date` is interpreted differently, depending on the
`start_type`. By default, the `start_type` is the last menstrual period,
and the `start_date` is the date this started. Other `start_date`
options, like various transfer days, are useful for those using IVF.

``` r
# invisibly returns a Date object with the estimated due date
due_date <- calculate_due_date(as.Date("2024-12-10"))
#> ℹ Estimated due date: Tuesday, September 16, 2025
#> ℹ Estimated birth period begins: August 26, 2025 (37 weeks)
#> ℹ Estimated birth period ends: September 30, 2025 (42 weeks)
```

This README was built on **February 14, 2025**, so for the purposes of
reading this page, that counts as “today”.

``` r
how_far(due_date = due_date)
#> ℹ You are 9 weeks and 3 days pregnant.
#> ℹ That's 30 weeks and 4 days until the due date (September 16, 2025).
#> ℹ You are 24% through the pregnancy.
```

``` r

# alternative `on_date`, different subject
how_far(on_date = as.Date("2025-04-02"), due_date = as.Date("2025-09-16"), person = "Ruth")
#> ℹ On April 02, 2025, Ruth will be 16 weeks and 1 day pregnant.
```

``` r
date_when(28, due_date = due_date)
#> ℹ On June 24, 2025, you will be 28 weeks pregnant.
#> ℹ That's 18 weeks and 4 days away.
```

## Tracking medications

``` r
# a simplified medication schedule
meds <- dplyr::tribble(
  ~medication, ~format, ~quantity, ~start_date, ~stop_date,
  "progynova", "tablet", 3, as.Date("2025-04-21"), as.Date("2025-04-30"),
  "progynova", "tablet", 6, as.Date("2025-05-01"), as.Date("2025-07-11"),
  "cyclogest", "pessary", 2, as.Date("2025-05-03"), as.Date("2025-07-11"),
  "clexane", "injection", 1, as.Date("2025-05-08"), as.Date("2025-09-05")
  )
```

``` r
# how much of each medication is left to take, as of today
medications_remaining(meds)
#> # A tibble: 3 × 2
#>   medication quantity
#>   <chr>         <int>
#> 1 clexane         121
#> 2 cyclogest       140
#> 3 progynova       462
```

``` r
# how much medication for a given week (useful if you need to request a prescription)
medications_remaining(meds, on_date = as.Date("2025-04-23"), until_date = as.Date("2025-04-29"))
#> # A tibble: 1 × 2
#>   medication quantity
#>   <chr>         <int>
#> 1 progynova        21
```

## Global options

It would be very tedious to have to enter a due date every time you call
`how_far()` or `date_when()` over the course of a pregnancy, especially
since that date is constant throughout. Similarly for the medications
table in `medications_remaining()`. To avoid this, the pregnancy package
makes use of **global options**, which can be set with the `set_*`
family of functions (`set_due_date()`, `set_person()`,
`set_medications()`, and retrieved with the `get_*` family of functions.
Any global option can be unset by calling its `set_*` function with the
argument `NULL`.

``` r
set_due_date(due_date)
#> ✔ Due date set as September 16, 2025
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

Then `how_far()` can be called without needing to specify any arguments,
and `date_when()` only needs the target week:

``` r
how_far()
#> ℹ You are 9 weeks and 3 days pregnant.
#> ℹ That's 30 weeks and 4 days until the due date (September 16, 2025).
#> ℹ You are 24% through the pregnancy.
```

To check what the option is set to, use `get_due_date()`.

*Write this section!*

### Options in `.RProfile`

We recommend adding your options to your `.RProfile` so they persist
across R sessions. Here’s an example of what that might look like:

``` r
options(
  pregnancy.due_date = as.Date("2025-09-16"),
  pregnancy.person = "I", # addressed in first person
  pregnancy.medications = dplyr::tribble(
    ~medication, ~format, ~quantity, ~start_date, ~stop_date,
    "progynova", "tablet", 3, as.Date("2025-04-21"), as.Date("2025-04-30"),
    "progynova", "tablet", 6, as.Date("2025-05-01"), as.Date("2025-07-11"),
    "cyclogest", "pessary", 2, as.Date("2025-05-03"), as.Date("2025-07-11"),
    "clexane", "injection", 1, as.Date("2025-05-08"), as.Date("2025-09-05")
  )
)
```

## Documentation

See package website at <https://ellakaye.github.io/pregnancy> and also
in the installed package: `help(package = "pregnancy")`.
