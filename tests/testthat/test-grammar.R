# helper functions relating to grammar in message, e.g. name/pronoun, tense of verb
# person_pronoun(person)
# tense(date1, date2)
# to_be(person, tense)


# testing person_pronoun(person) ---------------------------------------------

test_that("1 and 2 are allowed", {
  expect_equal(person_pronoun(1), "I")
  expect_equal(person_pronoun(2), "You")
})

test_that("person is a character vector of length 1", {
  expect_equal(person_pronoun("Ella"), "Ella")
  expect_error(person_pronoun(c("Me", "You")), class = "pregnancy_error_class_or_length")
  expect_error(person_pronoun(3), class = "pregnancy_error_class_or_length")
  expect_error(person_pronoun(NULL), class = "pregnancy_error_class_or_length")
})

test_that("first person gives 'I'", {
  expect_equal(person_pronoun("1st"), "I")
  expect_equal(person_pronoun("first"), "I")
  expect_equal(person_pronoun("First"), "I")
  expect_equal(person_pronoun("FIRST"), "I")
  expect_equal(person_pronoun("I"), "I")
  expect_equal(person_pronoun("i"), "I")
  expect_equal(person_pronoun("1"), "I")
  expect_equal(person_pronoun("II"), "II")
})

test_that("second person gives 'You'", {
  expect_equal(person_pronoun("2nd"), "You")
  expect_equal(person_pronoun("second"), "You")
  expect_equal(person_pronoun("Second"), "You")
  expect_equal(person_pronoun("SECOND"), "You")
  expect_equal(person_pronoun("You"), "You")
  expect_equal(person_pronoun("you"), "You")
  expect_equal(person_pronoun("YOU"), "You")
  expect_equal(person_pronoun("2"), "You")
  expect_equal(person_pronoun("Youu"), "Youu")
})


# testing tense(date1, date2) ---------------------------------------------

test_that("dates are Dates", {
  expect_error(tense("2023-01-01", as.Date("2023-01-01")), class = "pregnancy_error_class")
  expect_error(tense(as.Date("2023-01-01"), "2023-01-01"), class = "pregnancy_error_class")
})

test_that("dates are length 1", {
  expect_error(tense(c(as.Date("2023-01-01"), as.Date("2023-01-01")), as.Date("2023-01-01")), class = "pregnancy_error_length")
  expect_error(tense(as.Date("2023-01-01"), c(as.Date("2023-01-01"), as.Date("2023-01-01"))), class = "pregnancy_error_length")
})

test_that("date diff gives expected tense", {
  expect_equal(tense(as.Date("2023-12-12"), as.Date("2023-01-01")), "past")
  expect_equal(tense(as.Date("2023-01-01"), as.Date("2023-12-12")), "future")
  expect_equal(tense(as.Date("2023-01-01"), as.Date("2023-01-01")), "present")
})


# testing to_be(person, tense) --------------------------------------------

# TODO: snapshot test
# test_that("un-matched tense throws error", {
#  expect_error(to_be("futuree"), regexp = "tense")
# })
# may need snapshot test here

# N.B. `person` should have been through `person_pronoun(person)` first (hence also `check_person()`)
test_that("get correct verb given person and tense", {
  expect_equal(to_be("I"), "am")
  expect_equal(to_be("You"), "are")
  expect_equal(to_be("She"), "is")
  expect_equal(to_be("I", "past"), "was")
  expect_equal(to_be("I", "present"), "am")
  expect_equal(to_be("I", "future"), "will be")
  expect_equal(to_be("You", "past"), "were")
  expect_equal(to_be("You", "present"), "are")
  expect_equal(to_be("You", "future"), "will be")
  expect_equal(to_be("She", "past"), "was")
  expect_equal(to_be("She", "present"), "is")
  expect_equal(to_be("She", "future"), "will be")
})
