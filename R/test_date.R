# functions relating to test date
# calculate_test_date()
# set_test_date()
# get_test_date()
# days_until_test_date() or two_week_wait()

calculate_test_date <- function(start_date,
                                start_type = c("LMP",
                                               "conception",
                                               "transfer_day_3",
                                               "transfer_day_5",
                                               "transfer_day_6"),
                                cycle = 28,
                                test_type = c("urine", "blood")) {

  test_type <- rlang::arg_match(test_type)

  urine_test_date <-
    ovulation_date_calculation(start_date = start_date,
                               start_type = start_type,
                               cycle = cycle) + lubridate::days(14)

  blood_test_date <- urine_test_date - lubridate::days(2)

  cli::cli_inform(
    c("i" = "Estimated test date (urine): {format(urine_test_date, '%A, %B %d, %Y')}",
      "i" = "Estimated test date (blood): {format(blood_test_date, '%A, %B %d, %Y')}")
  )

  if (test_type == "urine") invisible(urine_test_date)
  else invisible(blood_test_date)
}

get_test_date <- function() {
  test_date <- getOption("pregnancy.test_date")

  if (is.null(test_date)) null_option("test_date")
  else {
    cli::cli_inform("Your test date is set as {format(test_date, '%B %d, %Y')}.")
    check_date(test_date)
  }

  invisible(test_date)

}

set_test_date <- function(test_date) {
  # check date
  if (!is.null(test_date))
    check_date(test_date)

  options("pregnancy.test_date" = test_date)

  # TODO: different message if test_date = NULL
  cli::cli_alert_success("Test date set as {format(test_date, '%B %d, %Y')}")
  set_option_message("test_date")
}

days_until_test <- function(test_date = NULL) {
  test_date <- test_date %||% getOption("pregnancy.test_date") %||% date_abort(test_date)

  check_date(test_date)

  date_diff <- as.numeric(test_date - Sys.Date())

  # TODO: different messages
  # date_diff > 0 -> test in future
  # date_diff == 0, -> test today
  # date_diff < 0 -> already past test date


}
