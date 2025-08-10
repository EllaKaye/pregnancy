# (non-exported) helper functions for getting and checking due dates
# date_stop_null(date)
# check_person(person)
# check_date(date)
# check_cycle(cycle)

# this throws an error regardless on the value of date
# the date argument is only to allow an informative error message when date_stop called within another function
date_stop <- function(date) {
  cli::cli_abort(
    c(
      "{.var {rlang::caller_arg(date)}} must have class {.cls Date}.",
      "i" = "It was {.type {date}} instead.",
      "i" = "You can do one of the following:",
      "*" = "set the {.var {rlang::caller_arg(date)}} argument",
      "*" = "set the 'pregnancy.due_date' option for this R session with {.code set_due_date({rlang::caller_arg(date)})}",
      "*" = "({.emph recommended}) set {.code options(pregnancy.{rlang::caller_arg(date)})} in your {.var .Rprofile}.",
      "i" = "See the {.vignette pregnancy::pregnancy} vignette for further details."
    ),
    call = rlang::caller_env(),
    class = "pregnancy_error_date"
  )
}

check_date <- function(date) {
  message <-
    c(
      "{.var {rlang::caller_arg(date)}} must be a {.cls Date} vector of length 1.",
      "i" = "It was {.type {date}} of length {length(date)} instead."
    )

  if (length(date) != 1) {
    cli::cli_abort(
      message,
      call = rlang::caller_env(),
      class = "pregnancy_error_length"
    )
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
        c(
          message,
          "i" = "You can parse a string as a date with {.fn base::as.Date} or {.fn lubridate::ymd}"
        )
    }

    cli::cli_abort(
      message,
      call = rlang::caller_env(),
      class = "pregnancy_error_class"
    )
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

    cli::cli_abort(
      message,
      call = rlang::caller_env(),
      class = "pregnancy_error_class_or_length"
    )
  }

  invisible(person)
}

check_cycle <- function(cycle) {
  if (length(cycle) != 1 || !is.numeric(cycle)) {
    message <- c(
      "{.var {rlang::caller_arg(cycle)}} must be a {.cls numeric} vector of length 1.",
      "i" = "It was {.cls {cycle}} of length {length(cycle)} instead."
    )

    cli::cli_abort(
      message,
      call = rlang::caller_env(),
      class = "pregnancy_error_class_or_length"
    )
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

set_option_message <- function(option) {
  cli::cli_inform(
    c(
      "i" = "Functions in the pregnancy package will now use this `{option}` option.",
      "i" = "So, for this R session, you do not need to supply a value to the `{option}` argument (unless you wish to override the option).",
      "i" = "To make this `{option}` option available in all R sessions, in your {.val .Rprofile},  set `options(pregnancy.{option} = ...)`",
      " " = "where ... is the value of `{option}`.",
      "i" = "You can edit your {.val .Rprofile} by calling {.fn usethis::edit_r_profile}",
      "i" = "You can retrieve the `{option}` option with {.fn get_{option}},",
      " " = "or with `getOption('pregnancy.{option}')`."
    )
  )
}

set_option_null_message <- function(option) {
  cli::cli_alert_success("pregnancy.{option} option set to NULL.")

  if (option == "person") {
    cli::cli_inform(
      c(
        "i" = 'The `person` argument will now default to "You".'
      )
    )
  } else {
    cli::cli_inform(
      c(
        "i" = "You will need to explicitly pass a value to the `{option}` argument",
        " " = "in functions that use it, or reset the option with {.fn set_{option}}."
      )
    )
  }
}

# Probably don't need this - use tests instead of in-function checks
# check_set <- function(option) {
#   option_string <- deparse(substitute(option))
#   pregnancy_option <- paste0("pregnancy.", option_string)
#
#   if (is.null(option) && !is.null(getOption(pregnancy_option))) {
#     cli::cli_abort("pregnancy.{option} option was not set to {.var {option_string}}")
#   pregnancy_option
#   }
#
#   if (!is.null(option) && getOption(pregnancy_option) != option) {
#     cli::cli_abort("pregnancy.{option} option was not set to {.var {option_string}}")
#   }
#
#   invisible(option)
#
# }

null_option <- function(option) {
  # message when getOption(pregnancy.{option}) is null
  cli::cli_alert_warning(
    "You do not have {.code pregnancy.{option}} set as an option."
  )

  if (option == "person") {
    cli::cli_alert_info('The `person` argument defaults to "You".')
  } else {
    cli::cli_inform(
      c(
        "i" = "You can set it with {.fn set_{option}}.",
        "i" = "You can also pass a value directly to the {.code {option}} argument where required."
      )
    )
  }
}
