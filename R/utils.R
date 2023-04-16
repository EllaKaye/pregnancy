# (non-exported) helper functions for getting and checking due dates
# date_abort_null(date)
# check_person(person)
# check_date(date)
# check_cycle(cycle)

# this throws an error regardless on the value of date
# the date argument is only to allow an informative error message when date_abort called within another function
date_abort <- function(date) {
  cli::cli_abort(
    c(
      "x" = "{.var {rlang::caller_arg(date)}} must have class {.cls Date}.",
      "i" = "It was {.type {date}} instead.",
      "i" = "You can {.emph EITHER} set the {.var {rlang::caller_arg(date)}} argument {.emph OR} (recommended) set {.code options(pregnancy.{rlang::caller_arg(date)})} in your .Rprofile.",
      "i" = "{.emph LINK TO OPTIONS MAN PAGE (ONCE WRITTEN!) FOR FURTHER DETAILS.}"
    ),
    call = rlang::caller_env(),
    class = "pregnancy_error_date"
  )
}

check_date <- function(date) {
  message <-
    c("{.var {rlang::caller_arg(date)}} must be a {.cls Date} vector of length 1.",
      "i" = "It was {.type {date}} of length {length(date)} instead.")

  if (length(date) != 1) {
    cli::cli_abort(message,
                   call = rlang::caller_env(),
                   class = "pregnancy_error_length")
  }

  # picks up cases where lubridate fails to parse date (returns NA with a warning)
  # (as.Date() will throw an error if it cannot parse date)
  if (!is.null(date)) {
    # need this as is.na(NULL) throws an error
    if (is.na(date)) {
      cli::cli_abort(
        c("{.var {rlang::caller_arg(date)}} was {.class {date}}"),
        call = rlang::caller_env(),
        class = "pregnancy_error_value"
      )
    }
  }

  if (!lubridate::is.Date(date)) {
    if (is.character(date)) {
      message <-
        c(message,  "i" = "You can parse a string as a date with {.fn base::as.Date} or {.fn lubridate::ymd}")
    }

    cli::cli_abort(message,
                   call = rlang::caller_env(),
                   class = "pregnancy_error_class")
  }

  invisible(date)
}

check_person <- function(person) {
  if (!rlang::is_character(person, 1)) {
    message <- c(
      "{.var {rlang::caller_arg(person)}} must be a {.cls character} vector of length 1.",
      # change to class not type
      "i" = "It was {.type {person}} of length {length(person)} instead."
    )

    cli::cli_abort(message,
                   call = rlang::caller_env(),
                   class = "pregnancy_error_class_or_length")
  }

  invisible(person)

}

check_cycle <- function(cycle) {
  if (length(cycle) != 1 | !is.numeric(cycle)) {
    message <- c(
      "{.var {rlang::caller_arg(cycle)}} must be a {.cls numeric} vector of length 1.",
      "i" = "It was {.cls {cycle}} of length {length(cycle)} instead."
    )

    cli::cli_abort(message,
                   call = rlang::caller_env(),
                   class = "pregnancy_error_class_or_length")
  }

  if (!(cycle %in% 20:44)) {
    cli::cli_abort(
      "{.var {rlang::caller_arg(cycle)}} must be an integer between 20 and 44 (inclusive).",
      call = rlang::caller_env(),
      class = "pregnancy_error_value"
    )
  }

  invisible(cycle)
}

# TODO: Write line about editing RProfile
set_option_message <- function(option) {
  cli::cli_inform(
    c(
      "i" = "Functions in the pregnancy package will now use this `{option}` option.",
      "i" = "You do not now need to supply a value to the `{option}` argument.",
      "i" = "This option setting only holds for this R session.",
      "i" = "To set the `{option}` option to persist across R sessions,",
      " " = "SAY SOMETHING ABOUT EDITING RPROFILE...",
      "i" = "You can retreive the set {option} with `get_{option}()`,",
      " " = "or with `getOption('pregnancy.{option}')`."
    )
  )
}

# TODO: write this function
# set_option_null_message <- function(option) {
#
# }
