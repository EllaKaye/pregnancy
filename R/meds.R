# functions related to mediations
# meds_remaining()
# meds_augment()
# meds_print()
# get_meds()
# set_meds()

# need to copy over then modify code from EMKpregnancy package
# TODO: think about function args (and names) and order.
# TODO: needs on_date
meds_remaining <-
  function(on_date = Sys.Date(),
           meds = NULL,
           group = c("medication", "format")) {

    check_date(on_date)

    # TODO: better abort message (see date_abort)
    meds <- meds %||% getOption("pregnancy.meds") %||% cli::cli_abort("NEEDS MEDS")

    group = rlang::arg_match(group)

    # TODO: cli_abort in all these assertions, and rlang::is_*
    if (!is.data.frame(meds)) {
      cli::cli_abort(c("{.var meds} must be a data frame",
                       "i" = "It was {.type {meds}} instead."))
    }



    colnames_meds <- colnames(meds)

    if (!("medication" %in% colnames_meds)) {
      stop("meds must have a column 'medication'")
    }

    if (!("format" %in% colnames_meds)) {
      stop("meds must have a column 'format'")
    }

    if (!("quantity" %in% colnames_meds)) {
      stop("meds must have a column 'quantity'")
    }

    if (!("start_date" %in% colnames_meds)) {
      stop("meds must have a column 'extra'")
    }

    if (!("stop_date" %in% colnames_meds)) {
      stop("meds must have a column 'stop_date'")
    }



    # TODO: Check all col types do not rely on assertthat
    # assertthat::assert_that(assertthat::noNA(meds$extra))

    # assert that stop_date are dates
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
