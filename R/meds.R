# functions related to medications
# medications_remaining()
# get_medications()
# set_medications()

#' Calculate remaining medications to be taken
#'
#' @description
#' Calculates and displays how many medications remain to be taken as of a specific date,
#' based on a schedule of medications with start and stop dates. Results can be grouped
#' either by medication name or by format (e.g., tablet, injection).
#'
#' @param medications Data frame containing medication schedule. Must have the following columns:
#'   * medication (character/factor): Name of the medication
#'   * format (character/factor): Format of the medication (e.g., pill, injection)
#'   * quantity (numeric): Number of units to take per day
#'   * start_date (Date): Date to start taking the medication
#'   * stop_date (Date): Final date to take the medication
#'   If NULL, will try to use the "pregnancy.medications" option. Required if option not set.
#' @param group Character string specifying how to group the results. One of:
#'   * "medication": Group by medication name (default)
#'   * "format": Group by medication format
#' @param on_date Date object specifying the date for which to calculate remaining medications.
#'   Defaults to current system date. This parameter exists primarily for testing and
#'   documentation purposes and it is unlikely to make sense for the user to need or
#'   want to change it from the default.
#'
#' @return
#' Invisibly returns a data frame containing remaining quantities, grouped as specified.
#' The data frame has two columns:
#'   * First column: Either 'medication' or 'format' depending on grouping
#'   * quantity_remaining: Total number of units remaining
#' Only medications with remaining quantities > 0 are included.
#'
#' Also prints a message to the console indicating either that no medications remain,
#' or showing the quantities remaining for each medication/format.
#'
#' @section Global Options:
#' * pregnancy.medications: Data frame setting default medication schedule
#'
#' @examples
#' # Define medications table
#' #' # Create example medication schedule
#' meds <- data.frame(
#'   medication = c("progynova", "prednisolone", "clexane"),
#'   format = c("tablet", "tablet", "injection"),
#'   quantity = c(3, 2, 1),
#'   start_date = as.Date(c("2025-04-21", "2025-04-26", "2025-05-08")),
#'   stop_date = as.Date(c("2025-04-30", "2025-05-07", "2025-09-05"))
#' )
#'
#' # Calculate remaining medications for a specific date
#' medications_remaining(
#'   medications = meds,
#'   on_date = as.Date("2025-04-21")
#' )
#' 
#' medications_remaining(
#'   medications = meds,
#'   group = "format",
#'   on_date = as.Date("2025-04-21")
#' )
#'
#' # Set and use global medications option
#' #' Store original medications setting
#' original_medications <- getOption("pregnancy.medications")
#' set_medications(pregnancy::medications)
#' medications_remaining(on_date = as.Date("2025-05-01"))
#'
#' # Restore original medications setting
#' set_medications(original_medications)
#'
#' @seealso
#' * [set_medications()] for setting default medication schedule
#' * [get_medications()] for retrieving current medication schedule
#' * [medications] for an example medications data frame
#'
#' @export
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

#' Set or Get the `pregnancy.medications` option
#'
#' @description
#' Functions to get and set the default medications data frame used in the [medications_remaining()] function.
#' Settings persist for the current R session only, unless added to
#' .Rprofile. `set_medications()` sets the "pregnancy.medications" option and `get_medications()` retrieves it.
#'
#' @inheritParams medications_remaining
#'
#' @return
#' Both functions invisibly return the current medications setting:
#' * [get_medications()] returns the current setting (a data frame) or NULL if not set
#' * [set_medications()] returns the medications data frame that was set
#'
#' @seealso
#' * [medications_remaining()], [medications] 
#'
#' @examples
#' # Store original setting
#' original_medications <- getOption("pregnancy.medications")
#' 
#' # Set the option
#' set_medications(pregnancy::medications)
#' 
#' # Get the option
#' get_medications()
#'
#' # Restore original setting
#' set_medications(original_medications)
#'
#' @name medications-option
NULL

#' @rdname medications-option
#' @export
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

#' @rdname medications-option
#' @export
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





