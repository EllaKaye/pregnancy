# (non-exported) helper functions for getting and checking due dates
# date_abort_null(date)
# check_person(person)
# check_date(date)
# check_cycle(cycle)

# this throws an error regardless on the value of date
# the date argument is only to allow an informative error message when date_abort called within another function
date_abort <- function(date) {
  # TODO: link to documentation
  cli::cli_abort(
    c(
      "{.var {rlang::caller_arg(date)}} must have class {.cls Date}.",
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
# TODO: Make sure line of code for RProfile stands out - make it black,
# though this could be an issue depending on light/dark theme, so some cli function (e.g. cli_bullets) that is darker than inform
# TODO: Make sure functions that call this pass in `value` argument (and that it's parsed properly)
# TODO: Add a line about making sure the code to generate the value of `{option}` is also included in the .Rprofile
set_option_message <- function(option, value = NULL) {
  cli::cli_inform(
    c(
      "i" = "For this R session only, functions in the pregnancy package will now use this `{option}` option.",
      "i" = "So for now, you do not now need to supply a value to the `{option}` argument.",
      "i" = "To make this `{option}` option available in all R sessions, include this code in your {.val .Rprofile}:",
      " " = "options(pregnancy.{option} = {value})",
      "i" = "You can edit your {.val .Rprofile} by calling {.fn usethis::edit_r_profile}",
      "i" = "You can retreive the `{option}` option with {.fn get_{option}},",
      " " = "or with `getOption('pregnancy.{option}')`."
    )
  )
}

# Probably don't need this - use tests instead of in-function checks
# check_set <- function(option) {
#   option_string <- deparse(substitute(option))
#   pregnancy_option <- paste0("pregnancy.", option_string)
#
#   if (is.null(option) && !is.null(getOption(pregnancy_option))) {
#     cli::cli_abort("pregnancy.{option} option was not set to {.var {option_string}}")
#   pregancy_option
#   }
#
#   if (!is.null(option) && getOption(pregnancy_option) != option) {
#     cli::cli_abort("pregnancy.{option} option was not set to {.var {option_string}}")
#   }
#
#   invisible(option)
#
# }

# TODO: finish message in this function, to use in get_{option} functions
# TODO: use it in all get_{option} function
null_option <- function(option) {
 # message when getOption(pregnancy.{option}) is null
  cli::cli_bullets(
    c("!" = "You do not have {.code pregnancy.{option}} set as an option.",
      "i" = "You can set it by...")
  )
}

# TODO: write this function, to use in set_{option} functions
# set_option_null_message <- function(option) {
#
# }
