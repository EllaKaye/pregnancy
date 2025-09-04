test_that("date_when_calculation returns correct structure", {
  due_date <- as.Date("2024-09-01")
  today <- as.Date("2024-01-01")

  result <- date_when_calculation(
    weeks = 12,
    due_date = due_date,
    today = today
  )

  expect_type(result, "list")
  expect_named(result, c("total_days", "date_when"))
  expect_type(result$total_days, "integer")
  expect_s3_class(result$date_when, "Date")
})

test_that("date_when_calculation calculates dates correctly", {
  due_date <- as.Date("2024-09-01")
  today <- as.Date("2024-01-01")

  # Test basic calculation
  result <- date_when_calculation(
    weeks = 12,
    due_date = due_date,
    today = today
  )

  # Pregnancy starts 280 days before due date
  start_date <- due_date - 280
  expected_date <- start_date + (12 * 7)

  expect_equal(result$date_when, expected_date)
})

test_that("date_when_calculation calculates total_days correctly", {
  due_date <- as.Date("2024-09-01")
  today <- as.Date("2024-01-01")

  result <- date_when_calculation(
    weeks = 12,
    due_date = due_date,
    today = today
  )

  # Calculate expected total_days
  start_date <- due_date - 280
  expected_date <- start_date + (12 * 7)
  expected_total_days <- abs(as.integer(difftime(
    expected_date,
    today,
    units = "days"
  )))

  expect_equal(result$total_days, expected_total_days)
})

test_that("date_when_calculation works with different weeks", {
  due_date <- as.Date("2024-09-01")
  today <- as.Date("2024-01-01")

  # Test week 0 (start of pregnancy)
  result_0 <- date_when_calculation(
    weeks = 0,
    due_date = due_date,
    today = today
  )
  expect_equal(result_0$date_when, due_date - 280)

  # Test week 40 (due date)
  result_40 <- date_when_calculation(
    weeks = 40,
    due_date = due_date,
    today = today
  )
  expect_equal(result_40$date_when, due_date)

  # Test fractional weeks
  result_12_5 <- date_when_calculation(
    weeks = 12.5,
    due_date = due_date,
    today = today
  )
  start_date <- due_date - 280
  expected_date <- start_date + (12.5 * 7)
  expect_equal(result_12_5$date_when, expected_date)
})

test_that("date_when_calculation handles past, present, and future dates", {
  due_date <- as.Date("2024-09-01")

  # Test past date (date_when before today)
  today_future <- as.Date("2024-08-01")
  result_past <- date_when_calculation(
    weeks = 12,
    due_date = due_date,
    today = today_future
  )
  expect_gte(result_past$total_days, 0)

  # Test future date (date_when after today)
  today_past <- as.Date("2023-12-01")
  result_future <- date_when_calculation(
    weeks = 12,
    due_date = due_date,
    today = today_past
  )
  expect_gte(result_future$total_days, 0)
})

test_that("date_when_calculation uses due_date from options when NULL", {
  # Set option and test
  withr::local_options(pregnancy.due_date = as.Date("2024-09-01"))

  today <- as.Date("2024-01-01")
  result <- date_when_calculation(weeks = 12, due_date = NULL, today = today)

  due_date <- as.Date("2024-09-01")
  start_date <- due_date - 280
  expected_date <- start_date + (12 * 7)
  expect_equal(result$date_when, expected_date)
})

test_that("date_when_calculation throws error when due_date is NULL and no option set", {
  # Clear option
  withr::local_options(pregnancy.due_date = NULL)

  expect_error(
    date_when_calculation(
      weeks = 12,
      due_date = NULL,
      today = as.Date("2024-01-01")
    ),
    class = "rlang_error"
  )
})

test_that("date_when_calculation accepts date strings", {
  due_date <-
    # Test invalid today parameter
    expect_equal(
      date_when_calculation(
        weeks = 12,
        due_date = "2025-12-01",
        today = "2025-11-01"
      )$total_days,
      166
    )
})

test_that("date_when_calculation uses Sys.Date() as default today", {
  due_date <- as.Date("2024-09-01")

  # Mock Sys.Date() to a known date for testing
  local_mocked_bindings(Sys.Date = function() as.Date("2024-01-01"))

  result <- date_when_calculation(weeks = 12, due_date = due_date)

  start_date <- due_date - 280
  expected_date <- start_date + (12 * 7)
  expected_total_days <- abs(as.integer(difftime(
    expected_date,
    as.Date("2024-01-01"),
    units = "days"
  )))

  expect_equal(result$total_days, expected_total_days)
})

test_that("date_when_calculation handles edge cases", {
  due_date <- as.Date("2024-09-01")
  today <- as.Date("2024-01-01")

  # Test negative weeks (before conception)
  result_negative <- date_when_calculation(
    weeks = -1,
    due_date = due_date,
    today = today
  )
  expect_s3_class(result_negative$date_when, "Date")
  expect_type(result_negative$total_days, "integer")

  # Test very large weeks (beyond typical pregnancy)
  result_large <- date_when_calculation(
    weeks = 50,
    due_date = due_date,
    today = today
  )
  expect_s3_class(result_large$date_when, "Date")
  expect_type(result_large$total_days, "integer")

  # Test when today equals calculated date
  start_date <- due_date - 280
  weeks_when_today <- as.integer(difftime(today, start_date, units = "days")) /
    7
  result_today <- date_when_calculation(
    weeks = weeks_when_today,
    due_date = due_date,
    today = today
  )
  expect_equal(result_today$total_days, 0)
})

test_that("date_when_calculation maintains precision with Date arithmetic", {
  due_date <- as.Date("2024-09-01")
  today <- as.Date("2024-01-01")

  # Test that date calculations are consistent
  result1 <- date_when_calculation(
    weeks = 20,
    due_date = due_date,
    today = today
  )
  result2 <- date_when_calculation(
    weeks = 20,
    due_date = due_date,
    today = today
  )

  expect_identical(result1$date_when, result2$date_when)
  expect_identical(result1$total_days, result2$total_days)
})

test_that("date_when_message returns correct structure", {
  total_days <- 30
  date_when <- as.Date("2024-02-01")
  weeks <- 12
  today <- as.Date("2024-01-01")

  result <- date_when_message(
    total_days = total_days,
    date_when = date_when,
    weeks = weeks,
    today = today
  )

  expect_type(result, "list")
  expect_named(result, c("date_str", "duration_str"))
  expect_type(result$date_str, "character")
})

test_that("date_when_message handles present tense correctly", {
  local_mocked_bindings(Sys.Date = function() as.Date("2024-02-01"))

  total_days <- 0
  date_when <- as.Date("2024-02-01")
  weeks <- 12
  today <- as.Date("2024-02-01")

  result <- date_when_message(
    total_days = total_days,
    date_when = date_when,
    weeks = weeks,
    today = today
  )

  expect_match(result$date_str, "Today.*are.*12 weeks pregnant")
  expect_null(result$duration_str)
})

test_that("date_when_message handles past tense correctly", {
  local_mocked_bindings(Sys.Date = function() as.Date("2024-03-01"))

  total_days <- 28
  date_when <- as.Date("2024-02-01")
  weeks <- 12
  today <- as.Date("2024-03-01")

  result <- date_when_message(
    total_days = total_days,
    date_when = date_when,
    weeks = weeks,
    today = today
  )

  expect_match(result$date_str, "On February 01, 2024.*were.*12 weeks pregnant")
  expect_match(result$duration_str, "That was.*4 weeks.*ago")
})

test_that("date_when_message handles future tense correctly", {
  local_mocked_bindings(Sys.Date = function() as.Date("2024-01-01"))

  total_days <- 31
  date_when <- as.Date("2024-02-01")
  weeks <- 12
  today <- as.Date("2024-01-01")

  result <- date_when_message(
    total_days = total_days,
    date_when = date_when,
    weeks = weeks,
    today = today
  )

  expect_match(
    result$date_str,
    "On February 01, 2024.*will be.*12 weeks pregnant"
  )
  expect_match(result$duration_str, "That's.*4 weeks and 3 days.*away")
})

test_that("date_when_message respects person parameter", {
  local_mocked_bindings(Sys.Date = function() as.Date("2024-02-01"))

  total_days <- 0
  date_when <- as.Date("2024-02-01")
  weeks <- 12
  today <- as.Date("2024-02-01")

  # Test with "I"
  result_i <- date_when_message(
    total_days = total_days,
    date_when = date_when,
    weeks = weeks,
    person = "I",
    today = today
  )
  expect_match(result_i$date_str, "Today.*I am.*12 weeks pregnant")

  # Test with custom name
  result_name <- date_when_message(
    total_days = total_days,
    date_when = date_when,
    weeks = weeks,
    person = "Sarah",
    today = today
  )
  expect_match(result_name$date_str, "Today.*Sarah is.*12 weeks pregnant")
})

test_that("date_when_message uses person from options", {
  withr::local_options(pregnancy.person = "Emma")
  local_mocked_bindings(Sys.Date = function() as.Date("2024-02-01"))

  total_days <- 0
  date_when <- as.Date("2024-02-01")
  weeks <- 12
  today <- as.Date("2024-02-01")

  result <- date_when_message(
    total_days = total_days,
    date_when = date_when,
    weeks = weeks,
    today = today
  )

  expect_match(result$date_str, "Today.*Emma is.*12 weeks pregnant")
})

# Tests for date_when() function
test_that("date_when prints the main message", {
  due_date <- as.Date("2025-10-08")

  expect_message(
    date_when(weeks = 12, due_date = due_date, today = as.Date("2025-03-26")),
    "On March 26, 2025, you were 12 weeks pregnant."
  )
})

test_that("date_when prints duration message when today == Sys.Date()", {
  due_date <- as.Date("2025-10-08")

  # Mock Sys.Date() and use same date for today parameter
  local_mocked_bindings(Sys.Date = function() as.Date("2025-08-28"))
  expect_message(
    date_when(weeks = 12, due_date = due_date, today = as.Date("2025-08-28")),
    "That was 22 weeks and 1 day ago."
  )
})

test_that("date_when does not print duration message when duration_str is NULL", {
  due_date <- as.Date("2025-10-08")

  # Calculate when someone will be 12 weeks pregnant
  # This should result in duration_str being NULL (present tense)
  weeks_12_date <- due_date - 280 + (12 * 7) # March 26, 2025

  # Test that only the main message is printed, not the duration message
  expect_message(
    date_when(weeks = 12, due_date = due_date, today = weeks_12_date),
    "On March 26, 2025, you were 12 weeks pregnant."
  )

  # Verify no duration message is printed by capturing all messages
  messages <- capture_messages(
    date_when(weeks = 12, due_date = due_date, today = weeks_12_date)
  )

  # Should only have one message (the date_str, not duration_str)
  expect_length(messages, 1)
})


test_that("date_when returns date invisibly", {
  withr::local_options(pregnancy.due_date = as.Date("2026-03-01"))

  # Suppress messages to test return value
  result <- suppressMessages(date_when(
    weeks = 12,
    today = as.Date("2025-08-10")
  ))

  expect_equal(result, as.Date("2025-08-17"))
})
