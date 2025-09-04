# functions relating to pregnancy progress
how_far_calculation <- function(on_date = Sys.Date(), due_date = NULL) {
  on_date <- check_date(on_date)

  due_date <- due_date %||%
    getOption("pregnancy.due_date") %||%
    date_stop(due_date)
  due_date <- check_date(due_date)

  # date calculations
  start_date <- due_date - 280

  days_along <- as.numeric(difftime(on_date, start_date, units = "days"))
  weeks_pregnant <- floor(days_along / 7)
  and_days_pregnant <- round(days_along %% 7)

  days_to_go <- 280 - days_along
  weeks_to_go <- floor(days_to_go / 7)
  and_days_to_go <- round(days_to_go %% 7)

  percent_along <- round((days_along / 280) * 100)

  list(
    days_along = days_along,
    weeks_pregnant = weeks_pregnant,
    and_days_pregnant = and_days_pregnant,
    weeks_to_go = weeks_to_go,
    and_days_to_go = and_days_to_go,
    percent_along = percent_along,
    due_date = due_date
  )
}

# MAYBE: think about messages 2 and 3 if on_date is not Sys.Date()
# lintr gives false positives for objects only used in `cli::format_inline`
how_far_message <- function(calc_results, on_date = Sys.Date(), person = NULL) {
  on_date <- check_date(on_date)

  # grammar for output message
  person <- person %||% getOption("pregnancy.person") %||% "You"
  subject <- get_subject(person) # "I", "You" or person
  tense <- get_tense(Sys.Date(), on_date) # "present", "past", "future"
  verb <- to_be(subject, tense) # nolint: object_usage_linter

  # when more than a couple of weeks past due date (i.e. should no longer be pregnant)
  if (calc_results$weeks_pregnant > 42) {
    subject <- ifelse(subject == "You", "you", subject)

    if (tense == "present") {
      message <- cli::format_inline(
        "Given a due date of {format(calc_results$due_date, '%B %d, %Y')}, {subject} would now be more than 42 weeks pregnant."
      )
    } else if (tense == "past") {
      message <- cli::format_inline(
        "Given a due date of {format(calc_results$due_date, '%B %d, %Y')}, on {format(on_date, '%B %d, %Y')}, {subject} would have been more than 42 weeks pregnant."
      )
    } else {
      message <- cli::format_inline(
        "Given a due date of {format(calc_results$due_date, '%B %d, %Y')}, on {format(on_date, '%B %d, %Y')}, {subject} would be more than 42 weeks pregnant."
      )
    }

    return(list(messages = message))
  }

  # When shouldn't yet be pregnant (i.e. weeks_pregnant < 0)
  if (calc_results$days_along <= 0) {
    subject <- ifelse(subject == "You", "you", subject)

    if (tense == "present") {
      message <- cli::format_inline(
        "Given a due date of {format(calc_results$due_date, '%B %d, %Y')}, {subject} wouldn't yet be pregnant."
      )
    } else if (tense == "past") {
      message <- cli::format_inline(
        "Given a due date of {format(calc_results$due_date, '%B %d, %Y')}, on {format(on_date, '%B %d, %Y')}, {subject} would have not yet been pregnant."
      )
    } else {
      message <- cli::format_inline(
        "Given a due date of {format(calc_results$due_date, '%B %d, %Y')}, on {format(on_date, '%B %d, %Y')}, {subject} will not yet be pregnant."
      )
    }

    return(list(messages = message))
  }

  # format regular messages
  if (tense == "present") {
    messages <- c(
      cli::format_inline(
        "{subject} {verb} {calc_results$weeks_pregnant} week{?s} and {calc_results$and_days_pregnant} day{?s} pregnant."
      ),
      cli::format_inline(
        "That's {calc_results$weeks_to_go} week{?s} and {calc_results$and_days_to_go} day{?s} until the due date ({format(calc_results$due_date, '%B %d, %Y')})."
      ),
      cli::format_inline(
        "{subject} {verb} {calc_results$percent_along}% through the pregnancy."
      )
    )
  } else {
    subject <- ifelse(subject == "You", "you", subject)
    messages <- cli::format_inline(
      "On {format(on_date, '%B %d, %Y')}, {subject} {verb} {calc_results$weeks_pregnant} week{?s} and {calc_results$and_days_pregnant} day{?s} pregnant."
    )
  }

  list(messages = messages)
}

#' Calculate pregnancy progress and time remaining
#'
#' @description
#' Calculates and displays how far along a pregnancy is on a specific date, including
#' weeks pregnant, days remaining until due date, and overall progress percentage.
#'
#' @param on_date Date or character string representing a date, e.g. "YYYY-MM-DD".
#'   The date for which to calculate pregnancy progress.
#'   Defaults to current system date.
#' @param due_date Date or character string representing a date, e.g. "YYYY-MM-DD".
#'   The expected due date. If NULL, will try to use the "pregnancy.due_date" option.
#'   Required if option not set.
#' @param person The person who is pregnant, to determine the grammar for the output message. Can be:
#'   * "I", "1", "1st", "first", or numeric `1` for first person
#'   * "you", "2", "2nd", "second", or numeric `2` for second person
#'   * Any other name for third person
#'   * `NULL`: will try to use the "pregnancy.person" option. Defaults to "You" if the option is set.
#'
#' @return
#' Invisibly returns the number of days along in the pregnancy. Prints a formatted
#' message to the console with pregnancy progress information.
#'
#' @details
#' The function assumes a standard pregnancy length of 280 days (40 weeks) when
#' calculating progress. It handles past, present, and future dates appropriately by
#' adjusting message grammar. If the calculation shows more than 42 weeks of pregnancy,
#' a different message is displayed noting this unusual duration.
#'
#' The function uses the [cli](https://cli.r-lib.org) package for formatted message output and supports
#' proper pluralization of weeks/days in messages.
#'
#' If `on_date` or `due_date` are character strings, the conversion to a `Date`
#' is handled by anytime::anydate().
#'
#' @section Global Options:
#' * pregnancy.due_date: Date object setting default due date
#' * pregnancy.person: Character string setting default person
#'
#' @examples
#' # Current progress with explicit due date
#' # Note that output will depend on date the function is run
#' how_far(due_date = "2025-12-01")
#'
#' # Progress on a specific date
#' how_far(on_date = "2025-11-01", due_date = "2025-12-01")
#'
#' # With custom person
#' how_far(on_date = "2025-11-01", due_date = "2025-12-01", person = "Sarah")
#'
#' # Set global options
#' date_opt <- getOption("pregnancy.due_date") # save current option
#' set_due_date("2025-12-01")
#' how_far()
#' options(pregnancy.due_date = date_opt) # return original option
#'
#' @seealso [set_due_date()], [set_person()]
#' @export
how_far <- function(on_date = Sys.Date(), due_date = NULL, person = NULL) {
  # Calculate pregnancy statistics
  calc_results <- how_far_calculation(on_date = on_date, due_date = due_date)

  # Generate appropriate messages
  message_results <- how_far_message(
    calc_results = calc_results,
    on_date = on_date,
    person = person
  )

  # Print messages
  cli::cli_inform(c(
    "i" = message_results$messages[1]
  ))

  if (!is.na(message_results$messages[2])) {
    cli::cli_inform(c("i" = message_results$messages[2]))
    cli::cli_inform(c("i" = message_results$messages[3]))
  }

  # Return days along invisibly
  invisible(calc_results$days_along)
}
