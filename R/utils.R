# (non-exported) helper functions for getting and checking due dates

date_abort_null <- function(date) {
  cli::cli_abort(c(
    "x" = "{.var {rlang::caller_arg(date)}} must have class {.cls Date}.",
    "i" = "It was {.type {date}} instead.",
    "i" = "You can {.emph EITHER} set the {.var {rlang::caller_arg(date)}} argument {.emph OR} (recommended) set {.code options(pregnancy.due_date)} in your .Rprofile.",
    "i" = "{.emph LINK TO OPTIONS MAN PAGE (ONCE WRITTEN!) FOR FURTHER DETAILS.}"
  ), call = rlang::caller_env())
}

person_pronoun <- function(person) {

  if (person %in% c("1st", "first", "I", "i")) {person <- "I"}

  else if (person %in% c("2nd", "second", "You", "you", "YOU")) {person <- "You"}

  person

}

# used to pass into `get_to_be()`
tense <- function(date1, date2) {

  # date1 is typically `on_date` (default to Sys.Date)
  # date2 is typically `due_date`
  # Therefore positive diff means due date is in the future

  check_date(date1)
  check_date(date2)

  diff <- date2 - date1

  if (diff > 0) out <- "future"
  else if (diff < 0) out <- "past"
  else out <- "present"

  out
}

get_to_be <- function(person, tense) {

  if (!(person %in% c("I", "You"))) person <- "She"

  `I` <- c("was", "am", "will be")
  You <- c("were", "are", "will be")
  She <- c("was", "is", "will be")

  to_be <- rbind(`I`, You, She)

  colnames(to_be) <- c("past", "present", "future")

  to_be[person, tense]

}

check_date <- function(date) {

  # TODO: check has length 1

  if (!lubridate::is.Date(date)) {

    message <- c(
      "{.var {rlang::caller_arg(date)}} must have class {.cls Date}.",
      "i" = "It was {.type {date}} instead.")

    if (is.character(date)) {
      message <- c(message,  "i" = "You can parse a string as a date with {.fn base::as.Date} or {.fn lubridate::ymd}")
    }

    cli::cli_abort(message, call = rlang::caller_env())
  }
}


