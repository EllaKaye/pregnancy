# Calculate pregnancy test date

Calculates the recommended date for taking a pregnancy test based on a
start date and type. The function supports both urine and blood tests,
with blood tests typically being viable 2 days earlier than urine tests.

## Usage

``` r
calculate_test_date(
  start_date,
  start_type = c("LMP", "conception", "transfer_day_3", "transfer_day_5",
    "transfer_day_6"),
  cycle = 28,
  test_type = c("urine", "blood")
)
```

## Arguments

- start_date:

  Date or character string representing a date, e.g. "YYYY-MM-DD". The
  starting reference date. The interpretation of this date depends on
  the `start_type` parameter.

- start_type:

  character. One of:

  - "LMP": Last Menstrual Period date (default)

  - "conception": Date of conception

  - "transfer_day_3": Date of day 3 embryo transfer

  - "transfer_day_5": Date of day 5 embryo transfer

  - "transfer_day_6": Date of day 6 embryo transfer

- cycle:

  numeric. Length of menstrual cycle in days. Only used when
  `start_type = "LMP"`. Must be between 20 and 44 days. Defaults to 28
  days.

- test_type:

  character. One of:

  - "urine": Home pregnancy test (default)

  - "blood": Blood test at clinic

## Value

Returns a Date object invisibly representing the recommended test date.
Also prints informative messages showing:

- The recommended date for a urine test

- The recommended date for a blood test

## Details

The test date is calculated as follows:

1.  First, the ovulation date is calculated (see
    [`calculate_due_date()`](https://ellakaye.github.io/pregnancy/reference/calculate_due_date.md)
    for details)

2.  For urine tests: 14 days are added to the ovulation date

3.  For blood tests: 12 days are added to the ovulation date

Blood tests can typically detect pregnancy earlier than urine tests due
to their greater sensitivity in detecting hCG hormone levels.

If `start_date` is a character string, the conversion to a `Date` is
handled by
[`anytime::anydate()`](https://rdrr.io/pkg/anytime/man/anytime.html).

## See also

- [`calculate_due_date()`](https://ellakaye.github.io/pregnancy/reference/calculate_due_date.md)
  for calculating the estimated due date

## Examples

``` r
# Calculate test date from last menstrual period
calculate_test_date("2025-01-31")
#> ℹ Estimated test date (urine): Friday, February 28, 2025
#> ℹ Estimated test date (blood): Wednesday, February 26, 2025

# Calculate for blood test from conception date
calculate_test_date(
  start_date = "5023-02-14",
  start_type = "conception",
  test_type = "blood"
)
#> ℹ Estimated test date (urine): Friday, February 28, 5023
#> ℹ Estimated test date (blood): Wednesday, February 26, 5023

# Calculate from day 5 embryo transfer
calculate_test_date(
  as.Date("2025-02-19"),
  start_type = "transfer_day_5"
)
#> ℹ Estimated test date (urine): Friday, February 28, 2025
#> ℹ Estimated test date (blood): Wednesday, February 26, 2025

# Calculate with non-standard cycle length
calculate_test_date("2025-01-31", cycle = 35)
#> ℹ Estimated test date (urine): Friday, March 07, 2025
#> ℹ Estimated test date (blood): Wednesday, March 05, 2025
```
