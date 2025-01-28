# functions related to medications
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
#' @examples meds_remaining(on_date = as.Date("2025-04-30"), meds = medications)
meds_remaining <-
  function(meds = NULL,
           group = c("medication", "format"),
           on_date = Sys.Date()) {
    check_date(on_date)

    # TODO: better abort message (see date_abort)
    meds <- meds %||% getOption("pregnancy.medications") %||% cli::cli_abort("NEEDS MEDS")
    check_meds(meds)

    group <- rlang::arg_match(group)

    meds_aug <- meds %>%
      dplyr::mutate(total_days = (stop_date - start_date) + 1) %>%
      dplyr::mutate(total_quantity = as.integer(total_days * quantity)) %>%
      dplyr::mutate(days_remaining = dplyr::case_when(
        on_date <= stop_date & on_date >= start_date ~ (as.integer(stop_date - on_date) + 1),
        start_date > on_date ~ (as.integer(stop_date - start_date) + 1),
        TRUE ~ 0
      )) %>%
      dplyr::mutate(quantity_remaining = as.integer(days_remaining * quantity))

    if (group == "medication") {
      meds_summary <- meds_aug %>%
        dplyr::group_by(medication) %>%
        dplyr::summarise(quantity_remaining = sum(quantity_remaining)) %>%
        dplyr::filter(quantity_remaining > 0)
    }

    if (group == "format") {
      meds_summary <- meds_aug %>%
        dplyr::group_by(format) %>%
        dplyr::summarise(quantity_remaining = sum(quantity_remaining)) %>%
        dplyr::filter(quantity_remaining > 0)
    }

    if (nrow(meds_summary) == 0) {
      cli::cli_alert_success("There are no medications remaining.")
      return(invisible(meds_summary))
    }

    meds_summary
  }


# tibble output actually looks better than cli here
meds_print <- function(meds_summary, on_date = Sys.Date()) {
  # TODO: use person and have (via a new to_have function)
  if (nrow(meds_summary) == 0) {
    cli::cli_alert_success("There are no medications remaining.")
    return(invisible(meds_summary))
  }

  # check col names
  thing <- meds_summary[[1]]
  quantity <- meds_summary[[2]]

  # TODO: pick up here...

  if (on_date == Sys.Date()) {
    cli::cli_alert_info("As of first thing today, the following medications remain to be taken:")
  } else {
    cli::cli_alert_info("As of first thing on {format(on_date, '%B %d, %Y')}, the following medications remain to be taken:")
  }

  for (i in 1:length(thing)) {
    cli::cli_bullets(c("*" = "{quantity[i]} {thing[i]}"))
  }

  invisible(meds_summary)
}

check_meds <- function(meds) {
  if (!is.data.frame(meds)) {
    cli::cli_abort(
      c("{.var meds} must be a data frame.",
        "i" = "It was {.type {meds}} instead."
      ),
      class = "pregnancy_error_class"
    )
  }

  colnames_meds <- colnames(meds)
  needs_cols <- c("medication", "format", "quantity", "start_date", "stop_date")
  diff <- setdiff(needs_cols, colnames_meds)

  if (length(diff) > 0) {
    message <- c("{.var meds} is missing column{?s} {.code {diff}}.")
    cli::cli_abort(message,
      class = "pregnancy_error_missing"
    )
  }

  if (!lubridate::is.Date(meds[["start_date"]]) || !lubridate::is.Date(meds[["stop_date"]])) {
    cli::cli_abort(
      c(
        "In {.var meds}, columns {.code start_date} and {.code stop_date} must have class {.cls Date}.",
        "i" = "{.var start_date} was class {.cls {class(meds[['start_date']])}}.",
        "i" = "{.var stop_date} was class {.cls {class(meds[['stop_date']])}}."
      ),
      class = "pregnancy_error_class"
    )
  }

  if (!rlang::is_character(meds$medication) && !is.factor(meds$medication)) {
    cli::cli_abort(
      c(
        "In {.var meds}, column {.code medication} must have class {.cls character} or {.cls factor}.",
        "i" = "It was class {.cls {class(meds$medication)}}."
      ),
      class = "pregnancy_error_class"
    )
  }

  if (!rlang::is_character(meds$format) && !is.factor(meds$format)) {
    cli::cli_abort(
      c(
        "In {.var meds}, column {.code format} must have class {.cls character} or {.cls factor}.",
        "i" = "It was class {.cls {class(meds$format)}} instead."
      ),
      class = "pregnancy_error_class"
    )
  }

  if (!is.numeric(meds$quantity)) {
    cli::cli_abort(
      c(
        "In {.var meds}, column {.code quantity} must have class {.cls numeric}.",
        "i" = "It was class {.cls {class(meds$quantity)}} instead."
      ),
      class = "pregnancy_error_class"
    )
  }

  invisible(meds)
}


# TODO: get/set_meds functions
