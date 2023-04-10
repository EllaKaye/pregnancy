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
#' @examples calculate_due_date(as.Date("2023-01-31"))
calculate_due_date <- function(start_date,
                               start_type = c("LMP",
                                              "conception",
                                              "transfer_day_3",
                                              "transfer_day_5",
                                              "transfer_day_6"),
                               cycle = 28) {
  start_type <- rlang::arg_match(start_type)

  check_date(start_date)


  # LMP: start_date is start of last menstrual period
  if (start_type == "LMP") {
    check_cycle(cycle)
    due_date <-
      start_date + lubridate::days(cycle) - lubridate::days(28) + lubridate::days(280)
  }

  # conception: start_date in date of conception
  if (start_type == "conception") {
    due_date <- start_date + lubridate::days(266)
  }

  # transfer_day_3: start_date is date of transfer
  if (start_type == "transfer_day_3") {
    due_date <- start_date + lubridate::days(266) - lubridate::days(3)
  }

  # transfer_day_5: start_date is date of transfer
  if (start_type == "transfer_day_5") {
    due_date <- start_date + lubridate::days(266) - lubridate::days(5)
  }

  # transfer_day_6: start_date is date of transfer
  if (start_type == "transfer_day_6") {
    due_date <- start_date + lubridate::days(266) - lubridate::days(6)
  }

  birth_period_start <- due_date - lubridate::days(21)
  birth_period_end <- due_date + lubridate::days(14)

  cli::cli_inform(
    c("i" = "Due date: {format(due_date, '%A, %B %d, %Y')}",
      "i" = "Estimated birth period begins: {format(birth_period_start, '%A, %B %d, %Y')} (37 weeks)",
      "i" = "Estimated birth period ends: {format(birth_period_end, '%A, %B %d, %Y')} (42 weeks)")
  )

  invisible(due_date)

}

get_due_date <- function() {
  due_date <- getOption("pregnancy.due_date")

  if (is.null(due_date))
    cli::cli_bullets(
      c("!" = "You do not have {.code pregnancy.due_date} set as an option.",
        "i" = "You can set it by...")
    )
  else
    cli::cli_inform("Your due date is set as {format(due_date, '%B %d, %Y')}.")

}

set_due_date <- function(due_date) {
  # check date
  if (!is.null(due_date))
    check_date(due_date)

  options("pregnancy.due_date" = due_date)

  # TODO: different message if NULL

  cli::cli_alert_success("Due date set as {format(due_date, '%B %d, %Y')}")
  cli::cli_alert_info(
    "Functions in the pregnancy package will now use this due
                        date without you needing to supply a value to the `due_date` argument.",
    wrap = TRUE
  )
  cli::cli_alert_info("The setting only holds for this R session")
  cli::cli_alert_info("To set the due date across sessions, ...")
  # message indicating success

}
