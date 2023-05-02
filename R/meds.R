# functions related to mediations
# meds_remaining()
# meds_augment()
# meds_print()
# get_meds()
# set_meds()

# need to copy over then modify code from EMKpregnancy package
#' Title
#'
#' @param on_date date
#' @param meds meds
#' @param group group
#'
#' @return prints in console, returns a data frame invisibly
#' @export
#'
#' @examples meds_remaining(on_date = as.Date("2023-04-30"), meds = medications)
meds_remaining <-

  function(on_date = Sys.Date(),
           meds = NULL,
           group = c("medication", "format")) {

    check_date(on_date)

    # TODO: better abort message (see date_abort)
    meds <- meds %||% getOption("pregnancy.meds") %||% cli::cli_abort("NEEDS MEDS")
    check_meds(meds)

    group = rlang::arg_match(group)

    meds_aug <- meds_augment(on_date, meds)

    if (group == "medication") {
      meds_summary <- meds_aug %>%
        dplyr::group_by(medication) %>%
        dplyr::summarise(medication_remaining = sum(quantity_remaining)) %>%
        dplyr::filter(medication_remaining > 0)
    }

    if (group == "format") {
      meds_summary <- meds_aug %>%
        dplyr::group_by(format) %>%
        dplyr::summarise(format_remaining = sum(quantity_remaining)) %>%
        dplyr::filter(format_remaining > 0)
    }

    # TODO: call to meds_print()

    # TODO: make invisible
    meds_summary
  }


meds_augment <- function(on_date, meds) {

  meds %>%
    dplyr::mutate(total_days = (stop_date - start_date) + 1) %>%
    dplyr::mutate(total_quantity = as.integer(total_days * quantity)) %>%
    dplyr::mutate(days_remaining = dplyr::case_when(
      #on_date > stop_date ~ as.difftime(0, units = days), # THINK ABOUT WHETHER THIS NEEDS TO BE >=
      on_date <= stop_date & on_date >= start_date ~ (as.integer(stop_date - on_date) + 1), # THINK ABOUT WHERE THE EQUALITIES GO
      start_date > on_date ~ (as.integer(stop_date - start_date) + 1),
      TRUE ~ 0
    )) %>%
    dplyr::mutate(quantity_remaining = as.integer(days_remaining * quantity))

}

# function for figuring out the function
# use as helper or delete from package?
meds_print <- function(meds_summary, on_date) {

  # TODO: use person and have (via a new to_have function)
  if (nrow(meds_summary) == 0) {
    cli::cli_alert_success("There are no medications remaining.")}

  # check col names
  thing <- meds_summary[[1]]
  quantity <- meds_summary[[2]]

  # TODO: pick up here...
  for (i in 1:nrow(meds_summary)) {
    cli::cli_bullets(c("*" = "You have {medications[i]} remaining"))
  }

  # "As of first thing today/on_date, the following {group?s} remain to be taken:

  invisible(meds_summary)
}

check_meds <- function(meds) {
  if (!is.data.frame(meds)) {
    cli::cli_abort(c("{.var meds} must be a data frame.",
                     "i" = "It was {.type {meds}} instead."),
                   class = "pregnancy_error_class")
  }

  colnames_meds <- colnames(meds)
  needs_cols <- c("medication", "format", "quantity", "start_date", "stop_date")
  diff <- setdiff(needs_cols, colnames_meds)

  if(length(diff) > 0) {
    message <- c("{.var meds} is missing column{?s} {.code {diff}}.")
    cli::cli_abort(message,
                   class = "pregnancy_error_missing")
  }

  if (!lubridate::is.Date(meds[["start_date"]]) || !lubridate::is.Date(meds[["stop_date"]])) {
    cli::cli_abort(c(
      "In {.var meds}, columns {.code start_date} and {.code stop_date} must have class {.cls Date}.",
      "i" = "{.var start_date} was class {.cls {class(meds[['start_date']])}}.",
      "i" = "{.var stop_date} was class {.cls {class(meds[['stop_date']])}}."),
      class = "pregnancy_error_class")
  }

  if (!rlang::is_character(meds$medication) && !is.factor(meds$medication)) {
    cli::cli_abort(c(
      "In {.var meds}, column {.code medication} must have class {.cls character} or {.cls factor}.",
      "i" = "It was class {.cls {class(meds$medication)}}."
    ),
    class = "pregnancy_error_class")
  }

  if (!rlang::is_character(meds$format) && !is.factor(meds$format)) {
    cli::cli_abort(c(
      "In {.var meds}, column {.code format} must have class {.cls character} or {.cls factor}.",
      "i" = "It was class {.cls {class(meds$format)}} instead."
    ),
    class = "pregnancy_error_class")
  }

  if (!is.numeric(meds$quantity)) {
    cli::cli_abort(c(
      "In {.var meds}, column {.code quantity} must have class {.cls numeric}.",
      "i" = "It was class {.cls {class(meds$quantity)}} instead."
    ),
    class = "pregnancy_error_class")
  }

  invisible(meds)

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
