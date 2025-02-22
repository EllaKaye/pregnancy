#' @keywords internal
"_PACKAGE"

# hack to prevent NOTE in check for colnames in medication data frames
# see https://r-pkgs.org/package-within.html#echo-a-working-package
medication <- format <- quantity <- start_date <- stop_date <- NULL
to <- from <- days <- quant <- NULL

# To allow mocking
# see https://testthat.r-lib.org/reference/local_mocked_bindings.html
Sys.Date <- NULL # nolint: object_name_linter

## usethis namespace: start
#' @importFrom dplyr %>%
#' @importFrom rlang %||%
## usethis namespace: end
NULL
