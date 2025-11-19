# Calculate and display date of specific pregnancy week

Calculate and display date of specific pregnancy week

## Usage

``` r
date_when(weeks, due_date = NULL, person = NULL, today = Sys.Date())
```

## Arguments

- weeks:

  Numeric value indicating the number of weeks of pregnancy to calculate
  the date for.

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

- today:

  Date or character string representing a date, e.g. "YYYY-MM-DD".
  Represents the reference date for calculations. Default is Sys.Date().
  This parameter exists primarily for testing and documentation purposes
  and it is unlikely to make sense for the user to need or want to
  change it from the default.

## Value

Invisibly returns a Date object of when the specified week of pregnancy
occurs/occurred/will occur.

Prints messages to the console showing:

- When the specified week of pregnancy occurs/occurred/will occur

- How far in the past/future that date is from today (unless that date
  is the current date)

## Details

The function calculates when someone will be/was a specific number of
weeks pregnant based on their due date. It handles past, present and
future dates appropriately in its messaging. The due date can be
provided directly or set globally using options("pregnancy.due_date").
Similarly, the person being referenced can be provided directly or set
globally using options("pregnancy.person").

If `date_when` or `today` is a character string, the conversion to a
`Date` is handled by
[`anytime::anydate()`](https://rdrr.io/pkg/anytime/man/anytime.html).

## See also

[`calculate_due_date()`](https://ellakaye.github.io/pregnancy/reference/calculate_due_date.md)
for calculating the due date
[`set_due_date()`](https://ellakaye.github.io/pregnancy/reference/due_date-option.md)
for setting the due date as a global option
[`how_far()`](https://ellakaye.github.io/pregnancy/reference/how_far.md)
for calculating current pregnancy progress

## Examples

``` r
# Set a due date
date_when(20, due_date = "2025-12-01")
#> ℹ On July 14, 2025, you were 20 weeks pregnant.
#> ℹ That was 18 weeks and 2 days ago.
date_when(33, due_date = as.Date("2025-12-01"), person = "Sarah")
#> ℹ On October 13, 2025, Sarah was 33 weeks pregnant.
#> ℹ That was 5 weeks and 2 days ago.
```
