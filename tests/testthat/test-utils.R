# testing check_date(date) -----------------------------------------------------

test_that("date is length 1", {
  expect_equal(check_date(as.Date("2023-01-01")), as.Date("2023-01-01"))
  expect_error(check_date(NULL), class = "pregnancy_error_length")
  expect_error(
    check_date(c(as.Date("2023-01-01"), as.Date("2023-01-02"))),
    class = "pregnancy_error_length"
  )
})

test_that("NA date throws error", {
  expect_error(check_date(NA))
})

test_that("error if date not parseable", {
  expect_error(check_date(2023 - 01 - 01), class = "pregnancy_error_class")
})

test_that("date can be a character string", {
  expect_equal(check_date("2023-01-01"), anytime::anydate("2023-01-01"))
  expect_true(lubridate::is.Date(check_date("2023-01-01")))
  expect_no_error(check_date("2023-01-01"))
})

test_that("error if date is NA", {
  expect_error(check_date(NA))
})

test_that("check_date handles NA values correctly", {
  # Test that NA date throws the correct error
  expect_error(
    check_date(as.Date(NA)),
    class = "pregnancy_error_value"
  )

  # Test that the error message contains the expected content
  expect_error(
    check_date(as.Date(NA)),
    "was.*NA"
  )

  # Test that NULL date doesn't trigger the NA check
  # (this should fail earlier in the function due to length check)
  expect_error(
    check_date(NULL),
    class = "pregnancy_error_length"
  )

  # Test that valid date passes through without error
  valid_date <- as.Date("2025-01-01")
  expect_equal(check_date(valid_date), valid_date)
})

# testing check_person(person) -------------------------------------------------

test_that("person is character of length 1", {
  expect_equal(check_person("Ella"), "Ella")
  expect_error(check_person(1), class = "pregnancy_error_class_or_length")
  expect_error(
    check_person(c("Me", "You")),
    class = "pregnancy_error_class_or_length"
  )
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


# testing set_option_message() -------------------------------------------

test_that("set_option_message provides complete information about option usage", {
  # Use expect_snapshot to capture and test the console output for different options
  expect_snapshot(set_option_message("person"))
  expect_snapshot(set_option_message("due_date"))
  expect_snapshot(set_option_message("medications"))
})

# testing set_option_null_message() --------------------------------------

test_that("set_option_null_message works correctly for person option", {
  # Use expect_snapshot to capture and test the console output
  expect_snapshot(set_option_null_message("person"))
})

test_that("set_option_null_message works correctly for other options", {
  expect_snapshot(set_option_null_message("due_date"))
  expect_snapshot(set_option_null_message("medications"))
})

test_that("set_option_null_message works correctly for unknown option", {
  expect_snapshot(set_option_null_message("unknown_option"))
})


# testing null_option() --------------------------------------------------

test_that("null_option displays warning for any option", {
  # Use expect_snapshot to capture and test the console output for different options
  expect_snapshot(null_option("person"))
  expect_snapshot(null_option("due_date"))
  expect_snapshot(null_option("medications"))
})
