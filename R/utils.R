# (non-exported) helper functions for getting and checking due dates

date_abort_null <- function(date) {
  cli::cli_abort(c(
    "x" = "{.var {rlang::caller_arg(date)}} must have class {.cls Date}.",
    "i" = "It was {.type {date}} instead.",
    "i" = "You can {.emph EITHER} set the {.var {rlang::caller_arg(date)}} argument {.emph OR} (recommended) set {.code options(pregnancy.due_date)} in your .Rprofile.",
    "i" = "{.emph LINK TO OPTIONS MAN PAGE (ONCE WRITTEN!) FOR FURTHER DETAILS.}"
  ), call = rlang::caller_env())
}

check_person <- function(person) {

  if (!is_character(person, 1)) {

    message <- c(
      "{.var {rlang::caller_arg(person)}} must be a {.cls character} vector of length 1.",
      # change to class not type
      "i" = "It was {.type {person}} of length {length(person)} instead.")

    cli::cli_abort(message, call = rlang::caller_env())
  }

  #cat("Person", person)

}

check_date <- function(date) {

  message <- c(
    "{.var {rlang::caller_arg(date)}} must be a {.cls Date} vector of length 1.",
    "i" = "It was {.type {date}} of length {length(date)} instead.")

  if (length(date) != 1) {
    cli::cli_abort(message, call = rlang::caller_env())
  }

  if (!lubridate::is.Date(date)) {

    if (is.character(date)) {
      message <- c(message,  "i" = "You can parse a string as a date with {.fn base::as.Date} or {.fn lubridate::ymd}")
    }

    cli::cli_abort(message, call = rlang::caller_env())
  }
}



