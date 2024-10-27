# functions relating to test date
# calculate_test_date()
# set_test_date()
# get_test_date()
# days_until_test_date() or two_week_wait()

# testing calculate_test_date() --------------------------------------------

test_that("start_date is correct format", {
  expect_error(calculate_test_date(2023 - 01 - 01), class = "pregnancy_error_class")
  expect_error(calculate_test_date("2023-01-01"), class = "pregnancy_error_class")
})

test_that("start_type matches arg", {
  start_date <- as.Date("2023-01-31")
  expect_error(calculate_test_date(start_date, start_type = "hello"), "must be one of")
})

test_that("cycle is allowed value", {
  start_date <- as.Date("2023-01-31")
  expect_error(calculate_test_date(start_date, cycle = "28"), class = "pregnancy_error_class_or_length")
  expect_error(calculate_test_date(start_date, cycle = 27:28), class = "pregnancy_error_class_or_length")
  expect_error(calculate_test_date(start_date, cycle = NULL), class = "pregnancy_error_class_or_length")
  expect_error(calculate_test_date(start_date, cycle = 19), class = "pregnancy_error_value")
  expect_error(calculate_test_date(start_date, cycle = 45), class = "pregnancy_error_value")
  expect_error(calculate_test_date(start_date, cycle = 27.5), class = "pregnancy_error_value")
})

test_that("correct test date for each start type", {
  start_date <- as.Date("2023-01-31")
  expect_equal(calculate_test_date(start_date), as.Date("2023-02-28"))
  expect_equal(calculate_test_date(start_date, "conception"), as.Date("2023-02-14"))
  expect_equal(calculate_test_date(start_date, "transfer_day_3"), as.Date("2023-02-11"))
  expect_equal(calculate_test_date(start_date, "transfer_day_5"), as.Date("2023-02-09"))
  expect_equal(calculate_test_date(start_date, "transfer_day_6"), as.Date("2023-02-08"))
})

test_that("correct output for test_type = 'blood'", {
  start_date <- as.Date("2023-01-31")
  expect_equal(calculate_test_date(start_date, test_type = "blood"), as.Date("2023-02-26"))
})

test_that("test date for LMP adjusts with cycle", {
  start_date <- as.Date("2023-01-31")
  expect_equal(calculate_test_date(start_date, cycle = 27), as.Date("2023-02-27"))
  expect_equal(calculate_test_date(start_date, cycle = 29), as.Date("2023-03-01"))
})

test_that("calculate_test_date message", {
  start_date <- as.Date("2023-01-31")
  expect_snapshot(calculate_test_date(start_date))
})


# testing get_test_date() --------------------------------------------------
test_that("retreives test_date option when set", {
  withr::local_options(pregnancy.test_date = as.Date("2023-01-31"))
  expect_equal(get_test_date(), as.Date("2023-01-31"))
})

test_that("NULL if test_date not set", {
  withr::local_options(pregnancy.test_date = NULL)
  expect_equal(get_test_date(), NULL)
})

# snapshot tests for get_test_date (both when date is set and when NULL)
# TODO: add these when I've improved the message!

# testing set_test_date(test_date) ------------------------------------------
# How to do this?
