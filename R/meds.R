# functions related to medications
# medications_remaining()
# get_medications()
# set_medications()

# need to copy over then modify code from EMKpregnancy package
#' Title
#'
#' @param on_date date
#' @param medications medications
#' @param group group
#'
#' @return prints in console, returns a data frame invisibly
#' @export
#'
#' @examples medications_remaining(on_date = as.Date("2025-04-30"), medications = medications)
medications_remaining <-
  function(medications = NULL,
           group = c("medication", "format"),
           on_date = Sys.Date()) {
    check_date(on_date)

    # TODO: better abort message (see date_abort)
    medications <- medications %||% getOption("pregnancy.medications") %||% cli::cli_abort("NEEDS medications")
    check_medications(medications)

    group <- rlang::arg_match(group)

    medications_aug <- medications %>%
      dplyr::mutate(total_days = (stop_date - start_date) + 1) %>%
      dplyr::mutate(total_quantity = as.integer(total_days * quantity)) %>%
      dplyr::mutate(days_remaining = dplyr::case_when(
        on_date <= stop_date & on_date >= start_date ~ (as.integer(stop_date - on_date) + 1),
        start_date > on_date ~ (as.integer(stop_date - start_date) + 1),
        TRUE ~ 0
      )) %>%
      dplyr::mutate(quantity_remaining = as.integer(days_remaining * quantity))

    if (group == "medication") {
      medications_summary <- medications_aug %>%
        dplyr::group_by(medication) %>%
        dplyr::summarise(quantity_remaining = sum(quantity_remaining)) %>%
        dplyr::filter(quantity_remaining > 0)
    }

    if (group == "format") {
      medications_summary <- medications_aug %>%
        dplyr::group_by(format) %>%
        dplyr::summarise(quantity_remaining = sum(quantity_remaining)) %>%
        dplyr::filter(quantity_remaining > 0)
    }

    if (nrow(medications_summary) == 0) {
      cli::cli_alert_success("There are no medications remaining.")
      return(invisible(medications_summary))
    }

    medications_summary
  }

check_medications <- function(medications) {
  if (!is.data.frame(medications)) {
    cli::cli_abort(
      c("{.var medications} must be a data frame.",
        "i" = "It was {.type {medications}} instead."
      ),
      class = "pregnancy_error_class"
    )
  }

  colnames_medications <- colnames(medications)
  needs_cols <- c("medication", "format", "quantity", "start_date", "stop_date")
  diff <- setdiff(needs_cols, colnames_medications)

  if (length(diff) > 0) {
    message <- c("{.var medications} is missing column{?s} {.code {diff}}.")
    cli::cli_abort(message,
      class = "pregnancy_error_missing"
    )
  }

  if (!lubridate::is.Date(medications[["start_date"]]) || !lubridate::is.Date(medications[["stop_date"]])) {
    cli::cli_abort(
      c(
        "In {.var medications}, columns {.code start_date} and {.code stop_date} must have class {.cls Date}.",
        "i" = "{.var start_date} was class {.cls {class(medications[['start_date']])}}.",
        "i" = "{.var stop_date} was class {.cls {class(medications[['stop_date']])}}."
      ),
      class = "pregnancy_error_class"
    )
  }

  if (!rlang::is_character(medications$medication) && !is.factor(medications$medication)) {
    cli::cli_abort(
      c(
        "In {.var medications}, column {.code medication} must have class {.cls character} or {.cls factor}.",
        "i" = "It was class {.cls {class(medications$medication)}}."
      ),
      class = "pregnancy_error_class"
    )
  }

  if (!rlang::is_character(medications$format) && !is.factor(medications$format)) {
    cli::cli_abort(
      c(
        "In {.var medications}, column {.code format} must have class {.cls character} or {.cls factor}.",
        "i" = "It was class {.cls {class(medications$format)}} instead."
      ),
      class = "pregnancy_error_class"
    )
  }

  if (!is.numeric(medications$quantity)) {
    cli::cli_abort(
      c(
        "In {.var medications}, column {.code quantity} must have class {.cls numeric}.",
        "i" = "It was class {.cls {class(medications$quantity)}} instead."
      ),
      class = "pregnancy_error_class"
    )
  }

  invisible(medications)
}

# TODO: get/set_medications functions
set_medications <- function(medications) {
  # check date
  if (!is.null(medications)) {
    check_medications(medications)
  }

  options("pregnancy.medications" = medications)

  # TODO: different message if due_date = NULL
  cli::cli_alert_success("medications option set")
  set_option_message("medications")

  invisible(medications)
}

get_medications <- function() {
  medications <- getOption("pregnancy.medications")

  if (is.null(medications)) {
    null_option("medications")
  } else {
    check_medications(medications)
    cli::cli_inform("Your medications table is set as")
    print(medications)
  }

  invisible(medications)
}


# tibble output actually looks better than cli here
# probably don't export this function, don't need it.
# DON'T have on_date. Need to pass that as flag from medications_remaining
# (otherwise docuemnt that on_date must be set the same in both medications_remaining and medications_print)
medications_print <- function(medications_summary, on_date = Sys.Date()) {
  # TODO: use person and have (via a new to_have function)
  if (nrow(medications_summary) == 0) {
    cli::cli_alert_success("There are no medications remaining.")
    return(invisible(medications_summary))
  }

  # check col names
  thing <- medications_summary[[1]]
  quantity <- medications_summary[[2]]

  # TODO: pick up here...

  if (on_date == Sys.Date()) {
    cli::cli_alert_info("As of first thing today, the following medications remain to be taken:")
  } else {
    cli::cli_alert_info("As of first thing on {format(on_date, '%B %d, %Y')}, the following medications remain to be taken:")
  }

  for (i in 1:length(thing)) {
    cli::cli_bullets(c("*" = "{quantity[i]} {thing[i]}"))
  }

  invisible(medications_summary)
}





