# Set or get the `pregnancy.person` option for pregnancy-related messages

Functions to get and set the default person used in messages throughout
the package. This affects the grammar and pronouns used in various
function outputs. Settings persist for the current R session only,
unless added to .Rprofile. `set_person()` sets the "pregnancy.person"
option and `get_person()` retrieves it.

## Usage

``` r
set_person(person)

get_person()
```

## Arguments

- person:

  The person who is pregnant, to determine the grammar for the output
  message. Can be:

  - "I", "1", "1st", "first", or numeric `1` for first person

  - "you", "2", "2nd", "second", or numeric `2` for second person

  - Any other name for third person

  - `NULL`: will try to use the "pregnancy.person" option. Defaults to
    "You" if the option is set.

## Value

Both functions invisibly return the current person setting:

- get_person() returns the current setting (a character string) or NULL
  if not set

- set_person() returns the person value that was set

## See also

[`how_far()`](https://ellakaye.github.io/pregnancy/reference/how_far.md)
and other functions that use the person setting for message formatting

## Examples

``` r
# Store original setting (without messages)
original_person <- getOption("pregnancy.person")

# Check current setting
get_person()
#> ! You do not have `pregnancy.person` set as an option.
#> ℹ The `person` argument defaults to "You".

# Set to first person (using string)
set_person("I")
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
get_person()
#> ℹ The person option is set as 'I'.

# Set to second person (using number)
set_person(2)
#> ✔ person set as 'You'
#> ℹ Functions in the pregnancy package will now use this `person` option.
#> ℹ So, for this R session, you do not need to supply a value to the `person`
#>   argument (unless you wish to override the option).
#> ℹ To make this `person` option available in all R sessions, in your
#>   ".Rprofile", set `options(pregnancy.person = ...)`
#>   where ... is the value of `person`.
#> ℹ You can edit your ".Rprofile" by calling `usethis::edit_r_profile()`
#> ℹ You can retrieve the `person` option with `get_person()`,
#>   or with `getOption('pregnancy.person')`.
get_person()
#> ℹ The person option is set as 'You'.

# Set to a specific name
set_person("Sarah")
#> ✔ person set as 'Sarah'
#> ℹ Functions in the pregnancy package will now use this `person` option.
#> ℹ So, for this R session, you do not need to supply a value to the `person`
#>   argument (unless you wish to override the option).
#> ℹ To make this `person` option available in all R sessions, in your
#>   ".Rprofile", set `options(pregnancy.person = ...)`
#>   where ... is the value of `person`.
#> ℹ You can edit your ".Rprofile" by calling `usethis::edit_r_profile()`
#> ℹ You can retrieve the `person` option with `get_person()`,
#>   or with `getOption('pregnancy.person')`.
get_person()
#> ℹ The person option is set as 'Sarah'.

# Restore original setting (without messages)
options(pregnancy.person = original_person)
```
