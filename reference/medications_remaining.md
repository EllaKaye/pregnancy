# Calculate remaining medications to be taken

Calculates and displays how many medications remain to be taken as of a
specific date, based on a schedule of medications with start and stop
dates. Results can be grouped either by medication name or by format
(e.g., tablet, injection).

## Usage

``` r
medications_remaining(
  meds = NULL,
  group = c("medication", "format"),
  on_date = Sys.Date(),
  until_date = NULL
)
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

- group:

  Character string specifying how to group the results. One of:

  - "medication": Group by medication name (default)

  - "format": Group by medication format

- on_date:

  Date or character string representing a date, e.g. "YYYY-MM-DD",
  specifying the date from which to calculate remaining medications.
  Defaults to current system date

- until_date:

  Date or character string representing a date, e.g. "YYYY-MM-DD",
  specifying cut-off date for remaining medications. If NULL, defaults
  to the latest `stop_date` in `medications`.

## Value

Returns a data frame containing remaining quantities, grouped as
specified. Assumes that the function is being called first thing in the
day, i.e. before any of `on_date`'s medications have been taken. The
data frame has two columns:

- Either 'medication' or 'format' depending on grouping

- quantity: Total number of units remaining

Only medications with remaining quantities \> 0 are included.

If no medications remain, a message is printed to the console indicating
this, and a data frame with 0 rows is returned invisibly.

## Details

If `on_date`, `until_date` `start_date` or `stop_date` is a character
vector, the conversion to a `Date` is handled by
[`anytime::anydate()`](https://rdrr.io/pkg/anytime/man/anytime.html).

If any `start_date` is `NA` in any row, that row will **not** be counted
in the remaining quantities. If any `stop_date` is `NA`, it throws an
error.

## Global Options

- `pregnancy.medications`: Data frame setting default medication
  schedule

## See also

- [`set_medications()`](https://ellakaye.github.io/pregnancy/reference/medications-option.md)
  for setting default medication schedule

- [`get_medications()`](https://ellakaye.github.io/pregnancy/reference/medications-option.md)
  for retrieving current medication schedule

- [medications](https://ellakaye.github.io/pregnancy/reference/medications.md)
  for an example medications data frame

## Examples

``` r
# Define medications table
#' # Create example medication schedule
meds <- data.frame(
  medication = c("progynova", "prednisolone", "clexane"),
  format = c("tablet", "tablet", "injection"),
  quantity = c(3, 2, 1),
  start_date = c("2025-04-21", "2025-04-26", "2025-05-08"),
  stop_date = c("2025-04-30", "2025-05-07", "2025-09-05")
)

# Calculate remaining medications
medications_remaining(meds, on_date = "2025-04-21")
#> # A tibble: 3 × 2
#>   medication   quantity
#>   <chr>           <int>
#> 1 clexane           121
#> 2 prednisolone       24
#> 3 progynova          30

medications_remaining(meds, group = "format", on_date = "2025-04-21")
#> # A tibble: 2 × 2
#>   format    quantity
#>   <chr>        <int>
#> 1 injection      121
#> 2 tablet          54

# Calculate medications for a specified period
medications_remaining(
  meds = meds,
  on_date = "2025-04-23",
  until_date = "2025-04-30"
)
#> # A tibble: 2 × 2
#>   medication   quantity
#>   <chr>           <int>
#> 1 prednisolone       10
#> 2 progynova          24

# Set and use global medications option
#' Store original medications setting (without message)
original_medications <- getOption("pregnancy.medications")
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
medications_remaining(on_date = as.Date("2025-05-01"))
#> # A tibble: 6 × 2
#>   medication   quantity
#>   <chr>           <int>
#> 1 LDA                18
#> 2 clexane           120
#> 3 cyclogest         140
#> 4 lubion             70
#> 5 prednisolone      307
#> 6 progynova         462

# Restore original medications setting (without message)
options(pregnancy.medications = original_medications)
```
