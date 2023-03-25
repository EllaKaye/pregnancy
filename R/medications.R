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

#meds_colnames <- colnames(meds)
#length(meds_colnames)

#meds_colnames == colnames(meds)


#meds_bad <- dplyr::tibble(medication = "med1", format = "pill", quantity = 1, stop_date = Sys.Date() + lubridate::days(4), extra = NA)

#meds_left(meds_bad)

#meds_left(meds_bad)
