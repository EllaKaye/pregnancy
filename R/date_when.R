date_when_calculation <- function(weeks, due_date = NULL, today = Sys.Date()) {
  check_date(today)

  due_date <- due_date %||% getOption("pregnancy.due_date") %||% date_abort(due_date)
  check_date(due_date)

  # date calculations
  start_date <- due_date - 280
  date_when <- start_date + (weeks * 7)
  # on_date should always be "Sys.Date()", except for testing and documenting purposes
  total_days <- abs(as.integer(difftime(date_when, today, units = "days"))) # days from today
  list(total_days = total_days, date_when = date_when)
}

# TODO: when testing, take into account that cli is taking care of extraneous white space
# returned strings aren't necessarily what's printed by cli
# TODO: maybe put `days = 0` argument back for more precise messages?
date_when_message <- function(total_days, date_when, weeks, person = NULL, today = Sys.Date()) {
  # grammar for output message
  person <- person %||% getOption("pregnancy.person") %||% "You"
  subject <- get_subject(person) # "I", "You" or person
  tense <- get_tense(today, date_when) # "present", "past", "future"
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
    duration_str <- NULL
  }

  invisible(list(date_str = date_str, duration_str = duration_str))
}

# For users, `today` should always be Sys.Date(). The argument exists purely for documenting and testing purposes.
# Need to check how this is handled in vignette and example building
# TODO: check due date in relation to on_date and give appropriate message if > 42 weeks pregnant
# TODO: maybe put `days = 0` argument back for more precise messages?
#' Calculate and display date of specific pregnancy week
#'
#' @param weeks Numeric value indicating the number of weeks of pregnancy to calculate the date for
#' @param today Date object representing the reference date for calculations. Default is Sys.Date().
#'   This parameter exists primarily for testing and documentation purposes and it is unlikely to make sense for the user to need or want to change it from the default.
#' @inheritParams how_far
#' @return Invisibly returns NULL. Prints messages to the console showing:
#'   - When the specified week of pregnancy occurs/occurred/will occur
#'   - How far in the past/future that date is from today (unless today is the date)
#'
#' @details
#' The function calculates when someone will be/was a specific number of weeks pregnant based on their due date.
#' It handles past, present and future dates appropriately in its messaging.
#' The due date can be provided directly or set globally using options("pregnancy.due_date").
#' Similarly, the person being referenced can be provided directly or set globally using options("pregnancy.person").
#'
#' @examples
#' # Set a due date
#' due <- as.Date("2024-09-01")
#'
#' # When will they be 12 weeks pregnant?
#' date_when(12, due_date = due)
#'
#' # When will they be 20 weeks pregnant?
#' date_when(20, due_date = due, person = "Sarah")
#'
#' @seealso
#' [calculate_due_date()] for calculating the due date
#' [set_due_date()] for setting the due date as a global option
#' [how_far()] for calculating current pregnancy progress
#'
#' @export
date_when <- function(weeks, due_date = NULL, person = NULL, today = Sys.Date()) {
  dd_calc <- date_when_calculation(weeks = weeks, due_date = due_date, today = today)

  dd_message <- date_when_message(total_days = dd_calc$total_days, date_when = dd_calc$date_when, weeks = weeks, person = person)

  # print out information
  cli::cli_inform(c(
    "i" = dd_message$date_str
  ))

  if (!is.null(dd_message$duration_str) && today == Sys.Date()) {
    cli::cli_inform(c(
      "i" = dd_message$duration_str
    ))
  }
}
