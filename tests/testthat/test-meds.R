test_that("meds loads", {
  meds <- readRDS(test_path("fixtures", "meds.rds"))
  expect_equal(colnames(meds)[1], "medication")
  expect_equal(meds$quantity, c(1,2,2,1))
})

test_that("defaults spanning full date range", {
  meds <- readRDS(test_path("fixtures", "meds.rds"))
  summary <- medications_remaining(meds, on_date = as.Date("2025-03-31"), until_date = as.Date("2025-04-10"))
  expect_equal(summary$medication, c("A", "B", "C"))
  expect_equal(summary$quantity_remaining, c(4, 6, 3))
})

test_that("earlier until_date", {
  meds <- readRDS(test_path("fixtures", "meds.rds"))
  summary <- medications_remaining(meds, on_date = as.Date("2025-03-31"), until_date = as.Date("2025-04-03"))
  expect_equal(summary$medication, c("A", "B"))
  expect_equal(summary$quantity_remaining, c(3, 2))
})

test_that("later on_date", {
  meds <- readRDS(test_path("fixtures", "meds.rds"))
  summary <- medications_remaining(meds, on_date = as.Date("2025-04-05"), until_date = as.Date("2025-04-10"))
  expect_equal(summary$medication, c("B", "C"))
  expect_equal(summary$quantity_remaining, c(2, 3))
})

test_that("group by format", {
  meds <- readRDS(test_path("fixtures", "meds.rds"))
  summary <- medications_remaining(meds, group = "format", on_date = as.Date("2025-03-31"), until_date = as.Date("2025-04-10"))
  expect_equal(summary$format, c("injection", "tablet"))
  expect_equal(summary$quantity_remaining, c(3, 10))
})

test_that("date order matters", {
  meds <- readRDS(test_path("fixtures", "meds.rds"))
  expect_error(medications_remaining(meds, until_date = as.Date("2025-03-31"), on_date = as.Date("2025-04-10")), class = "date_order_error")
})
