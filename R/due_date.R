# functions related to due date
# calculate_due_date(start_date, start_type, cycle)
# get_due_date()
# set_due_date(due_date)

#' Calculate due date
#'
#' @param start_date Start date
#' @param start_type Start type
#' @param cycle Cycle length
#'
#' @return Your due date
#' @export
#'
#' @examples my_start_date <- as.Date("2023-01-31")
#' @examples calculate_due_date(my_start_date)
#' @examples due_date <- calculate_due_date(my_start_date, "conception")
#' @examples due_date
#' @examples class(due_date)
calculate_due_date <- function(start_date,
                               start_type = c(
                                 "LMP",
                                 "conception",
                                 "transfer_day_3",
                                 "transfer_day_5",
                                 "transfer_day_6"
                               ),
                               cycle = 28) {
  ovulation_date <-
    ovulation_date_calculation(start_date, start_type, cycle)
  due_date <- ovulation_date + lubridate::days(266)

  birth_period_start <- due_date - lubridate::days(21)
  birth_period_end <- due_date + lubridate::days(14)

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
ovulation_date_calculation <- function(start_date,
                                       start_type = c(
                                         "LMP",
                                         "conception",
                                         "transfer_day_3",
                                         "transfer_day_5",
                                         "transfer_day_6"
                                       ),
                                       cycle = 28) {
  start_type <- rlang::arg_match(start_type)

  check_date(start_date)

  if (start_type == "LMP") {
    check_cycle(cycle)
  }

  # LMP: start_date is start of last menstrual period
  # conception: start_date in date of conception
  # transfer_day_3/5/6: start_date is date of transfer

  ovulation_date <- switch(start_type,
    LMP = start_date + lubridate::days(cycle) - lubridate::days(14),
    conception = start_date,
    transfer_day_3 = start_date - lubridate::days(3),
    transfer_day_5 = start_date - lubridate::days(5),
    transfer_day_6 = start_date - lubridate::days(6)
  )

  ovulation_date
}


get_due_date <- function() {
  due_date <- getOption("pregnancy.due_date")

  if (is.null(due_date)) {
    null_option("due_date")
  } else {
    check_date(due_date)
    cli::cli_inform("Your due date is set as {format(due_date, '%B %d, %Y')}.")
  }

  invisible(due_date)
}

set_due_date <- function(due_date) {
  # check date
  if (!is.null(due_date)) {
    check_date(due_date)
  }

  options("pregnancy.due_date" = due_date)

  # TODO: different message if due_date = NULL
  cli::cli_alert_success("Due date set as {format(due_date, '%B %d, %Y')}")
  set_option_message("due_date")

  invisible(due_date)
}
