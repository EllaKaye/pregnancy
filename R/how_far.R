how_far <- function(due, quiet = FALSE, return = FALSE) {

  assertthat::assert_that(assertthat::is.date(due))

  today <- Sys.Date()
  start <- due - lubridate::days(280)

  span <- lubridate::interval(start, today)
  span2 <- lubridate::interval(today, due)

  t <- lubridate::as.period(span, unit = "day")
  t2 <- lubridate::as.period(span2, unit = "day")

  weeks <- lubridate::time_length(t,unit="weeks")
  weeks2 <- lubridate::time_length(t2, "weeks")

  num_days_preg <- (weeks %% 1) * 7
  num_weeks_preg <- floor(weeks)

  num_days_left <- (weeks2 %% 1) * 7
  num_weeks_left <- floor(weeks2)

  if (!quiet) {
    cat("I am", num_weeks_preg, "weeks and", num_days_preg, "days pregnant.\nI am due in", num_weeks_left, "weeks and", num_days_left, "days.\n")
  }

  if (return) {
    weeks
  }

}

#due <- ymd("2022-01-24")

how_far_on_date <- function(due, date, quiet = FALSE, return = FALSE) {

  assertthat::assert_that(assertthat::is.date(due))
  assertthat::assert_that(assertthat::is.date(date))

  start <- due - lubridate::days(280)
  span <- lubridate::interval(start, date)
  t <- lubridate::as.period(span, unit = "day")
  weeks <- lubridate::time_length(t,unit="weeks")

  num_days_preg <- (weeks %% 1) * 7
  num_weeks_preg <- floor(weeks)

  if (!quiet) {
    cat("On", as.character(date), "I will be", num_weeks_preg, "weeks and", num_days_preg, "days pregnant.\n")

  }

  if (return) {
    weeks
  }

}

#due <- ymd("2022-01-24")
#date <- ymd("2021-10-10")

#pregnancy::how_far_on_date(due, date, quiet = TRUE, return = TRUE)

how_long_until <- function(due, weeks, days = 0, quiet = FALSE, return = FALSE) {

  assertthat::assert_that(assertthat::is.date(due))

  if(!is.null(days)) {
    if(!(days %in% 0:6)) stop("days must be an integer between 0 and 6.")
  }

  start <- due - lubridate::days(280)

  date_when <- start + lubridate::weeks(weeks) + lubridate::days(days)

  num_days <- as.integer(date_when - Sys.Date())
  num_weeks <- num_days / 7

  if (num_days < 7) {num_days_to_go <- num_days}
  else {num_days_to_go <- (num_weeks %% 1) * 7}
  num_weeks_to_go <- floor(num_weeks)

  if (!quiet) {
    if (num_days < 7) cat("On", as.character(date_when), "I will be", weeks, "weeks and", days, "days pregnant.\nThat's", num_days, "days away.\n")
    else cat("On", as.character(date_when), "I will be", weeks, "weeks and", days, "days pregnant.\nThat's", num_days, "days away. (Or", num_weeks_to_go, "weeks and", num_days_to_go, "days.)\n")
  }

  if (return) {
    date_when
  }

}

#pregnancy::how_long_until(due, 12, return = TRUE)

meds <- EMKprivate::meds

meds_left <- function(meds, group = c("medication", "format")) {

  group = match.arg(group)

  if (!is.data.frame(meds)) {
    stop("meds must be a data frame")
  }

  colnames_meds <- colnames(meds)

  if (!("medication" %in% colnames_meds)) {
    stop("meds must have a column 'medication'")
  }

  if (!("format" %in% colnames_meds)) {
    stop("meds must have a column 'format'")
  }

  if (!("quantity" %in% colnames_meds)) {
    stop("meds must have a column 'quantity'")
  }

  if (!("stop_date" %in% colnames_meds)) {
    stop("meds must have a column 'stop_date'")
  }

  if (!("extra" %in% colnames_meds)) {
    stop("meds must have a column 'extra'")
  }

  assertthat::assert_that(assertthat::noNA(meds$extra))

  # assert that stop_date are dates
}

meds_colnames <- colnames(meds)
length(meds_colnames)

meds_colnames == colnames(meds)


meds_bad <- dplyr::tibble(medication = "med1", format = "pill", quantity = 1, stop_date = Sys.Date() + lubridate::days(4), extra = NA)

#meds_left(meds_bad)

#meds_left(meds_bad)