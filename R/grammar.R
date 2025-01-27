# helper functions relating to grammar in message, e.g. name/pronoun, tense of verb
# get_subject(person)
# get_tense(date1, date2)
# to_be(person, tense)


# a reworking of person_pronoun
# used to pass into `to_be()`
# returns "You", "I" or person
get_subject <- function(person) {
  # having this condition separately makes it easier to write check_person()
  # as then check_person() can require a character vector
  if (length(person) == 1 && (person %in% 1:2)) person <- as.character(person)
  
  check_person(person)

  if (tolower(person) %in% c("i", "1", "1st", "first")) {
    return("I")
  } else if (tolower(person) %in% c("you", "2", "2nd", "second")) {
    return("You")
  } else {
    return(person)
  }
}

# used to pass into `to_be()`
# returns "You", "I" or person
# TODO: deprecate in favour of get_subject
person_pronoun <- function(person) {
  # having this condition separately makes it easier to write check_person()
  # as then check_person() can require a character vector
  if (length(person) == 1 && (person %in% 1:2)) person <- as.character(person)

  check_person(person)

  if (person %in% c("1st", "first", "First", "FIRST", "I", "i", "1")) {
    person <- "I"
  } else if (person %in% c("2nd", "second", "Second", "SECOND", "You", "you", "YOU", "2")) {
    person <- "You"
  }

  person
}

# used to pass into `to_be()`
get_tense <- function(date1, date2) {
  # date1 is typically `Sys.Date`
  # date2 is typically `on_date`
  # A positive diff means date2 is in the future

  check_date(date1)
  check_date(date2)

  diff <- date2 - date1

  if (diff > 0) {
    return("future")
  } else if (diff < 0) {
    return("past")
  } else {
    return("present")
  }
}

# `subject` should be the result of get_subject(person)
# (that is where checks on `person` take place, all possible ways of specifying 2nd person are reduced to "you",
# and similarly for "I")
# `tense` should be the result of tense(date1, date2)
to_be <- function(subject, tense = c("present", "past", "future")) {

  # tense should be result of get_tense(), so this is a belt-and-braces check
  tense <- rlang::arg_match(tense)

  # Assumes person has been through get_subject() first
  if (!(subject %in% c("I", "You"))) subject <- "She"

  # above conditions ensure that person and tense will always match a row and a column name
  # to_be_mat is in R/sysdata.rda
  to_be_mat[subject, tense]
}

# set_person
#' Get or set the pregnancy.person option for pregnancy-related messages
#'
#' @description
#' Functions to get and set the default person used in messages throughout the package.
#' This affects the grammar and pronouns used in various function outputs. Settings
#' persist for the current R session only, unless added to .Rprofile. `set_person()` sets the "pregnancy.person" option and `get_person()` retrieves it.
#'
#' @param person A character string or number specifying the person. Can be:
#'   * "I", "1", "1st", "first", or numeric 1 for first person
#'   * "you", "2", "2nd", "second", or numeric 2 for second person
#'   * Any other name for third person
#'   * NULL to unset the current value
#'
#' @return
#' Both functions invisibly return the current person setting:
#' * get_person() returns the current setting (a character string) or NULL if not set
#' * set_person() returns the person value that was set
#'
#' @seealso [how_far()] and other functions that use the person setting for message formatting
#'
#' @examples
#' # Store original setting
#' original_person <- getOption("pregnancy.person")
#'
#' # Check current setting
#' get_person()
#'
#' # Set to first person (using string)
#' set_person("I")
#' get_person()
#'
#' # Set to second person (using number)
#' set_person(2)
#' get_person()
#'
#' # Set to a specific name
#' set_person("Sarah")
#' get_person()
#'
#' # Restore original setting
#' set_person(original_person)
#'
#' @name person
NULL

#' @rdname person
#' @export
set_person <- function(person) {
  # checks person and turns any first/second person option to I/you
  if (!is.null(person)) {
    person <- get_subject(person)
  }

  options("pregnancy.person" = person)

  # TODO: different message if person = NULL
  cli::cli_alert_success("person set as '{person}'")
  set_option_message("person", person)
}

# get_person
#' @rdname person
#' @export
get_person <- function() {
  person <- getOption("pregnancy.person")

  if (is.null(person)) {
    null_option("person")
  } else {
    if (length(person) == 1 && (person %in% 1:2)) person <- as.character(person)
    check_person(person)
    cli::cli_inform("The person option is set as '{person}'.")
  }

  invisible(person)
}
