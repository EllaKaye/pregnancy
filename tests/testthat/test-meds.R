# testing medications_remaining() ------------------------------------------

# testing check_medications() --------------------------------------------

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
  expect_equal(suppressMessages(get_medications()$medication[1]), "A")
})

test_that("NULL if medication not set", {
  withr::local_options(pregnancy.medication = NULL)
  expect_null(suppressMessages(get_medications()))
})
