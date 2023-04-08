# helper functions relating to grammar in message, e.g. name/pronoun, tense of verb
# person_pronoun(person)
# tense(date1, date2)
# to_be(person, tense)

# used to pass into `to_be()`
person_pronoun <- function(person) {

  if (length(person) == 1 && (person %in% 1:2)) person <- as.character(person)

  check_person(person)

  if (person %in% c("1st", "first", "I", "i", "1")) {person <- "I"}

  else if (person %in% c("2nd", "second", "You", "you", "YOU", "2")) {person <- "You"}

  person

}

# used to pass into `to_be()`
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

# Might want to do some checks
# Will definitely need tests!
# Make sure this is OK with capitalisation
to_be <- function(person, tense) {

  if (!(person %in% c("I", "You"))) person <- "She"

  `I` <- c("was", "am", "will be")
  You <- c("were", "are", "will be")
  She <- c("was", "is", "will be")

  to_be_mat <- rbind(`I`, You, She)

  colnames(to_be_mat) <- c("past", "present", "future")

  to_be_mat[person, tense]

}
