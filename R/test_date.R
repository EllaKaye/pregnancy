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
  urine_test_date <-
    ovulation_date_calculation(start_date = start_date,
                               start_type = start_type,
                               cycle = cycle) + lubridate::days(14)

  blood_test_date <- urine_test_date - lubridate::days(2)

  cli::cli_inform(
    c("i" = "Estimated test date (urine): {format(urine_test_date, '%A, %B %d, %Y')}",
      "i" = "Estimated test date (blood): {format(blood_test_date, '%A, %B %d, %Y')}")
  )

  test_type <- rlang::arg_match(test_type)
  if (test_type == "urine")
    invisible(urine_test_date)
  if (test_type == "blood")
    invisible(blood_test_date)
}
