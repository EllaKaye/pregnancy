# helper functions relating to grammar in message, e.g. name/pronoun, tense of verb
# person_pronoun(person)
# tense(date1, date2)
# to_be(person, tense)

# used to pass into `to_be()`
person_pronoun <- function(person) {

  # having this condition separately makes it easier to write check_person()
  # as then check_person() can require a character vector
  if (length(person) == 1 && (person %in% 1:2)) person <- as.character(person)

  check_person(person)

  if (person %in% c("1st", "first", "First", "FIRST", "I", "i", "1")) {person <- "I"}

  else if (person %in% c("2nd", "second", "Second", "SECOND", "You", "you", "YOU", "2")) {person <- "You"}

  person

}

# used to pass into `to_be()`
tense <- function(date1, date2) {

  # date1 is typically `Sys.Date`
  # date2 is typically `on_date`
  # A positive diff means date2 is in the future

  check_date(date1)
  check_date(date2)

  diff <- date2 - date1

  if (diff > 0) out <- "future"
  else if (diff < 0) out <- "past"
  else out <- "present"

  out
}

# `person` must have been through `person_pronoun(person)` first
# (that is where checks on `person` take place, all possible ways of specifying 2nd person are reduced to "You",
# and similarly for "I")
# `tense` should be the result of tense(date1, date2)
to_be <- function(person, tense = c("present", "past", "future")) {

  # person should have been through person_pronoun, and hence check_person first
  # but just being extra careful here
  # this only ensures that person is a character vector of length 1
  # not that the 'right' pronoun will be picked
  check_person(person)

  tense <- rlang::arg_match(tense)

  # Assumes person has been through person_pronoun() first
  if (!(person %in% c("I", "You"))) person <- "She"

  `I` <- c("was", "am", "will be")
  You <- c("were", "are", "will be")
  She <- c("was", "is", "will be")

  to_be_mat <- rbind(`I`, You, She)

  colnames(to_be_mat) <- c("past", "present", "future")

  # above conditions ensure that person and tense will always match a row and a column name
  to_be_mat[person, tense]

}

# TODO: get/set_meds person
# set_person
# get_person
