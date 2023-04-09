# date_abort_null(date)
# check_date(date)
# check_person(person)
# check_cycle(cycle)

# testing date_abort_null(date) ------------------------------------------------

# testing check_date(date) -----------------------------------------------------

# testing check_person(person) -------------------------------------------------

test_that("person is character of length 1", {
  expect_equal(check_person("Ella"), "Ella")
  expect_error(check_person(1), class = "pregnancy_error_class_or_length")
  expect_error(check_person(c("Me", "You")), class = "pregnancy_error_class_or_length")
})

# testing check_cycle(cycle) ---------------------------------------------------




