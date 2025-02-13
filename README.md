
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pregnancy <a href="https://ellakaye.github.io/pregnancy/"><img src="man/figures/logo.png" align="right" height="137" alt="pregnancy website" /></a>

<!-- badges: start -->

[![R-CMD-check](https://github.com/EllaKaye/pregnancy/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/EllaKaye/pregnancy/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/EllaKaye/pregnancy/branch/main/graph/badge.svg)](https://app.codecov.io/gh/EllaKaye/pregnancy?branch=main)
<!-- badges: end -->

This is a work-in-progress R package for calculating dates and tracking
medications during pregnancy and fertility treatment. It extends a
private, personal package that I wrote for myself when I was pregnant,
It contains functions and features that I found useful at the time, and
others that I added when adapting the package for general use.

> This R package is in the latter stages of development, with a view to
> release by mid-March 2025. The main functionality is now in place.
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
due_date <- calculate_due_date(as.Date("2024-12-10"))
#> ℹ Estimated due date: Tuesday, September 16, 2025
#> ℹ Estimated birth period begins: August 26, 2025 (37 weeks)
#> ℹ Estimated birth period ends: September 30, 2025 (42 weeks)
```

Once a due date is know, the `how_far()` function tells you how far into
the pregnancy you are on a given date. It defaults to providing this
information for the current date, but an alternative `on_date` can be
provided. This README was built on **February 13, 2025**, so for the
purposes of reading this page, that counts as “today”.

``` r
how_far(due_date = due_date)
#> ℹ You are 9 weeks and 2 days pregnant.
#> ℹ That's 30 weeks and 5 days until the due date (September 16, 2025).
#> ℹ You are 23% through the pregnancy.
```

``` r
how_far(on_date = as.Date("2025-04-02"), due_date = due_date)
#> ℹ On April 02, 2025, you will be 16 weeks and 1 day pregnant.
```

The `date_when()` function gives the date when a certain week of
pregnancy will (or was) reached, and the duration of that date from
today:

``` r
date_when(28, due_date = due_date)
#> ℹ On June 24, 2025, you will be 28 weeks pregnant.
#> ℹ That's 18 weeks and 5 days away.
```

By default, the output messages are in the second person, i.e. addressed
to “you”, but there is also an option to specify another person. A value
of `1` or `"I"` means you’ll be addressed in the first person:

``` r
how_far(due_date = due_date, person = 1)
#> ℹ I am 9 weeks and 2 days pregnant.
#> ℹ That's 30 weeks and 5 days until the due date (September 16, 2025).
#> ℹ I am 23% through the pregnancy.
```

Any other character string will be interpreted as a third-person name,
which is useful, for example, if you’re following the pregnancy progress
of a partner.

``` r
date_when(6, due_date = due_date, person = "Ruth")
#> ℹ On January 21, 2025, Ruth was 6 weeks pregnant.
#> ℹ That was 3 weeks and 2 days ago.
```

## Tracking medications

*Write this section!*

## Global options

It would be very tedious to have to enter a due date every time you call
`how_far()` or `date_when()` over the course of a pregnancy, especially
since that date is constant throughout. Similarly for the medications
table in `medications_remaining()`. To avoid this, the pregnancy package
makes use of **global options**, which can be set with the `set_*`
family of functions, retrieved with the `get_*` family of functions. Any
global option can be unset by calling its `set_*` function with the
argument `NULL`.

### `pregnancy.due_date`

You can set the `pregnancy.due_date` option using the `set_due_date()`
function. When that option is set, if the `due_date` argument to
`how_far()` or `date_when()` is `NULL` (the default), that option is
retrieved.

`set_due_date()` only sets the due date for the current R session. To
make this option persist (recommended), it can be added to your
`.RProfile`. The console output of `set_due_date()` provides guidance on
how to do this.

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
#> ℹ You are 9 weeks and 2 days pregnant.
#> ℹ That's 30 weeks and 5 days until the due date (September 16, 2025).
#> ℹ You are 23% through the pregnancy.
```

To check what the option is set to, use `get_due_date()`.

### `pregnancy.person`

`set_person()` sets the global option `pregnancy.person`. If this option
is set it will be retrieved to specify the value of `person` in
`how_far()` and `date_when()`, unless it is overriden by passing another
value directly to the `person` argument. If the option is not set, the
default second-person will be used.

``` r
set_person(1)
#> ✔ person set as 'I'
#> ℹ Functions in the pregnancy package will now use this `person` option.
#> ℹ So, for this R session, you do not need to supply a value to the `person`
#>   argument (unless you wish to override the option).
#> ℹ To make this `person` option available in all R sessions, in your
#>   ".Rprofile", set `options(pregnancy.person = ...)`
#>   where ... is the value of `person`.
#> ℹ You can edit your ".Rprofile" by calling `usethis::edit_r_profile()`
#> ℹ You can retrieve the `person` option with `get_person()`,
#>   or with `getOption('pregnancy.person')`.
```

``` r
how_far()
#> ℹ I am 9 weeks and 2 days pregnant.
#> ℹ That's 30 weeks and 5 days until the due date (September 16, 2025).
#> ℹ I am 23% through the pregnancy.
```

``` r
set_person(NULL) # TODO: update output to reflect that option has been unset
#> ✔ person set as ''
#> ℹ Functions in the pregnancy package will now use this `person` option.
#> ℹ So, for this R session, you do not need to supply a value to the `person`
#>   argument (unless you wish to override the option).
#> ℹ To make this `person` option available in all R sessions, in your
#>   ".Rprofile", set `options(pregnancy.person = ...)`
#>   where ... is the value of `person`.
#> ℹ You can edit your ".Rprofile" by calling `usethis::edit_r_profile()`
#> ℹ You can retrieve the `person` option with `get_person()`,
#>   or with `getOption('pregnancy.person')`.
```

``` r
how_far()
#> ℹ You are 9 weeks and 2 days pregnant.
#> ℹ That's 30 weeks and 5 days until the due date (September 16, 2025).
#> ℹ You are 23% through the pregnancy.
```

### `pregnancy.medications`

*Write this section!*

### An example `.RProfile`

Taking the advice to specify the options in your `.RProfile`, here’s an
example of what you might include in that file:

``` r
# TODO
```
