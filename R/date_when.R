date_when_calculation <- function(weeks, on_date = Sys.Date(), due_date = NULL) {
  check_date(on_date)

  due_date <- due_date %||% getOption("pregnancy.due_date") %||% date_abort(due_date)
  check_date(due_date)  

  # date calculations
  start_date <- due_date - 280
  date_when <- start_date + (weeks * 7)
  # on_date should always be "Sys.Date()", except for testing and documenting purposes
  total_days <- abs(as.integer(difftime(date_when, on_date, units = "days"))) # days from today
  list(total_days = total_days, date_when = date_when)
}

# TODO: when testing, take into account that cli is taking care of extraneous white space
# returned strings aren't necessarily what's printed by cli
# TODO: maybe put `days = 0` argument back for more precise messages?
date_when_message <- function(total_days, date_when, weeks, person = NULL) {
  # grammar for output message
  person <- person %||% getOption("pregnancy.person") %||% "You"
  subject <- get_subject(person) # "I", "You" or person
  tense <- get_tense(Sys.Date(), date_when) # "present", "past", "future"
  verb <- to_be(subject, tense)
  subject <- ifelse(subject == "You", "you", subject)

  weeks_from_now <- floor(total_days / 7)
  and_days_from_now <- round(total_days %% 7)

  if (tense == "present") {
    prefix <- "Today"
  } else {
    prefix <- cli::format_inline("On {format(date_when, '%B %d, %Y')}")
  } 

  date_str <- cli::format_inline("{prefix}, {subject} {verb} {weeks} weeks pregnant.")

  if (tense != "present") {
    if (tense == "past") {
      prefix <- "That was"
      suffix <- "ago"
    } else if (tense == "future") {
      prefix <- "That's"
      suffix <- "away"
    }

    if (weeks_from_now == 0) {
      weeks_str <- ""
    } else {
      weeks_str <- cli::format_inline("{weeks_from_now} week{?s} and")
    }
    duration_str <- cli::format_inline("{prefix} {weeks_str} {and_days_from_now} day{?s} {suffix}.")
  } else {
    duration_str = NULL
  }
  
  invisible(list(date_str = date_str, duration_str = duration_str))
}


# TODO: put `on_date` into a testable helper function, but MAYBE not into date_when
  # Need to check how this is handled in vignette and example building
# TODO: check due date in relation to on_date and give appropriate message if > 42 weeks pregnant
# TODO: maybe put `days = 0` argument back for more precise messages?
date_when <- function(weeks, on_date = Sys.Date(), due_date = NULL, person = NULL) {
  dd_calc <- date_when_calculation(weeks = weeks, on_date = on_date, due_date = due_date)

  dd_message <- date_when_message(total_days = dd_calc$total_days, date_when = dd_calc$date_when, weeks = weeks, person = person)

  # print out information
  cli::cli_inform(c(
    "i" = dd_message$date_str
  ))

  if (!is.null(dd_message$duration_str)) {
    cli::cli_inform(c(
      "i" = dd_message$duration_str
    ))    
  }
}
