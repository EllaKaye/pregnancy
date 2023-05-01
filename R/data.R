#' An example medications table
#'
#' A data frame with example medications that might be used during fertility treatment/first trimester.
#' It is an example of a data frame that might be used as the `meds` argument to [meds_remaining()].
#'
#' Note that the same medication (prednisolone in this example) has several rows, first because the quantity taken per day changes, then because it needs to be taken on non-consecutive days.
#'
#' @format
#' A data frame with 14 rows and 5 columns:
#' \describe{
#'   \item{medication}{Name of the medication}
#'   \item{format}{Format of medication}
#'   \item{quantity}{Number taken per day}
#'   \item{start_date}{Date to start taking the medication}
#'   \item{stop_date}{Final date on which the medication is taken. See details.}
#' }
#' @examples medications
#' @seealso [meds_remaining()]
"medications"
