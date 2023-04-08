#meds <- EMKpregnancy::meds

# need to copy over then modify code from EMKpregnancy package

meds_left <- function(meds, group = c("medication", "format")) {

  group = match.arg(group)

  if (!is.data.frame(meds)) {
    stop("meds must be a data frame")
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

  if (!("stop_date" %in% colnames_meds)) {
    stop("meds must have a column 'stop_date'")
  }

  if (!("extra" %in% colnames_meds)) {
    stop("meds must have a column 'extra'")
  }

  # TODO: do not rely on assertthat
  # assertthat::assert_that(assertthat::noNA(meds$extra))

  # assert that stop_date are dates
}

# function for figuring out the function
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
