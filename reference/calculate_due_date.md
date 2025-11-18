# Calculate estimated due date and birth period

Calculates the estimated due date based on a start date and type. The
function supports different start date types including last menstrual
period (LMP), conception date, and embryo transfer dates. It also
provides an estimated birth period, which spans from 37 weeks (birth
period start) to 42 weeks (birth period end).

## Usage

``` r
calculate_due_date(
  start_date,
  start_type = c("LMP", "conception", "transfer_day_3", "transfer_day_5",
    "transfer_day_6"),
  cycle = 28
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

## Value

Returns a Date object representing the estimated due date invisibly.
Also prints informative messages showing:

- The estimated due date

- When the birth period begins (37 weeks)

- When the birth period ends (42 weeks)

## Details

The due date is calculated as follows:

- For LMP: Ovulation is estimated as `start_date + cycle - 14 days`,
  then 266 days are added

- For conception: 266 days are added to the conception date

- For embryo transfers: The appropriate number of days are subtracted to
  get to conception date (3, 5, or 6 days), then 266 days are added

The birth period start date is 21 days before the due date (37 weeks
pregnant), and the birth period end date is 14 days after the due date
(42 weeks pregnant).

\#' If `start_date` is a character string, the conversion to a `Date` is
handled by
[`anytime::anydate()`](https://rdrr.io/pkg/anytime/man/anytime.html).

## See also

- [`date_when()`](https://ellakaye.github.io/pregnancy/reference/date_when.md)
  for finding dates at specific weeks of pregnancy

- [`how_far()`](https://ellakaye.github.io/pregnancy/reference/how_far.md)
  for calculating current progress in pregnancy

## Examples

``` r
# Calculate due date from last menstrual period
calculate_due_date("2025-01-31")
#> ℹ Estimated due date: Friday, November 07, 2025
#> ℹ Estimated birth period begins: October 17, 2025 (37 weeks)
#> ℹ Estimated birth period ends: November 21, 2025 (42 weeks)

# Calculate from conception date
calculate_due_date("2025-02-14", start_type = "conception")
#> ℹ Estimated due date: Friday, November 07, 2025
#> ℹ Estimated birth period begins: October 17, 2025 (37 weeks)
#> ℹ Estimated birth period ends: November 21, 2025 (42 weeks)

# Calculate from day 5 embryo transfer
calculate_due_date(as.Date("2025-02-19"), start_type = "transfer_day_5")
#> ℹ Estimated due date: Friday, November 07, 2025
#> ℹ Estimated birth period begins: October 17, 2025 (37 weeks)
#> ℹ Estimated birth period ends: November 21, 2025 (42 weeks)

# Calculate with non-standard cycle length
calculate_due_date("2025-01-31", cycle = 35)
#> ℹ Estimated due date: Friday, November 14, 2025
#> ℹ Estimated birth period begins: October 24, 2025 (37 weeks)
#> ℹ Estimated birth period ends: November 28, 2025 (42 weeks)
```
