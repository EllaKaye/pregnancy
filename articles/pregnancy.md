# pregnancy

``` r
library(pregnancy)
```

This is an R package for calculating dates and tracking medications
during pregnancy and fertility treatment. It extends a private, personal
package that I wrote for myself when I was pregnant. It contains
functions and features that I found useful at the time, and others that
I added when adapting the package for general use.

The functionality goes beyond what’s offered by online pregnancy
calculators and apps, plus there are no concerns (unlike with these
sites and apps) about data privacy, tracking or advertising.

## A note on dates

To easily keep this vignette fairly up-to-date, and prevent recurring
package build and CRAN failures as time goes by, I have not hard-coded
any dates here. Instead, I have calculated everything from the date on
which this vignette built. That was on **November 19, 2025**, so for the
purposes of reading this page, that counts as “today”.

The **pregnancy** package uses dates extensively. Any function argument
that requires a date can either take a `Date` object[¹](#fn1), or a
character string that can be parsed to a `Date`, e.g. `"YYYY-MM-DD"`.
The parsing is performed by
[`anytime::anydate()`](https://rdrr.io/pkg/anytime/man/anytime.html).

## Date calculations

The
[`calculate_due_date()`](https://ellakaye.github.io/pregnancy/reference/calculate_due_date.md)
function estimates the pregnancy due date. The `start_date` is
interpreted differently, depending on the `start_type`. By default, the
`start_type` is the last menstrual period, and the `start_date` is the
date this started. Other `start_date` options, like various transfer
days, are useful for those using IVF.

``` r
# for purpose of vignette, calculate `start_date` relative to "today"
today <- Sys.Date()
start_date <- today - 192

# invisibly returns a Date object with the estimated due date
# by default, start date of last menstrual period, but other options available
# in practice, the start_date argument will be a known date, e.g. "2025-05-29"
due_date <- calculate_due_date(start_date)
#> ℹ Estimated due date: Sunday, February 15, 2026
#> ℹ Estimated birth period begins: January 25, 2026 (37 weeks)
#> ℹ Estimated birth period ends: March 01, 2026 (42 weeks)
```

Once a due date is know,
[`how_far()`](https://ellakaye.github.io/pregnancy/reference/how_far.md)
tells you how far along the pregnancy is on a given date. It defaults to
providing this information for the current date, but an alternative
`on_date` can be provided. See the section below on global options for
how to avoid needing to pass in the `due_date` value every time you call
these function.

``` r
how_far(due_date = due_date)
#> ℹ You are 27 weeks and 3 days pregnant.
#> ℹ That's 12 weeks and 4 days until the due date (February 15, 2026).
#> ℹ You are 69% through the pregnancy.
how_far(on_date = today + 1, due_date = due_date)
#> ℹ On November 20, 2025, you will be 27 weeks and 4 days
#> pregnant.
```

The
[`date_when()`](https://ellakaye.github.io/pregnancy/reference/date_when.md)
function gives the date when a certain week of pregnancy will be (or
was) reached, and the duration of that date from today:

``` r
date_when(33, due_date = due_date)
#> ℹ On December 28, 2025, you will be 33 weeks pregnant.
#> ℹ That's 5 weeks and 4 days away.
```

By default, the output messages from
[`how_far()`](https://ellakaye.github.io/pregnancy/reference/how_far.md)
and
[`date_when()`](https://ellakaye.github.io/pregnancy/reference/date_when.md)
are in the second person, i.e. addressed to “you”, but there is also an
option to specify another person. A value of `1` or `"I"` means you’ll
be addressed in the first person:

``` r
how_far(due_date = due_date, person = 1)
#> ℹ I am 27 weeks and 3 days pregnant.
#> ℹ That's 12 weeks and 4 days until the due date (February 15, 2026).
#> ℹ I am 69% through the pregnancy.
```

Any other character string will be interpreted as a third-person name,
which is useful, for example, if you’re following the pregnancy progress
of a partner:

``` r
date_when(33, due_date = due_date, person = "Ruth")
#> ℹ On December 28, 2025, Ruth will be 33 weeks pregnant.
#> ℹ That's 5 weeks and 4 days away.
```

There is one further date-related function in the package, which is
useful if you are not yet pregnant but think there’s a chance you might
be, e.g. if you are undergoing fertility treatment. This is
[`calculate_test_date()`](https://ellakaye.github.io/pregnancy/reference/calculate_test_date.md),
which calculates the recommended date for taking a pregnancy test, based
on start date (e.g. start of last menstural period) and test type:

``` r
calculate_test_date(today - 20)
#> ℹ Estimated test date (urine): Thursday, November 27, 2025
#> ℹ Estimated test date (blood): Tuesday, November 25, 2025
```

## Tracking medications

For those who get pregnant via fertility treatment, it is likely they
need to take a number of different medications to support the pregnancy.
Having functionality for tracking these is useful for both practical and
emotional reasons. When I was pregnant, in my personal, private
pregnancy package, whenever I called my version of `how_far`, it would
print a message with how many injections I had already endured, and how
many I had left to go, which helped me get through them.

I haven’t written that functionality into
[`how_far()`](https://ellakaye.github.io/pregnancy/reference/how_far.md)
in this generalised version of the pregnancy package, but I have
provided a separate
[`medications_remaining()`](https://ellakaye.github.io/pregnancy/reference/medications_remaining.md)
function to keep track of medications. It requires a data frame of
medications, which must have the following columns with the specified
data types:

| Column name | Data type                                             | Description                                     |
|-------------|-------------------------------------------------------|-------------------------------------------------|
| medication  | character or factor                                   | name of the medication                          |
| format      | character or factor                                   | format of the medication (e.g. pill, injection) |
| quantity    | numeric                                               | number of units to take per day                 |
| start_date  | Date or string representing a date, e.g. “YYYY-MM-DD” | date to start taking the medication             |
| stop_date   | Date or string representing a date, e.g. “YYYY-MM-DD” | final date on which medication is taken         |

Note that if the quantity of a given medication changes during the
pregnancy, you need separate rows with the start and stop dates for each
quantity.

Here’s an example of what a simple `medications` table might look like:

``` r
# a simplified medication schedule
meds <- pregnancy:::update_meds_table(pregnancy::medications_simple)
meds
#> # A tibble: 4 × 5
#>   medication format    quantity start_date stop_date 
#>   <chr>      <chr>        <dbl> <date>     <date>    
#> 1 progynova  tablet           3 2025-11-05 2025-11-15
#> 2 progynova  tablet           6 2025-11-16 2025-11-26
#> 3 cyclogest  pessary          2 2025-11-18 2025-11-26
#> 4 clexane    injection        1 2025-11-23 2026-01-20
```

You can then calculate the quantity of medications left to take grouped
by either by medication (default) or format. By default, the calculation
is for today (i.e. `on_date` =
[`Sys.Date()`](https://rdrr.io/r/base/Sys.time.html)). The resulting
table assumes that the function is being called first thing in the day,
i.e. before any of `on_date`’s medications have been taken.

``` r
medications_remaining(meds)
#> # A tibble: 3 × 2
#>   medication quantity
#>   <chr>         <int>
#> 1 clexane          59
#> 2 cyclogest        16
#> 3 progynova        48
```

``` r
medications_remaining(meds, group = "format")
#> # A tibble: 3 × 2
#>   format    quantity
#>   <chr>        <int>
#> 1 injection       59
#> 2 pessary         16
#> 3 tablet          48
```

You can specify a value other than today for `on_date`, as well as an
`until_date`. This is useful if you need (as I did) to order a couple of
week’s medication at the time, and have to tell the pharmacy exactly
what you need:

``` r
medications_remaining(
  meds,
  on_date = today + 3,
  until_date = today + 17
)
#> # A tibble: 3 × 2
#>   medication quantity
#>   <chr>         <int>
#> 1 clexane          14
#> 2 cyclogest        10
#> 3 progynova        30
```

## Global options

It would be very tedious to have to enter a due date every time you call
[`how_far()`](https://ellakaye.github.io/pregnancy/reference/how_far.md)
or
[`date_when()`](https://ellakaye.github.io/pregnancy/reference/date_when.md)
over the course of a pregnancy, especially since that date is constant
throughout. The same goes for the medications table required for
[`medications_remaining()`](https://ellakaye.github.io/pregnancy/reference/medications_remaining.md).

To avoid this, the pregnancy package makes use of **global options**,
which can be set with the `set_*` family of functions
([`set_due_date()`](https://ellakaye.github.io/pregnancy/reference/due_date-option.md),
[`set_person()`](https://ellakaye.github.io/pregnancy/reference/person.md),
[`set_medications()`](https://ellakaye.github.io/pregnancy/reference/medications-option.md)).
These functions only set the options for the current R session.

To ensure the options persist across all R sessions, we suggest setting
them in your `.Rprofile`, and give an example at the end of this
vignette.

Global options can be retrieved with the `get_*` family of functions
([`get_due_date()`](https://ellakaye.github.io/pregnancy/reference/due_date-option.md),
[`get_person()`](https://ellakaye.github.io/pregnancy/reference/person.md),
[`get_medications()`](https://ellakaye.github.io/pregnancy/reference/medications-option.md)).

Any global option can be unset by calling its `set_*` function with the
argument `NULL`.

### `pregnancy.due_date`

You can set the `pregnancy.due_date` option using the
[`set_due_date()`](https://ellakaye.github.io/pregnancy/reference/due_date-option.md)
function.

When that option is set, if the `due_date` argument to
[`how_far()`](https://ellakaye.github.io/pregnancy/reference/how_far.md)
or
[`date_when()`](https://ellakaye.github.io/pregnancy/reference/date_when.md)
is `NULL` (the default), that option is retrieved.

[`set_due_date()`](https://ellakaye.github.io/pregnancy/reference/due_date-option.md)
only sets the due date for the current R session. To make this option
persist (recommended), it can be added to your `.Rprofile`. The console
output of
[`set_due_date()`](https://ellakaye.github.io/pregnancy/reference/due_date-option.md)
provides guidance on how to do this.

``` r
# a different due date from the earlier example
due_date <- today + 180
set_due_date(due_date)
#> ✔ Due date set as May 18, 2026
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

Then
[`how_far()`](https://ellakaye.github.io/pregnancy/reference/how_far.md)
can be called without needing to specify any arguments, and
[`date_when()`](https://ellakaye.github.io/pregnancy/reference/date_when.md)
only needs the target week:

``` r
how_far()
#> ℹ You are 14 weeks and 2 days pregnant.
#> ℹ That's 25 weeks and 5 days until the due date (May 18, 2026).
#> ℹ You are 36% through the pregnancy.
```

``` r
date_when(20)
#> ℹ On December 29, 2025, you will be 20 weeks pregnant.
#> ℹ That's 5 weeks and 5 days away.
```

To check what the option is set to, use
[`get_due_date()`](https://ellakaye.github.io/pregnancy/reference/due_date-option.md).

### `pregnancy.person`

[`set_person()`](https://ellakaye.github.io/pregnancy/reference/person.md)
sets the global option `pregnancy.person` for the current R session. If
this option is set it will be retrieved to specify the value of `person`
in
[`how_far()`](https://ellakaye.github.io/pregnancy/reference/how_far.md)
and
[`date_when()`](https://ellakaye.github.io/pregnancy/reference/date_when.md),
unless it is overriden by passing another value directly to the `person`
argument. If the option is not set, the default second-person will be
used.

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
how_far() # due_date option still set from previous section
#> ℹ I am 14 weeks and 2 days pregnant.
#> ℹ That's 25 weeks and 5 days until the due date (May 18, 2026).
#> ℹ I am 36% through the pregnancy.
set_person(NULL)
#> ✔ pregnancy.person option set to NULL.
#> ℹ The `person` argument will now default to "You".
how_far()
#> ℹ You are 14 weeks and 2 days pregnant.
#> ℹ That's 25 weeks and 5 days until the due date (May 18, 2026).
#> ℹ You are 36% through the pregnancy.
```

### `pregnancy.medications`

[`set_medications()`](https://ellakaye.github.io/pregnancy/reference/medications-option.md)
sets the global option `pregnancy.medications` for the current R
session.

When that option is set, if the `meds` argument to
[`medications_remaining()`](https://ellakaye.github.io/pregnancy/reference/medications_remaining.md)
is `NULL` (the default), that option is retrieved.

``` r
set_medications(pregnancy:::update_meds_table(pregnancy::medications))
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
medications_remaining()
#> # A tibble: 6 × 2
#>   medication   quantity
#>   <chr>           <int>
#> 1 LDA                 4
#> 2 clexane           120
#> 3 cyclogest         138
#> 4 lubion             69
#> 5 prednisolone      289
#> 6 progynova         414
```

### An example `.Rprofile`

Taking the advice to specify the options in your `.Rprofile`, here’s an
example of what that might look like:

``` r
options(
  pregnancy.due_date = "2025-09-16",
  pregnancy.person = "I", # addressed in first person
  pregnancy.medications = dplyr::tribble(
    ~medication, ~format, ~quantity, ~start_date, ~stop_date,
    "progynova", "tablet", 3, "2025-04-21", "2025-04-30",
    "progynova", "tablet", 6, "2025-05-01", "2025-07-11",
    "cyclogest", "pessary", 2, "2025-05-03", "2025-07-11",
    "clexane", "injection", 1, "2025-05-08", "2025-09-05"
  )
)
```

Note that it is best to avoid creating R objects in your `.Rprofile`,
e.g. a `medications` data frame outside of the call to
[`options()`](https://rdrr.io/r/base/options.html), otherwise that
object will be loaded into your global environment at the start of every
R session.

------------------------------------------------------------------------

1.  There are many ways to create `Date` objects in R, including
    [`as.Date()`](https://rdrr.io/r/base/as.Date.html),
    [`lubridate::ymd()`](https://lubridate.tidyverse.org/reference/ymd.html),
    and
    [`anytime::anydate()`](https://rdrr.io/pkg/anytime/man/anytime.html).
