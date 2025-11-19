# Calculate pregnancy progress and time remaining

Calculates and displays how far along a pregnancy is on a specific date,
including weeks pregnant, days remaining until due date, and overall
progress percentage.

## Usage

``` r
how_far(on_date = Sys.Date(), due_date = NULL, person = NULL)
```

## Arguments

- on_date:

  Date or character string representing a date, e.g. "YYYY-MM-DD". The
  date for which to calculate pregnancy progress. Defaults to current
  system date.

- due_date:

  Date or character string representing a date, e.g. "YYYY-MM-DD". The
  expected due date. If NULL, will try to use the "pregnancy.due_date"
  option. Required if option not set.

- person:

  The person who is pregnant, to determine the grammar for the output
  message. Can be:

  - "I", "1", "1st", "first", or numeric `1` for first person

  - "you", "2", "2nd", "second", or numeric `2` for second person

  - Any other name for third person

  - `NULL`: will try to use the "pregnancy.person" option. Defaults to
    "You" if the option is set.

## Value

Invisibly returns the number of days along in the pregnancy. Prints a
formatted message to the console with pregnancy progress information.

## Details

The function assumes a standard pregnancy length of 280 days (40 weeks)
when calculating progress. It handles past, present, and future dates
appropriately by adjusting message grammar. If the calculation shows
more than 42 weeks of pregnancy, a different message is displayed noting
this unusual duration.

The function uses the [cli](https://cli.r-lib.org) package for formatted
message output and supports proper pluralization of weeks/days in
messages.

If `on_date` or `due_date` are character strings, the conversion to a
`Date` is handled by
[`anytime::anydate()`](https://rdrr.io/pkg/anytime/man/anytime.html).

## Global Options

- pregnancy.due_date: Date object setting default due date

- pregnancy.person: Character string setting default person

## See also

[`set_due_date()`](https://ellakaye.github.io/pregnancy/reference/due_date-option.md),
[`set_person()`](https://ellakaye.github.io/pregnancy/reference/person.md)

## Examples

``` r
# Current progress with explicit due date
# Note that output will depend on date the function is run
how_far(due_date = "2025-12-01")
#> ℹ You are 38 weeks and 2 days pregnant.
#> ℹ That's 1 week and 5 days until the due date (December 01, 2025).
#> ℹ You are 96% through the pregnancy.

# Progress on a specific date
how_far(on_date = "2025-11-01", due_date = "2025-12-01")
#> ℹ On November 01, 2025, you were 35 weeks and 5 days pregnant.

# With custom person
how_far(on_date = "2025-11-01", due_date = "2025-12-01", person = "Sarah")
#> ℹ On November 01, 2025, Sarah was 35 weeks and 5 days pregnant.

# Set global options
date_opt <- getOption("pregnancy.due_date") # save current option
set_due_date("2025-12-01")
#> ✔ Due date set as December 01, 2025
#> ℹ Functions in the pregnancy package will now use this `due_date` option.
#> ℹ So, for this R session, you do not need to supply a value to the `due_date`
#>   argument (unless you wish to override the option).
#> ℹ To make this `due_date` option available in all R sessions, in your
#>   ".Rprofile", set `options(pregnancy.due_date = ...)`
#>   where ... is the value of `due_date`.
#> ℹ You can edit your ".Rprofile" by calling `usethis::edit_r_profile()`
#> ℹ You can retrieve the `due_date` option with `get_due_date()`,
#>   or with `getOption('pregnancy.due_date')`.
how_far()
#> ℹ You are 38 weeks and 2 days pregnant.
#> ℹ That's 1 week and 5 days until the due date (December 01, 2025).
#> ℹ You are 96% through the pregnancy.
options(pregnancy.due_date = date_opt) # return original option
```
