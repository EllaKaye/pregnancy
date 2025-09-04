# testing get_subject(person) ------------------------------------------

test_that("get_subject handles numeric 1 and 2", {
  expect_equal(get_subject(1), "I")
  expect_equal(get_subject(2), "You")
})

test_that("get_subject handles first person variations", {
  expect_equal(get_subject("I"), "I")
  expect_equal(get_subject("i"), "I")
  expect_equal(get_subject("1"), "I")
  expect_equal(get_subject("1st"), "I")
  expect_equal(get_subject("first"), "I")
})

test_that("get_subject handles second person variations", {
  expect_equal(get_subject("You"), "You")
  expect_equal(get_subject("you"), "You")
  expect_equal(get_subject("2"), "You")
  expect_equal(get_subject("2nd"), "You")
  expect_equal(get_subject("second"), "You")
})

test_that("get_subject returns names unchanged", {
  expect_equal(get_subject("Sarah"), "Sarah")
  expect_equal(get_subject("Emma"), "Emma")
  expect_equal(get_subject("Dr. Smith"), "Dr. Smith")
})

test_that("get_subject calls check_person for validation", {
  expect_error(
    get_subject(c("Sarah", "Emma")),
    class = "pregnancy_error_class_or_length"
  )
  expect_error(get_subject(3), class = "pregnancy_error_class_or_length")
})

# testing get_tense(date1, date2) ---------------------------------------------

test_that("character dates are allowed", {
  expect_equal(get_tense("2023-01-01", "2023-01-01"), "present")
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


# testing set_person(person) ------------------------------------------
test_that("person option gets set", {
  starting_option <- getOption("pregnancy.person")
  options(pregnancy.person = NULL)
  suppressMessages(set_person("Ella"))
  expect_equal(getOption("pregnancy.person"), "Ella")
  options(pregnancy.person = starting_option)
})


test_that("NULL option gets set", {
  starting_option <- getOption("pregnancy.person")
  options(pregnancy.person = "Ella")
  suppressMessages(set_person(NULL))
  expect_null(getOption("pregnancy.person"))
  options(pregnancy.person = starting_option)
})

# testing get_person() --------------------------------------------------
test_that("retreives person option", {
  withr::local_options(pregnancy.person = "Ella")
  expect_equal(suppressMessages(get_person()), "Ella")
})

test_that("NULL if person not set", {
  withr::local_options(pregnancy.person = NULL)
  expect_null(suppressMessages(get_person()))
})

test_that("get_person handles numeric person options", {
  # Test when person option is set as numeric 1
  withr::local_options(pregnancy.person = 1)
  result <- suppressMessages(get_person())
  expect_equal(result, "1") # Should be converted to character

  # Test when person option is set as numeric 2
  withr::local_options(pregnancy.person = 2)
  result <- suppressMessages(get_person())
  expect_equal(result, "2") # Should be converted to character
})
