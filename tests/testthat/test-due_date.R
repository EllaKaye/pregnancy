# functions related to due date
# calculate_due_date(start_date, start_type, cycle)
# get_due_date()
# set_due_date(due_date)


# testing calculate_due_date() --------------------------------------------

test_that("start_date is correct format", {
  expect_error(calculate_due_date(2023 - 01 - 01), class = "pregnancy_error_class")
  expect_error(calculate_due_date("2023-01-01"), class = "pregnancy_error_class")
})

test_that("start_type matches arg", {
  start_date <- as.Date("2023-01-31")
  expect_error(calculate_due_date(start_date, start_type = "hello"), "must be one of")
})

test_that("cycle is allowed value", {
  start_date <- as.Date("2023-01-31")
  expect_error(calculate_due_date(start_date, cycle = "28"), class = "pregnancy_error_class_or_length")
  expect_error(calculate_due_date(start_date, cycle = 27:28), class = "pregnancy_error_class_or_length")
  expect_error(calculate_due_date(start_date, cycle = NULL), class = "pregnancy_error_class_or_length")
  expect_error(calculate_due_date(start_date, cycle = 19), class = "pregnancy_error_value")
  expect_error(calculate_due_date(start_date, cycle = 45), class = "pregnancy_error_value")
  expect_error(calculate_due_date(start_date, cycle = 27.5), class = "pregnancy_error_value")
})

# correct output from each start_type
test_that("correct due date for each start type", {
  start_date <- as.Date("2023-01-31")
  expect_equal(calculate_due_date(start_date), as.Date("2023-11-07"))
  expect_equal(calculate_due_date(start_date, "conception"), as.Date("2023-10-24"))
  expect_equal(calculate_due_date(start_date, "transfer_day_3"), as.Date("2023-10-21"))
  expect_equal(calculate_due_date(start_date, "transfer_day_5"), as.Date("2023-10-19"))
  expect_equal(calculate_due_date(start_date, "transfer_day_6"), as.Date("2023-10-18"))
})

test_that("due date for LMP adjusts with cycle", {
  start_date <- as.Date("2023-01-31")
  expect_equal(calculate_due_date(start_date, cycle = 27), as.Date("2023-11-06"))
  expect_equal(calculate_due_date(start_date, cycle = 29), as.Date("2023-11-08"))
})

test_that("calculate_due_date message", {
  start_date <- as.Date("2023-01-31")
  expect_snapshot(calculate_due_date(start_date))
})


# testing get_due_date() --------------------------------------------------
test_that("retreives date option", {
  withr::local_options(pregnancy.due_date = as.Date("2023-01-31"))
  expect_equal(get_due_date(), as.Date("2023-01-31"))
})

test_that("NULL if due_date not set", {
  withr::local_options(pregnancy.due_date = NULL)
  expect_null(get_due_date())
})

# snapshot tests for get_due_date (both when date is set and when NULL)

# testing set_due_date(due_date) ------------------------------------------
test_that("date option gets set", {
  starting_option <- getOption("pregnancy.due_date")
  options(pregnancy.due_date = NULL)
  set_due_date(as.Date("2023-04-30"))
  expect_equal(getOption("pregnancy.due_date"), as.Date("2023-04-30"))
  options(pregnancy.due_date = starting_option)
})

test_that("NULL option gets set", {
  starting_option <- getOption("pregnancy.due_date")
  options(pregnancy.due_date = as.Date("2023-04-30"))
  set_due_date(NULL)
  expect_null(getOption("pregnancy.due_date"))
  options(pregnancy.due_date = starting_option)
})

# snapshot tests for set_due_date (both when date is set and when NULL)
