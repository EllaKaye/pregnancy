# date_abort_null(date)
# check_person(person)
# check_date(date)

test_that("person is character of length 1", {
  expect_equal(check_person("Ella"), "Ella")
  expect_error(check_person(1), class = "pregnancy_error_class_or_length")
  expect_error(check_person(c("Me", "You")), class = "pregnancy_error_class_or_length")
})
