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
#' @param meds Data frame containing medication schedule. Must have the following columns:
#'   * medication (character/factor): Name of the medication
#'   * format (character/factor): Format of the medication (e.g., pill, injection)
#'   * quantity (numeric): Number of units to take per day
#'   * start_date (Date): Date to start taking the medication
#'   * stop_date (Date): Final date on which the medication is taken
#'   If NULL, will try to use the "pregnancy.medications" option. Required if option not set.
#' @param group Character string specifying how to group the results. One of:
#'   * "medication": Group by medication name (default)
#'   * "format": Group by medication format
#' @param on_date Date object specifying the date from which to calculate remaining medications.
#'   Defaults to current system date.
#' @param until_date Date object specifying cut-off date for remaining medications.
#'   If NULL, defaults to the latest `stop_date` in `medications`
#'
#' @return
#' Returns a data frame containing remaining quantities, grouped as specified.
#' Assumes that the function is being called first thing in the day,
#' i.e. before any of `on_date`'s medications have been taken.
#' The data frame has two columns:
#'   * Either 'medication' or 'format' depending on grouping
#'   * quantity: Total number of units remaining
#'
#' Only medications with remaining quantities > 0 are included.
#'
#' If no medications remain, a message is printed to the console indicating this,
#' and a data frame with 0 rows in returned invisibly.
#'
#' @section Global Options:
#' * `pregnancy.medications`: Data frame setting default medication schedule
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
#' # Calculate remaining medications
#' medications_remaining(meds, on_date = as.Date("2025-04-21"))
#'
#' medications_remaining(meds, group = "format", on_date = as.Date("2025-04-21"))
#'
#' # Calculate medications for a specified period
#' medications_remaining(
#'   meds = meds,
#'   on_date = as.Date("2025-04-23"),
#'   until_date = as.Date("2025-04-30")
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
  function(
    meds = NULL,
    group = c("medication", "format"),
    on_date = Sys.Date(),
    until_date = NULL
  ) {
    check_date(on_date)

    # TODO: better abort message (see date_abort)
    meds <- meds %||%
      getOption("pregnancy.medications") %||%
      cli::cli_abort("NEEDS medications")
    check_medications(meds)

    group <- rlang::arg_match(group)

    latest_stop <- meds %>%
      dplyr::pull(stop_date) %>%
      max()
    until_date <- until_date %||% latest_stop
    check_date(until_date)

    # TODO: more informative error message
    if (until_date < on_date) {
      cli::cli_abort(
        "`until_date` must be later than `on_date`.",
        call = rlang::caller_env(),
        class = "date_order_error"
      )
    }

    meds_aug <-
      meds %>%
      dplyr::mutate(from = pmax(on_date, start_date)) %>%
      dplyr::mutate(to = pmin(until_date, stop_date)) %>%
      # dplyr::mutate(total_days = (stop_date - start_date) + 1) %>%
      # dplyr::mutate(total_quantity = as.integer(total_days * quantity)) %>%
      # dplyr::mutate(days_remaining = dplyr::case_when(
      #   on_date <= stop_date & on_date >= start_date ~ (as.integer(stop_date - on_date) + 1),
      #   start_date > on_date ~ (as.integer(stop_date - start_date) + 1),
      #   TRUE ~ 0
      # )) %>%
      dplyr::mutate(days = pmax(0, (as.integer(to - from) + 1))) %>%
      # dplyr::mutate(quantity_remaining = as.integer(days_remaining * quantity)) %>%
      dplyr::mutate(quant = as.integer(days * quantity))

    if (group == "medication") {
      meds_summary <- meds_aug %>%
        dplyr::group_by(medication) %>%
        dplyr::summarise(quantity = sum(quant)) %>%
        dplyr::filter(quantity > 0)
    }

    if (group == "format") {
      meds_summary <- meds_aug %>%
        dplyr::group_by(format) %>%
        dplyr::summarise(quantity = sum(quant)) %>%
        dplyr::filter(quantity > 0)
    }

    if (nrow(meds_summary) == 0) {
      cli::cli_alert_success("There are no medications remaining.")
      return(invisible(meds_summary))
    }

    meds_summary
  }


check_medications <- function(meds) {
  if (!is.data.frame(meds)) {
    cli::cli_abort(
      c(
        "{.var meds} must be a data frame.",
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
    cli::cli_abort(message, class = "pregnancy_error_missing")
  }

  if (
    !lubridate::is.Date(meds[["start_date"]]) ||
      !lubridate::is.Date(meds[["stop_date"]])
  ) {
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

#' Set or get the `pregnancy.medications` option
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
set_medications <- function(meds) {
  # check date
  if (!is.null(meds)) {
    check_medications(meds)
  }

  options("pregnancy.medications" = meds)

  if (is.null(meds)) {
    set_option_null_message("medications")
  } else {
    cli::cli_alert_success("medications set.")
    set_option_message("medications")
  }

  invisible(meds)
}

#' @rdname medications-option
#' @export
get_medications <- function() {
  meds <- getOption("pregnancy.medications")

  if (is.null(meds)) {
    null_option("medications")
  } else {
    check_medications(meds)
    cli::cli_inform("Your medications table is set as")
    print(meds)
  }

  invisible(meds)
}
