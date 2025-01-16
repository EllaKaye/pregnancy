# functions relating to pregnancy progress
# how_far(on_date, due_date, person)
# how_long_until(REDO ARGS)

# TODO: document
# TODO: check due date in relation to on_date/Sys.Date()
how_far <- function(on_date = Sys.Date(), due_date = NULL, person = NULL) {
  check_date(on_date)

  due_date <- due_date %||% getOption("pregnancy.due_date") %||% date_abort(due_date)
  check_date(due_date)

  # grammar for output message
  person <- person %||% getOption("pregnancy.person") %||% "You"
  subject <- get_subject(person) # "I", "You" or person
  tense <- get_tense(Sys.Date(), on_date) # "present", "past", "future"
  verb <- to_be(subject, tense)

  # date calculations
  start_date <- due_date - 280

  days_along <- as.numeric(difftime(on_date, start_date, units = "days"))
  weeks_pregnant <- floor(days_along / 7)
  and_days_pregnant <- round(days_along %% 7)

  days_to_go = 280 - days_along
  weeks_to_go <- floor(days_to_go / 7)
  and_days_to_go <- round(days_to_go %% 7)

  percent_along <- round((days_along / 280) * 100)

  # when more than a couple of weeks past due date (i.e. should no longer be pregnant)
  # print message and return invisibly
  if (weeks_pregnant > 42) {
    subject = ifelse(subject == "You", "you", subject)
    
    if (tense == "present") {
      cli::cli_inform(c(
        "i" = "Given a due date of {format(due_date, '%B %d, %Y')}, {subject} would now be more than 42 weeks pregnant."
      ))
    } else if (tense == "past") {
      cli::cli_inform(c(
        "i" = "Given a due date of {format(due_date, '%B %d, %Y')}, on {format(on_date, '%B %d, %Y')}, {subject} would have been more than 42 weeks pregnant."
      ))      
    } else {
      cli::cli_inform(c(
        "i" = "Given a due date of {format(due_date, '%B %d, %Y')}, on {format(on_date, '%B %d, %Y')}, {subject} would be more than 42 weeks pregnant."
      ))  
    }

    return(invisible(days_along))
  }

  # print out how far and other info
  if (tense == "present") {
    cli::cli_inform(c(
      "i" = "{subject} {verb} {weeks_pregnant} week{?s} and {and_days_pregnant} day{?s} pregnant.",
      "i" = "That's {weeks_to_go} week{?s} and {and_days_to_go} day{?s} until the due date ({format(due_date, '%B %d, %Y')}).",
      "i" = "{subject} {verb} {percent_along}% through the pregnancy."
    ))
  } else {
    subject = ifelse(subject == "You", "you", subject)
    cli::cli_inform(c(
      "i" = "On {format(on_date, '%B %d, %Y')}, {subject} {verb} {weeks_pregnant} week{?s} and {and_days_pregnant} day{?s} pregnant."
    ))
  }

  invisible(days_along)
}

# A reworking of how_long_until
# TODO: incorporate on_date (or think about whether I need that for anything other than testing)
# TODO: check due date in relation to on_date and give appropriate message if > 42 weeks pregnant
date_when <- function(weeks, days = 0, on_date = Sys.Date(), due_date = NULL, person = NULL) {
  check_date(on_date)

  due_date <- due_date %||% getOption("pregnancy.due_date") %||% date_abort(due_date)
  check_date(due_date)  

  # date calculations
  start_date <- due_date - 280
  date_when <- start_date + (weeks * 7) + days
  total_days <- abs(as.integer(difftime(date_when, Sys.Date(), units = "days"))) # days from today

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

  if (days == 0) {
    day_str <- ""
  } else {
    day_str <- cli::format_inline("and {days} day{?s}")
  }

  date_str <- cli::format_inline("{prefix}, {subject} {verb} {weeks} weeks {day_str} pregnant.")

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

  # print out information
  cli::cli_inform(c(
    "i" = date_str
  ))

  if (tense != "present") {
    cli::cli_inform(c(
      "i" = duration_str
    ))    
  }

  # TODO: when testing, take into account that cli is taking care of extraneous white space
  # returned strings aren't necessarily what's printed
  invisible(list(date_str = date_str, duration_str = duration_str))
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

# TODO: split out date calculations and printing of messages for easier testing
# as per python version of package