#' Calculate estimated due date and birth period
#'
#' Calculates the estimated due date based on a start date and type. The function
#' supports different start date types including last menstrual period (LMP),
#' conception date, and embryo transfer dates. It also provides an estimated birth
#' period, which spans from 37 weeks (birth period start) to 42 weeks (birth period
#' end).
#'
#' @param start_date Date or character string representing a date, e.g. "YYYY-MM-DD".
#'   The starting reference date. The interpretation of this date depends on the
#'   `start_type` parameter.
#' @param start_type character. One of:
#'   * "LMP": Last Menstrual Period date (default)
#'   * "conception": Date of conception
#'   * "transfer_day_3": Date of day 3 embryo transfer
#'   * "transfer_day_5": Date of day 5 embryo transfer
#'   * "transfer_day_6": Date of day 6 embryo transfer
#' @param cycle numeric. Length of menstrual cycle in days. Only used when
#'   `start_type = "LMP"`. Must be between 20 and 44 days. Defaults to 28 days.
#'
#' @return Returns a Date object representing the estimated due date invisibly.
#'   Also prints informative messages showing:
#'   * The estimated due date
#'   * When the birth period begins (37 weeks)
#'   * When the birth period ends (42 weeks)
#'
#' @details
#' The due date is calculated as follows:
#' * For LMP: Ovulation is estimated as `start_date + cycle - 14 days`, then
#'   266 days are added
#' * For conception: 266 days are added to the conception date
#' * For embryo transfers: The appropriate number of days are subtracted to get
#'   to conception date (3, 5, or 6 days), then 266 days are added
#'
#' The birth period start date is 21 days before the due date (37 weeks pregnant),
#' and the birth period end date is 14 days after the due date (42 weeks pregnant).
#'
#' #' If `start_date` is a character string, the conversion to a `Date`
#' is handled by anytime::anydate().
#'
#' @examples
#' # Calculate due date from last menstrual period
#' calculate_due_date("2025-01-31")
#'
#' # Calculate from conception date
#' calculate_due_date("2025-02-14", start_type = "conception")
#'
#' # Calculate from day 5 embryo transfer
#' calculate_due_date(as.Date("2025-02-19"), start_type = "transfer_day_5")
#'
#' # Calculate with non-standard cycle length
#' calculate_due_date("2025-01-31", cycle = 35)
#'
#' @seealso
#' * [date_when()] for finding dates at specific weeks of pregnancy
#' * [how_far()] for calculating current progress in pregnancy
#'
#' @export
calculate_due_date <- function(
  start_date,
  start_type = c(
    "LMP",
    "conception",
    "transfer_day_3",
    "transfer_day_5",
    "transfer_day_6"
  ),
  cycle = 28
) {
  ovulation_date <-
    ovulation_date_calculation(start_date, start_type, cycle)
  due_date <- ovulation_date + lubridate::days(266)

  # lintr gives false positives for objects only used in `cli::format_inline`
  # nolint start: object_usage_linter
  birth_period_start <- due_date - lubridate::days(21)
  birth_period_end <- due_date + lubridate::days(14)
  # nolint end

  cli::cli_inform(
    c(
      "i" = "Estimated due date: {.strong {format(due_date, '%A, %B %d, %Y')}}",
      "i" = "Estimated birth period begins: {format(birth_period_start, '%B %d, %Y')} (37 weeks)",
      "i" = "Estimated birth period ends: {format(birth_period_end, '%B %d, %Y')} (42 weeks)"
    )
  )

  invisible(due_date)
}

# unexported function to use in both calculate_date_date and calculate_test_date
# ovulation maybe not right term to use for all fertility treatment types,
# but the broad idea is good enough for unexported function.
ovulation_date_calculation <- function(
  start_date,
  start_type = c(
    "LMP",
    "conception",
    "transfer_day_3",
    "transfer_day_5",
    "transfer_day_6"
  ),
  cycle = 28
) {
  start_type <- rlang::arg_match(start_type)

  start_date <- check_date(start_date)

  if (start_type == "LMP") {
    check_cycle(cycle)
  }

  # LMP: start_date is start of last menstrual period
  # conception: start_date in date of conception
  # transfer_day_3/5/6: start_date is date of transfer

  ovulation_date <- switch(
    start_type,
    LMP = start_date + lubridate::days(cycle) - lubridate::days(14),
    conception = start_date,
    transfer_day_3 = start_date - lubridate::days(3),
    transfer_day_5 = start_date - lubridate::days(5),
    transfer_day_6 = start_date - lubridate::days(6)
  )

  ovulation_date
}

#' Set or get the `pregnancy.due_date` option
#'
#' @description
#' Functions to get and set the default due date used throughout the package.
#' This affects calculations in various functions that determine pregnancy progress
#' and timing. Settings persist for the current R session only, unless added to
#' .Rprofile. `set_due_date()` sets the "pregnancy.due_date" option and `get_due_date()` retrieves it.
#'
#' @param due_date A Date object specifying the estimated due date, or NULL to
#'   unset the current value
#'
#' @return
#' Both functions invisibly return the current due date setting:
#' * get_due_date() returns the current setting (a Date object) or NULL if not set
#' * set_due_date() returns the due date value that was set
#'
#' @seealso
#' * [calculate_due_date()] to calculate a due date based on other dates
#' * [how_far()] and other functions that use the due date for calculations
#'
#' @examples
#' # Store original setting
#' original_due_date <- getOption("pregnancy.due_date")
#'
#' # Check current setting
#' get_due_date()
#'
#' # Set due date using as.Date
#' set_due_date(as.Date("2024-09-15"))
#' get_due_date()
#'
#' # Set due date using lubridate
#' library(lubridate)
#' set_due_date(ymd("2024-09-15"))
#' get_due_date()
#'
#' # Restore original setting
#' set_due_date(original_due_date)
#'
#' @name due_date-option
NULL

#' @rdname due_date-option
#' @export
set_due_date <- function(due_date) {
  # check date
  if (!is.null(due_date)) {
    check_date(due_date)
  }

  options("pregnancy.due_date" = due_date)

  if (is.null(due_date)) {
    set_option_null_message("due_date")
  } else {
    cli::cli_alert_success("Due date set as {format(due_date, '%B %d, %Y')}")
    set_option_message("due_date")
  }

  invisible(due_date)
}

#' @rdname due_date-option
#' @export
get_due_date <- function() {
  due_date <- getOption("pregnancy.due_date")

  if (is.null(due_date)) {
    null_option("due_date")
  } else {
    check_date(due_date)
    cli::cli_inform(c(
      "i" = "Your due date is set as {format(due_date, '%B %d, %Y')}."
    ))
  }

  invisible(due_date)
}
