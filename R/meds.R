# functions related to mediations
# meds_remaining()
# meds_augment()
# meds_print()
# get_meds()
# set_meds()

# need to copy over then modify code from EMKpregnancy package
meds_remaining <-

  function(on_date = Sys.Date(),
           meds = NULL,
           group = c("medication", "format")) {

    rlang::check_installed("dplyr", reason = "to use `meds_remaining()`")

    check_date(on_date)

    # TODO: better abort message (see date_abort)
    meds <- meds %||% getOption("pregnancy.meds") %||% cli::cli_abort("NEEDS MEDS")

    group = rlang::arg_match(group)

    # Check meds is a data frame, with the necessary columns, of the right type
    if (!is.data.frame(meds)) {
      cli::cli_abort(c("{.var meds} must be a data frame.",
                       "i" = "It was {.type {meds}} instead."))
    }

    colnames_meds <- colnames(meds)
    needs_cols <- c("medication", "format", "quantity", "start_date", "stop_date")
    diff <- setdiff(needs_cols, colnames_meds)

    if(length(diff) > 0) {
      message <- c("{.var meds} is missing column{?s} {.code {diff}}.")
      cli::cli_abort(message)
    }

    if (!lubridate::is.Date(meds[["start_date"]]) || !lubridate::is.Date(meds[["stop_date"]])) {
      cli::cli_abort(c(
        "In {.var meds}, columns {.code start_date} and {.code stop_date} must have class {.cls Date}.",
        "i" = "{.var start_date} was class {.cls {class(meds[['start_date']])}}.",
        "i" = "{.var stop_date} was class {.cls {class(meds[['stop_date']])}}."))
    }

    if (!rlang::is_character(meds$medication) && !is.factor(meds$medication)) {
      cli_abort(c(
        "In {.var meds}, column {.code medication} must have class {.cls character} or {.cls factor}.",
        "i" = "It was class {.cls {class(meds$medication)}}."
      ))
    }

    if (!rlang::is_character(meds$format) && !is.factor(meds$format)) {
      cli_abort(c(
        "In {.var meds}, column {.code format} must have class {.cls character} or {.cls factor}.",
        "i" = "It was class {.cls {class(meds$format)}} instead."
      ))
    }

    if (!is.numeric(meds$quantity)) {
      cli_abort(c(
        "In {.var meds}, column {.code quantity} must have class {.cls numeric}.",
        "i" = "It was class {.cls {class(meds$quantity)}} instead."
      ))
    }

    meds
  }

# function for figuring out the function
# use as helper or delete from package?
meds_print <- function() {
  # will need to make sure we deal with case when meds has no rows:
  meds <- data.frame(meds = LETTERS[1:3], remaining = 1:3)

  # check col names
  medications <- meds$meds
  remaining <- meds$remaining

  for (i in 1:nrow(meds)) {
    cli::cli_bullets(c("*" = "You have {medications[i]} remaining"))
  }
}

# TODO: get/set_meds functions

# TODO: delete this code
# figuring stuff out
# meds <- medications
# needs_cols <- colnames(meds)
# missing_colnames <- colnames(meds)[1:3]
# missing_colname <- colnames(meds)[1:4]
# missing_more_colnames <- colnames(meds)[1:2]
# too_many_colnames <- c(colnames(meds), LETTERS[1:2])
# mixed_colnames <- c(missing_colnames, LETTERS[1:2])
#
# diff1 <- base::setdiff(needs_cols, missing_colname)
# diff2 <- base::setdiff(needs_cols, missing_colnames)
# diff3 <- base::setdiff(needs_cols, missing_more_colnames)
# no_diff <- base::setdiff(needs_cols, too_many_colnames)
# base::setdiff(needs_cols, mixed_colnames)
#
#


#meds_not_date <- mutate(pregnancy::medications, start_date = as.character(start_date))
# transform is base, so better in tests
# meds_not_date <- transform(medications, start_date = as.character(start_date))
