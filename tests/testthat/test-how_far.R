# Test suite created by claude.ai, 2025-01-27
# Some manual editing by me.

# test how_far_calculation -----------------------------------------------

test_that("how_far_calculation returns correct values", {
  # Set up test dates
  due_date <- as.Date("2025-07-01")

  # Test at different points in pregnancy
  # Start of pregnancy (about 40 weeks before due date)
  result <- how_far_calculation(
    on_date = as.Date("2024-09-24"),
    due_date = due_date
  )

  expect_equal(result$weeks_pregnant, 0)
  expect_equal(result$and_days_pregnant, 0)
  expect_equal(result$weeks_to_go, 40)
  expect_equal(result$and_days_to_go, 0)
  expect_equal(result$percent_along, 0)

  # Middle of pregnancy (about 20 weeks)
  result <- how_far_calculation(
    on_date = as.Date("2025-02-11"),
    due_date = due_date
  )

  expect_equal(result$weeks_pregnant, 20)
  expect_equal(result$and_days_pregnant, 0)
  expect_equal(result$weeks_to_go, 20)
  expect_equal(result$and_days_to_go, 0)
  expect_equal(result$percent_along, 50)

  # Near end of pregnancy (38 weeks)
  result <- how_far_calculation(
    on_date = as.Date("2025-06-17"),
    due_date = due_date
  )

  expect_equal(result$weeks_pregnant, 38)
  expect_equal(result$and_days_pregnant, 0)
  expect_equal(result$weeks_to_go, 2)
  expect_equal(result$and_days_to_go, 0)
  expect_equal(result$percent_along, 95)
})

test_that("how_far_calculation handles due_date option", {
  withr::local_options(pregnancy.due_date = as.Date("2025-07-01"))

  result <- how_far_calculation(on_date = as.Date("2025-02-11"))

  expect_equal(result$weeks_pregnant, 20)
  expect_equal(result$weeks_to_go, 20)
})

test_that("how_far_calculation errors appropriately", {
  expect_error(
    how_far_calculation(on_date = "2025-02-11"),
    class = "pregnancy_error_class"
  )

  expect_error(
    how_far_calculation(
      on_date = as.Date("2025-02-11"),
      due_date = "2025-07-01"
    ),
    class = "pregnancy_error_class"
  )
})


# test how_far_message ---------------------------------------------------
# TODO: something not quite right here because these tests fail on R CMD check without the local option, even though due_date is passed as arg.
test_that("how_far_message formats messages correctly for present date", {
  local_mocked_bindings(Sys.Date = function() as.Date("2027-01-27"))
  withr::local_options(pregnancy.due_date = as.Date("2025-07-01"))

  calc_results <- how_far_calculation(
    on_date = as.Date("2025-01-27", due_date = as.Date("2025-07-01"))
  )

  # Test with default "You"
  result <- how_far_message(
    calc_results,
  )

  expect_length(result$messages, 3)
  expect_match(result$messages[1], "You are 17 weeks and 6 days pregnant")
  expect_match(result$messages[2], "22 weeks and 1 day until the due date")
  expect_match(result$messages[3], "45% through the pregnancy")

  # Test with "I"
  result <- how_far_message(
    calc_results,
    on_date = Sys.Date(),
    person = "I"
  )

  expect_match(result$messages[1], "I am 17 weeks and 6 days pregnant")
  expect_match(result$messages[3], "I am 45% through the pregnancy")

  # Test with custom name
  result <- how_far_message(
    calc_results,
    on_date = Sys.Date(),
    person = "Sarah"
  )

  expect_match(result$messages[1], "Sarah is 17 weeks and 6 days pregnant")
  expect_match(result$messages[3], "Sarah is 45% through the pregnancy")
})

# TODO: something not quite right here because these tests fail on R CMD check without the local option, even though due_date is passed as arg.
test_that("how_far_message formats messages correctly for past/future dates", {
  local_mocked_bindings(Sys.Date = function() as.Date("2025-01-27"))
  withr::local_options(pregnancy.due_date = as.Date("2025-07-01"))
  # Test past date
  calc_results <- how_far_calculation(
    on_date = as.Date("2025-01-01", due_date = as.Date("2025-07-01"))
  )

  result <- how_far_message(
    calc_results,
    on_date = as.Date("2025-01-01"),
    person = "You"
  )

  expect_length(result$messages, 1)
  expect_match(
    result$messages[1],
    "On January 01, 2025, you were 14 weeks and 1 day pregnant"
  )

  # Test future date
  calc_results <- how_far_calculation(
    on_date = as.Date("2025-05-15", due_date = as.Date("2025-07-01"))
  )

  result <- how_far_message(
    calc_results,
    on_date = as.Date("2025-05-15"),
    person = "Sarah"
  )

  expect_length(result$messages, 1)
  expect_match(
    result$messages[1],
    "On May 15, 2025, Sarah will be 33 weeks and 2 days pregnant"
  )
})

test_that("how_far_message handles pregnancy.person option", {
  withr::local_options(pregnancy.person = "Emma")

  calc_results <- list(
    weeks_pregnant = 20,
    and_days_pregnant = 3,
    weeks_to_go = 19,
    and_days_to_go = 4,
    percent_along = 51,
    due_date = as.Date("2025-07-01")
  )

  result <- how_far_message(calc_results, on_date = Sys.Date())

  expect_match(result$messages[1], "Emma is 20 weeks and 3 days pregnant")
})

test_that("how_far_message handles over 42 weeks appropriately", {
  calc_results <- list(
    weeks_pregnant = 43,
    and_days_pregnant = 2,
    weeks_to_go = 0,
    and_days_to_go = 0,
    percent_along = 100,
    due_date = as.Date("2025-07-01")
  )

  result <- how_far_message(
    calc_results,
    on_date = Sys.Date(),
    person = "You"
  )

  expect_length(result$messages, 1)
  expect_match(
    result$messages[1],
    "Given a due date of July 01, 2025, you would now be more than 42 weeks pregnant"
  )
})


# test how_far() ---------------------------------------------------------

test_that("how_far integrates calculation and message correctly", {
  withr::local_options(
    pregnancy.due_date = as.Date("2025-07-01"),
    pregnancy.person = "Sarah"
  )

  # We can't easily test the cli output, but we can test the invisible return value
  result <- how_far(on_date = as.Date("2025-02-11"))
  expect_equal(result, 140) # 20 weeks = 140 days

  # Test with explicitly provided arguments
  result <- how_far(
    on_date = as.Date("2025-02-11"),
    due_date = as.Date("2025-07-01"),
    person = "Emma"
  )
  expect_equal(result, 140)
})
