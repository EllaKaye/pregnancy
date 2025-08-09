# helper functions relating to grammar in message, e.g. name/pronoun, tense of verb
# person_pronoun(person)
# get_tense(date1, date2)
# to_be(person, tense)

# testing tense(date1, date2) ---------------------------------------------

test_that("dates are Dates", {
  expect_error(
    get_tense("2023-01-01", as.Date("2023-01-01")),
    class = "pregnancy_error_class"
  )
  expect_error(
    get_tense(as.Date("2023-01-01"), "2023-01-01"),
    class = "pregnancy_error_class"
  )
})

test_that("dates are length 1", {
  expect_error(
    get_tense(
      c(as.Date("2023-01-01"), as.Date("2023-01-01")),
      as.Date("2023-01-01")
    ),
    class = "pregnancy_error_length"
  )
  expect_error(
    get_tense(
      as.Date("2023-01-01"),
      c(as.Date("2023-01-01"), as.Date("2023-01-01"))
    ),
    class = "pregnancy_error_length"
  )
})

test_that("date diff gives expected tense", {
  expect_equal(get_tense(as.Date("2023-12-12"), as.Date("2023-01-01")), "past")
  expect_equal(
    get_tense(as.Date("2023-01-01"), as.Date("2023-12-12")),
    "future"
  )
  expect_equal(
    get_tense(as.Date("2023-01-01"), as.Date("2023-01-01")),
    "present"
  )
})


# testing to_be(person, tense) --------------------------------------------

# TODO: snapshot test
# test_that("un-matched tense throws error", {
#  expect_error(to_be("futuree"), regexp = "tense")
# })
# may need snapshot test here

# N.B. `person` should have been through `get_subject(person)` first (hence also `check_person()`)
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
