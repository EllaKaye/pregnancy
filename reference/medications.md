# An example medications table

A data frame with example medications that might be used during
fertility treatment/first trimester. It is an example of a data frame
that might be used as the `meds` argument to
[`medications_remaining()`](https://ellakaye.github.io/pregnancy/reference/medications_remaining.md).

## Usage

``` r
medications

medications_simple
```

## Format

`medications` is a data frame with 14 rows and 5 columns.
`medications_simple` is a data frame with 4 rows and 5 columns.

- medication:

  Name of the medication

- format:

  Format of medication

- quantity:

  Number taken per day

- start_date:

  Date to start taking the medication

- stop_date:

  Final date on which the medication is taken. See details.

An object of class `tbl_df` (inherits from `tbl`, `data.frame`) with 4
rows and 5 columns.

## Details

Note that the same medication (prednisolone in this example) has several
rows, first because the quantity taken per day changes, then because it
needs to be taken on non-consecutive days.

## See also

[`medications_remaining()`](https://ellakaye.github.io/pregnancy/reference/medications_remaining.md)

## Examples

``` r
medications
#> # A tibble: 14 × 5
#>    medication   format    quantity start_date stop_date 
#>    <chr>        <chr>        <dbl> <date>     <date>    
#>  1 progynova    tablet           3 2025-07-21 2025-07-30
#>  2 LDA          tablet           1 2025-07-21 2025-08-07
#>  3 prednisolone tablet           2 2025-07-26 2025-08-07
#>  4 progynova    tablet           6 2025-08-01 2025-10-11
#>  5 cyclogest    pessary          2 2025-08-03 2025-10-11
#>  6 lubion       injection        1 2025-08-03 2025-10-11
#>  7 clexane      injection        1 2025-08-08 2025-12-05
#>  8 prednisolone tablet           4 2025-08-08 2025-10-11
#>  9 prednisolone tablet           3 2025-10-12 2025-10-14
#> 10 prednisolone tablet           2 2025-10-15 2025-10-17
#> 11 prednisolone tablet           1 2025-10-18 2025-10-20
#> 12 prednisolone tablet           1 2025-10-22 2025-10-22
#> 13 prednisolone tablet           1 2025-10-24 2025-10-24
#> 14 prednisolone tablet           1 2025-10-26 2025-10-26
medications_simple
#> # A tibble: 4 × 5
#>   medication format    quantity start_date stop_date 
#>   <chr>      <chr>        <dbl> <date>     <date>    
#> 1 progynova  tablet           3 2025-08-21 2025-08-31
#> 2 progynova  tablet           6 2025-09-01 2025-09-11
#> 3 cyclogest  pessary          2 2025-09-03 2025-09-11
#> 4 clexane    injection        1 2025-09-08 2025-11-05
```
