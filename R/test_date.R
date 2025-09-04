#' Calculate pregnancy test date
#'
#' Calculates the recommended date for taking a pregnancy test based on a start
#' date and type. The function supports both urine and blood tests, with blood
#' tests typically being viable 2 days earlier than urine tests.
#'
#' @inheritParams calculate_due_date
#' @param test_type character. One of:
#'   * "urine": Home pregnancy test (default)
#'   * "blood": Blood test at clinic
#'
#' @return Returns a Date object invisibly representing the recommended test date.
#'   Also prints informative messages showing:
#'   * The recommended date for a urine test
#'   * The recommended date for a blood test
#'
#' @details
#' The test date is calculated as follows:
#' 1. First, the ovulation date is calculated (see [calculate_due_date()] for details)
#' 2. For urine tests: 14 days are added to the ovulation date
#' 3. For blood tests: 12 days are added to the ovulation date
#'
#' Blood tests can typically detect pregnancy earlier than urine tests due to their
#' greater sensitivity in detecting hCG hormone levels.
#'
#' If `start_date` is a character string, the conversion to a `Date`
#' is handled by anytime::anydate().
#'
#' @examples
#' # Calculate test date from last menstrual period
#' calculate_test_date("2025-01-31")
#'
#' # Calculate for blood test from conception date
#' calculate_test_date(
#'   start_date = "5023-02-14",
#'   start_type = "conception",
#'   test_type = "blood"
#' )
#'
#' # Calculate from day 5 embryo transfer
#' calculate_test_date(
#'   as.Date("2025-02-19")
#'   start_type = "transfer_day_5"
#' )
#'
#' # Calculate with non-standard cycle length
#' calculate_test_date("2025-01-31", cycle = 35)
#'
#' @seealso
#' * [calculate_due_date()] for calculating the estimated due date
#'
#' @export
calculate_test_date <- function(
  start_date,
  start_type = c(
    "LMP",
    "conception",
    "transfer_day_3",
    "transfer_day_5",
    "transfer_day_6"
  ),
  cycle = 28,
  test_type = c("urine", "blood")
) {
  test_type <- rlang::arg_match(test_type)

  urine_test_date <-
    ovulation_date_calculation(
      start_date = start_date,
      start_type = start_type,
      cycle = cycle
    ) +
    lubridate::days(14)

  blood_test_date <- urine_test_date - lubridate::days(2)

  cli::cli_inform(
    c(
      "i" = "Estimated test date (urine): {format(urine_test_date, '%A, %B %d, %Y')}",
      "i" = "Estimated test date (blood): {format(blood_test_date, '%A, %B %d, %Y')}"
    )
  )

  if (test_type == "urine") {
    invisible(urine_test_date)
  } else {
    invisible(blood_test_date)
  }
}
