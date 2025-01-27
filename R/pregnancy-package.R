#' @keywords internal
"_PACKAGE"

# hack to prevent NOTE in check for colnames in medication data frames
# see https://r-pkgs.org/package-within.html#echo-a-working-package
medication <- format <- quantity <- start_date <- stop_date <- NULL
total_days <- days_remaining <- NULL
quantity_remaining <- medication_remaining <- format_remaining <- NULL

# To allow mocking
# see https://testthat.r-lib.org/reference/local_mocked_bindings.html
Sys.Date <- NULL

## usethis namespace: start
#' @importFrom dplyr %>%
#' @importFrom rlang %||%
## usethis namespace: end
NULL
