due_date <- function(start_date, start_type = c("LMP", "conception", "IVF", "fresh_donor", "transfer_day_3", "transfer_day_5"), cycle = 28) {

  start_type <- match.arg(start_type)

  assertthat::assert_that(assertthat::is.date(start_date))

  if (start_type == "LMP") {
    if (!(cycle %in% 20:44)) stop("cycle must be an integer between 20 and 44")
  }

  # LMP: start_date is start of last menstrual period
  if (start_type == "LMP") {
    due <- start_date + days(cycle) - days(28) + days(280)
  }

  # conception: start_date in date of conception
  if (start_type == "conception") {
    due <- start_date + days(266)
  }

  # IVF: start_date is date of egg retrieval
  if (start_type == "IVF") {
    due <- start_date + days(266)
  }

  # fresh_donor: start_date is date of egg retrieval
  if (start_type == "fresh_donor") {
    due <- start_date + days(266)
  }

  # transfer_day_3: start_date is date of transfer
  if (start_type == "transfer_day_3") {
    due <- start_date + days(266) - days(3)
  }

  # transfer_day_5: start_date is date of transfer
  if (start_type == "transfer_day_5") {
    due <- start_date + days(266) - days(5)
  }

  return(due)

}

#start_date <- ymd("2021-06-11")
#due_date(start_date, "fresh_donor")


#cycle <- 22





#due_date(ymd("2021-01-01"), "hello")

#vec <- c("LMP", "conception", "IVF", "fresh donor", "transfer_day_3", "transfer_day_5")
#
#due_date(ymd("2021-05-03"), "LMP")
# due_date("2021-05-03", "hello")
#
# is_in <- function(x, vec) {
#   assert_that(x %in% vec)
# }
#
# on_failure(is_in) <- function(call, env) {
#   paste0(deparse(call$x), " is even")
# }
#
# assert_that(is_in("LMP", vec))
# #assert_that(is_in("hello", vec))
#
# is_odd <- function(x) {
#   assert_that(is.numeric(x), length(x) == 1)
#   x %% 2 == 1
# }
# assert_that(is_odd(2))
# # Error: is_odd(x = 2) is not TRUE
#
# on_failure(is_odd) <- function(call, env) {
#   paste0(deparse(call$x), " is even")
# }
# assert_that(is_odd(2))
# # Error: 2 is even
#
# is_in <- function(x, vec) {
#    assert_that(x %in% vec)
# }
#
# assert_that(is_in("hello", vec))
# #
# on_failure(is_in) <- function(call, env) {
#   vec_names <- paste0("'", paste0(eval(call$vec, env), collapse = "', '"), "'")
#   paste0(deparse(call$x), " does not have all of these name(s): ", vec_names)
# }
#
# has_name <- function(x, which){
#   all(which %in% names(x))
# }
# on_failure(has_name) <- function(call, env) {
#   out_names <- paste0("'", paste0(eval(call$which, env), collapse = "', '"), "'")
#   paste0(deparse(call$x), " does not have all of these name(s): ", out_names)
# }
#
# y <- list(a = 1, b = 2)
# assert_that(y %has_name% "c")
