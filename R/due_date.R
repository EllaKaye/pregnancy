#' Calculate due date
#'
#' @param start_date Start date
#' @param start_type Start type
#' @param cycle Cycle length
#'
#' @return Your due date
#' @export
#'
#' @examples calculate_due_date(lubridate::ymd("2023-02-15"))
calculate_due_date <- function(start_date, start_type = c("LMP", "conception", "IVF", "fresh_donor", "transfer_day_3", "transfer_day_5"), cycle = 28) {

  # TODO: use rlang::arg_match
  start_type <- match.arg(start_type)

  # use check_date() instead
  # assertthat::assert_that(assertthat::is.date(start_date))

  # TODO: Use {cli} for output instead of stop()
  if (start_type == "LMP") {
    if (!(cycle %in% 20:44)) stop("cycle must be an integer between 20 and 44")
  }

  # LMP: start_date is start of last menstrual period
  if (start_type == "LMP") {
    due <- start_date + lubridate::days(cycle) - lubridate::days(28) + lubridate::days(280)
  }

  # conception: start_date in date of conception
  if (start_type == "conception") {
    due <- start_date + lubridate::days(266)
  }

  # IVF: start_date is date of egg retrieval
  if (start_type == "IVF") {
    due <- start_date + lubridate::days(266)
  }

  # fresh_donor: start_date is date of egg retrieval
  if (start_type == "fresh_donor") {
    due <- start_date + lubridate::days(266)
  }

  # transfer_day_3: start_date is date of transfer
  if (start_type == "transfer_day_3") {
    due <- start_date + lubridate::days(266) - lubridate::days(3)
  }

  # transfer_day_5: start_date is date of transfer
  if (start_type == "transfer_day_5") {
    due <- start_date + lubridate::days(266) - lubridate::days(5)
  }

  return(due)

}


get_due_date <- function() {

  due_date <- getOption("pregnancy.due_date")

  if (is.null(due_date)) cli::cli_bullets(c("!" = "You do not have {.code pregnancy.due_date} set as an option.",
                                            "i" = "You can set it by..."))
  else cli::cli_inform("Your due date is set as {format(due_date, '%B %d, %Y')}.")

}

set_due_date <- function(due_date) {

  # check date
  check_date(due_date)

  options("pregnancy.due_date" = due_date)

  cli::cli_alert_success("Due date set as {format(due_date, '%B %d, %Y')}")
  cli::cli_alert_info("Functions in the pregnancy package will now use this due
                        date without you needing to supply a value to the `due_date` argument.",
                      wrap = TRUE)
  cli::cli_alert_info("The setting only holds for this R session")
  cli::cli_alert_info("To set the due date across sessions, ...")
  # message indicating success

}
