# testing medications_remaining() ------------------------------------------

test_that("medications_remaining calculates correctly by medication", {
  meds <- data.frame(
    medication = c("A", "B"),
    format = c("tablet", "tablet"),
    quantity = c(1, 2),
    start_date = as.Date(c("2025-04-01", "2025-04-03")),
    stop_date = as.Date(c("2025-04-04", "2025-04-05"))
  )

  result <- medications_remaining(meds, on_date = as.Date("2025-04-01"))

  expect_equal(nrow(result), 2)
  expect_equal(result$medication, c("A", "B"))
  expect_equal(result$quantity, c(4, 6)) # A: 4 days * 1, B: 3 days * 2
})

test_that("medications_remaining calculates correctly by medication with character dates", {
  meds <- data.frame(
    medication = c("A", "B"),
    format = c("tablet", "tablet"),
    quantity = c(1, 2),
    start_date = c("2025-04-01", "2025-04-03"),
    stop_date = c("2025-04-04", "2025-04-05")
  )

  result <- medications_remaining(meds, on_date = "2025-04-01")

  expect_equal(nrow(result), 2)
  expect_equal(result$medication, c("A", "B"))
  expect_equal(result$quantity, c(4, 6)) # A: 4 days * 1, B: 3 days * 2
})

test_that("medications_remaining calculates correctly by format", {
  meds <- data.frame(
    medication = c("A", "B"),
    format = c("tablet", "injection"),
    quantity = c(1, 2),
    start_date = as.Date(c("2025-04-01", "2025-04-01")),
    stop_date = as.Date(c("2025-04-04", "2025-04-02"))
  )

  result <- medications_remaining(
    meds,
    group = "format",
    on_date = as.Date("2025-04-01")
  )

  expect_equal(nrow(result), 2)
  expect_true(all(c("tablet", "injection") %in% result$format))
})

test_that("medications_remaining returns empty when no medications remain", {
  meds <- data.frame(
    medication = "A",
    format = "tablet",
    quantity = 1,
    start_date = as.Date("2025-04-01"),
    stop_date = as.Date("2025-04-04")
  )

  expect_message(
    result <- medications_remaining(
      meds,
      on_date = as.Date("2025-04-05"),
      until_date = as.Date("2025-04-10")
    ),
    "There are no medications remaining"
  )
  expect_equal(nrow(result), 0)
})

test_that("medications_remaining respects until_date parameter", {
  meds <- data.frame(
    medication = "A",
    format = "tablet",
    quantity = 2,
    start_date = as.Date("2025-04-01"),
    stop_date = as.Date("2025-04-10")
  )

  result <- medications_remaining(
    meds,
    on_date = as.Date("2025-04-01"),
    until_date = as.Date("2025-04-05")
  )

  expect_equal(result$quantity, 10) # 5 days * 2 per day
})

test_that("medications_remaining errors when until_date < on_date", {
  meds <- data.frame(
    medication = "A",
    format = "tablet",
    quantity = 1,
    start_date = as.Date("2025-04-01"),
    stop_date = as.Date("2025-04-04")
  )

  expect_error(
    medications_remaining(
      meds,
      on_date = as.Date("2025-04-05"),
      until_date = as.Date("2025-04-01")
    ),
    "until_date.*must be later than.*on_date"
  )
})

test_that("medications_remaining uses global option when meds is NULL", {
  original_option <- getOption("pregnancy.medications")

  meds <- data.frame(
    medication = "A",
    format = "tablet",
    quantity = 1,
    start_date = as.Date("2025-04-01"),
    stop_date = as.Date("2025-04-04")
  )

  suppressMessages(set_medications(meds))

  result <- medications_remaining(on_date = as.Date("2025-04-01"))
  expect_equal(result$medication, "A")

  options(pregnancy.medications = original_option)
})

test_that("medications_remaining errors when meds is NULL and no option set", {
  original_option <- getOption("pregnancy.medications")
  options(pregnancy.medications = NULL)

  expect_error(
    medications_remaining(),
    "meds.*must be a data frame, not.*NULL"
  )

  options(pregnancy.medications = original_option)
})

# testing check_medications() --------------------------------------------

test_that("check_medications validates data frame input", {
  expect_error(
    check_medications("not a data frame"),
    class = "pregnancy_error_class"
  )

  expect_error(
    check_medications(list(a = 1, b = 2)),
    class = "pregnancy_error_class"
  )
})

test_that("check_medications validates required columns", {
  # Missing all columns
  empty_df <- data.frame()
  expect_error(
    check_medications(empty_df),
    class = "pregnancy_error_missing"
  )

  # Missing some columns
  partial_df <- data.frame(medication = "A", format = "tablet")
  expect_error(
    check_medications(partial_df),
    class = "pregnancy_error_missing"
  )
})

test_that("check_medications converts character dates", {
  character_dates <- data.frame(
    medication = "A",
    format = "tablet",
    quantity = 1,
    start_date = "2025-04-01",
    stop_date = "2025-04-04"
  )

  checked_medications <- check_medications(character_dates)

  expect_equal(checked_medications$start_date, anytime::anydate("2025-04-01"))
  expect_equal(checked_medications$stop_date, anytime::anydate("2025-04-04"))
})

test_that("check_medications validates column types", {
  # Test numeric medication (should be character/factor)
  bad_medication <- data.frame(
    medication = 1,
    format = "tablet",
    quantity = 1,
    start_date = as.Date("2025-04-01"),
    stop_date = as.Date("2025-04-04")
  )

  expect_error(
    check_medications(bad_medication),
    class = "pregnancy_error_class"
  )

  # Test character quantity (should be numeric)
  bad_quantity <- data.frame(
    medication = "A",
    format = "tablet",
    quantity = "one",
    start_date = as.Date("2025-04-01"),
    stop_date = as.Date("2025-04-04")
  )

  expect_error(
    check_medications(bad_quantity),
    class = "pregnancy_error_class"
  )
})

test_that("check_medications passes valid data frames", {
  valid_meds <- data.frame(
    medication = "A",
    format = "tablet",
    quantity = 1,
    start_date = as.Date("2025-04-01"),
    stop_date = as.Date("2025-04-04")
  )

  expect_invisible(check_medications(valid_meds))

  # Test with factor columns (should also pass)
  valid_meds_factor <- data.frame(
    medication = factor("A"),
    format = factor("tablet"),
    quantity = 1,
    start_date = as.Date("2025-04-01"),
    stop_date = as.Date("2025-04-04")
  )

  expect_invisible(check_medications(valid_meds_factor))
})

test_that("check_medications validates format column type", {
  # Test numeric format (should be character/factor)
  bad_format <- data.frame(
    medication = "A",
    format = 1, # numeric, not character/factor
    quantity = 1,
    start_date = as.Date("2025-04-01"),
    stop_date = as.Date("2025-04-04")
  )

  expect_error(
    check_medications(bad_format),
    "In.*meds.*column.*format.*must have class.*character.*or.*factor",
    class = "pregnancy_error_class"
  )
})

# testing set_medications() --------------------------------------------
test_that("medication option gets set", {
  starting_option <- getOption("pregnancy.medications")
  options(pregnancy.medications = NULL)
  meds <- data.frame(
    medication = "A",
    format = "tablet",
    quantity = 1,
    start_date = as.Date("2025-04-01"),
    stop_date = as.Date("2025-04-04")
  )
  suppressMessages(set_medications(meds))
  meds_option <- getOption("pregnancy.medications")
  expect_equal(meds_option$medication[1], "A")
  options(pregnancy.person = starting_option)
})


test_that("NULL option gets set", {
  starting_option <- getOption("pregnancy.medications")
  meds <- data.frame(
    medication = "A",
    format = "tablet",
    quantity = 1,
    start_date = as.Date("2025-04-01"),
    stop_date = as.Date("2025-04-04")
  )
  options(pregnancy.medications = meds)
  suppressMessages(set_medications(NULL))
  expect_null(getOption("pregnancy.medications"))
  options(pregnancy.person = starting_option)
})

# testing get_medications() --------------------------------------------

test_that("retreives medication option", {
  meds <- data.frame(
    medication = "A",
    format = "tablet",
    quantity = 1,
    start_date = as.Date("2025-04-01"),
    stop_date = as.Date("2025-04-04")
  )
  withr::local_options(pregnancy.medications = meds)

  # Suppress print output but get the return value
  med_option <- suppressMessages({
    invisible(capture.output(result <- get_medications(), type = "output"))
    result
  })

  expect_equal(med_option$medication, "A")
})

test_that("NULL if medication not set", {
  withr::local_options(pregnancy.medication = NULL)
  expect_null(suppressMessages(get_medications()))
})
