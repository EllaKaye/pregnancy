# date_abort(date)
# check_date(date)
# check_person(person)
# check_cycle(cycle)

# testing date_abort(date) ------------------------------------------------
# use snapshot test
# WAIT UNTIL DECIDED ON MESSAGE!

# testing check_date(date) -----------------------------------------------------

test_that("date is length 1", {
  expect_equal(check_date(as.Date("2023-01-01")), as.Date("2023-01-01"))
  expect_error(check_date(NULL), class = "pregnancy_error_length")
  expect_error(check_date(c(as.Date("2023-01-01"), as.Date("2023-01-02"))), class = "pregnancy_error_length")
})

test_that("date is a Date", {
  expect_error(check_date(2023-01-01), class = "pregnancy_error_class")
  expect_error(check_date("2023-01-01"), class = "pregnancy_error_class")
})

# testing check_person(person) -------------------------------------------------

test_that("person is character of length 1", {
  expect_equal(check_person("Ella"), "Ella")
  expect_error(check_person(1), class = "pregnancy_error_class_or_length")
  expect_error(check_person(c("Me", "You")), class = "pregnancy_error_class_or_length")
})

# testing check_cycle(cycle) ---------------------------------------------------

test_that("cycle is numeric of length 1", {
  expect_equal(check_cycle(28), 28)
  expect_equal(check_cycle(28L), 28)
  expect_error(check_cycle("28"), class = "pregnancy_error_class_or_length")
  expect_error(check_cycle(27:28), class = "pregnancy_error_class_or_length")
  expect_error(check_cycle(NULL), class = "pregnancy_error_class_or_length")
})

test_that("cycle is in the allowed range", {
  expect_error(check_cycle(19), class = "pregnancy_error_value")
  expect_error(check_cycle(45), class = "pregnancy_error_value")
  expect_error(check_cycle(27.5), class = "pregnancy_error_value")
})


