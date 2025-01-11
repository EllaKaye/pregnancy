# functions relating to pregnancy progress
# how_far(on_date, due_date, person)
# how_long_until(REDO ARGS)

how_far <- function(on_date = Sys.Date(), due_date = NULL, person = NULL) {
  check_date(on_date)

  due_date <- due_date %||% getOption("pregnancy.due_date") %||% date_abort(due_date)
  check_date(due_date)

  # grammar for output message
  person <- person %||% getOption("pregnancy.person") %||% "you"
  subject <- get_subject(person) # "I", "you" or person
  tense <- get_tense(Sys.Date(), on_date) # "present", "past", "future"
  verb <- to_be(subject, tense)

  #verb_tense <- get_tense(Sys.Date(), on_date)
  #person <- person_pronoun(person)
  #verb <- to_be(person, verb_tense)
  #person_lower <- ifelse(person == "You", "you", person)

  # date calculations
  start_date <- due_date - 280

  # span_start <- lubridate::interval(start, on_date)
  # span_due <- lubridate::interval(on_date, due_date)
  # t_start <- lubridate::as.period(span_start, unit = "day")
  # t_due <- lubridate::as.period(span_due, unit = "day")
  # weeks_start <- lubridate::time_length(t_start, unit = "weeks")
  # weeks_due <- lubridate::time_length(t_due, "weeks")

  # days_along <- lubridate::time_length(span_start, unit = "days")
  days_along <- as.numeric(difftime(on_date, start_date, units = "days"))
  weeks_pregnant <- floor(days_along / 7)
  days_pregnant <- round(days_along %% 7)

  percent_along <- round((days_along / 280) * 100)

  # num_days_preg <- round((weeks_start %% 1) * 7)
  # num_weeks_preg <- floor(weeks_start)
  # num_days_left <- (weeks_due %% 1) * 7
  # num_weeks_left <- floor(weeks_due)

  if (tense == "present") {
    cli::cli_inform(c(
      "i" = "Today, {subject} {verb} {weeks_pregnant} week{?s} and {days_pregnant} day{?s} pregnant."
    ))
  } else {
    cli::cli_inform(c(
      "i" = "On {format(on_date, '%B %d, %Y')}, {subject} {verb} {weeks_pregnant} week{?s} and {days_pregnant} day{?s} pregnant."
    ))
  }

  # TODO: Add more info to message
  # cat("On", as.character(on_date), "I will be", num_weeks_preg, "weeks and", num_days_preg, "days pregnant.\n")
  # cat("My due date of", as.character(due_date), "is", num_weeks_left, "weeks and", num_days_left, "days away.\n")

  invisible(days_along)
}

# A reworking of how_long_until
date_when <- function(weeks, days = 0, on_date = Sys.Date(), due_date = NULL, person = NULL) {
  check_date(on_date)

  due_date <- due_date %||% getOption("pregnancy.due_date") %||% date_abort(due_date)
  check_date(due_date)  
}

# TODO: make this `date_when` and bring in line with my python implementation
# TODO: redo args in this function.
# TODO: proper grammar, with person and tense
# Need on_date, due_date, weeks, days, person - think about order (not quiet or return)
how_long_until <- function(due, weeks, days = 0, quiet = FALSE, return = FALSE) {
  # TODO: get due_date instead
  # TODO: use check_date() instead
  # TODO: invisible() instead to arg for return
  # TODO: assertthat::assert_that(assertthat::is.date(due))
  # TODO: think about tense

  if (!is.null(days)) {
    if (!(days %in% 0:6)) stop("days must be an integer between 0 and 6.")
  }

  start <- due - lubridate::days(280)

  date_when <- start + lubridate::weeks(weeks) + lubridate::days(days)

  num_days <- as.integer(date_when - Sys.Date())
  num_weeks <- num_days / 7

  if (num_days < 7) {
    num_days_to_go <- num_days
  } else {
    num_days_to_go <- (num_weeks %% 1) * 7
  }
  num_weeks_to_go <- floor(num_weeks)

  # TODO: {cli} to format output instead of cat()
  if (!quiet) {
    if (num_days < 7) {
      cat("On", as.character(date_when), "I will be", weeks, "weeks and", days, "days pregnant.\nThat's", num_days, "days away.\n")
    } else {
      cat("On", as.character(date_when), "I will be", weeks, "weeks and", days, "days pregnant.\nThat's", num_days, "days away. (Or", num_weeks_to_go, "weeks and", num_days_to_go, "days.)\n")
    }
  }

  if (return) {
    date_when
  }
}
