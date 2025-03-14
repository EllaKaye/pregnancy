# functions relating to test date
# calculate_test_date()
# set_test_date()
# get_test_date()
# days_until_test_date() or two_week_wait()

# testing calculate_test_date() --------------------------------------------

test_that("start_date is correct format", {
  expect_error(
    calculate_test_date(2023 - 01 - 01),
    class = "pregnancy_error_class"
  )
  expect_error(
    calculate_test_date("2023-01-01"),
    class = "pregnancy_error_class"
  )
})

test_that("start_type matches arg", {
  start_date <- as.Date("2023-01-31")
  expect_error(
    calculate_test_date(start_date, start_type = "hello"),
    "must be one of"
  )
})

test_that("cycle is allowed value", {
  start_date <- as.Date("2023-01-31")
  expect_error(
    calculate_test_date(start_date, cycle = "28"),
    class = "pregnancy_error_class_or_length"
  )
  expect_error(
    calculate_test_date(start_date, cycle = 27:28),
    class = "pregnancy_error_class_or_length"
  )
  expect_error(
    calculate_test_date(start_date, cycle = NULL),
    class = "pregnancy_error_class_or_length"
  )
  expect_error(
    calculate_test_date(start_date, cycle = 19),
    class = "pregnancy_error_value"
  )
  expect_error(
    calculate_test_date(start_date, cycle = 45),
    class = "pregnancy_error_value"
  )
  expect_error(
    calculate_test_date(start_date, cycle = 27.5),
    class = "pregnancy_error_value"
  )
})

test_that("correct test date for each start type", {
  start_date <- as.Date("2023-01-31")
  expect_equal(calculate_test_date(start_date), as.Date("2023-02-28"))
  expect_equal(
    calculate_test_date(start_date, "conception"),
    as.Date("2023-02-14")
  )
  expect_equal(
    calculate_test_date(start_date, "transfer_day_3"),
    as.Date("2023-02-11")
  )
  expect_equal(
    calculate_test_date(start_date, "transfer_day_5"),
    as.Date("2023-02-09")
  )
  expect_equal(
    calculate_test_date(start_date, "transfer_day_6"),
    as.Date("2023-02-08")
  )
})

test_that("correct output for test_type = 'blood'", {
  start_date <- as.Date("2023-01-31")
  expect_equal(
    calculate_test_date(start_date, test_type = "blood"),
    as.Date("2023-02-26")
  )
})

test_that("test date for LMP adjusts with cycle", {
  start_date <- as.Date("2023-01-31")
  expect_equal(
    calculate_test_date(start_date, cycle = 27),
    as.Date("2023-02-27")
  )
  expect_equal(
    calculate_test_date(start_date, cycle = 29),
    as.Date("2023-03-01")
  )
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

# Test suite for get_test_date() and set_test_date() functions

# testing get_test_date() --------------------------------------------------
test_that("get_test_date retrieves test_date option", {
  withr::local_options(pregnancy.test_date = as.Date("2023-01-31"))
  expect_equal(get_test_date(), as.Date("2023-01-31"))
})

test_that("get_test_date returns NULL if test_date not set", {
  withr::local_options(pregnancy.test_date = NULL)
  expect_null(get_test_date())
})

test_that("get_test_date informs about current test date setting", {
  withr::local_options(pregnancy.test_date = as.Date("2023-02-15"))

  # Test that the message is informative about the current test date
  expect_message(
    get_test_date(),
    "Your test date is set as February 15, 2023"
  )
})

test_that("get_test_date informs when test date is not set", {
  withr::local_options(pregnancy.test_date = NULL)

  # Test that the message warns about missing option
  expect_snapshot(
    get_test_date()
  )
})

# testing set_test_date(test_date) ------------------------------------------
test_that("set_test_date sets test_date option", {
  # Store original option
  original_option <- getOption("pregnancy.test_date")
  withr::defer(options(pregnancy.test_date = original_option))

  # Set option to NULL first to ensure clean state
  options(pregnancy.test_date = NULL)

  # Test setting the option
  set_test_date(as.Date("2023-04-30"))
  expect_equal(getOption("pregnancy.test_date"), as.Date("2023-04-30"))
})

test_that("set_test_date sets test_date to NULL", {
  # Store original option
  original_option <- getOption("pregnancy.test_date")
  withr::defer(options(pregnancy.test_date = original_option))

  # Set option to a date first
  options(pregnancy.test_date = as.Date("2023-04-30"))

  # Test setting the option to NULL
  set_test_date(NULL)
  expect_null(getOption("pregnancy.test_date"))
})

test_that("set_test_date validates date input", {
  # Test with invalid date types
  expect_error(
    set_test_date("2023-04-30"),
    class = "pregnancy_error_class"
  )

  expect_error(
    set_test_date(c(as.Date("2023-04-30"), as.Date("2023-05-01"))),
    class = "pregnancy_error_length"
  )

  expect_error(
    set_test_date(NA),
    class = "pregnancy_error_value"
  )
})

test_that("get_test_date informs when test date is not set", {
  withr::local_options(pregnancy.test_date = NULL)

  # Use snapshot testing to capture the full formatted output
  expect_snapshot(
    get_test_date()
  )
})

test_that("set_test_date provides appropriate messages", {
  # Store original option to restore it later
  original_option <- getOption("pregnancy.test_date")
  withr::defer(options(pregnancy.test_date = original_option))

  # Test that setting a date provides expected output
  expect_snapshot(
    set_test_date(as.Date("2023-04-30"))
  )

  # Test that setting NULL provides expected output
  expect_snapshot(
    set_test_date(NULL)
  )
})

test_that("set_test_date returns the set date invisibly", {
  # Test that the function returns the date invisibly
  test_date <- as.Date("2023-04-30")
  expect_equal(
    suppressMessages(set_test_date(test_date)),
    test_date
  )

  # Test that NULL is returned invisibly when setting NULL
  expect_null(
    suppressMessages(set_test_date(NULL))
  )
})
