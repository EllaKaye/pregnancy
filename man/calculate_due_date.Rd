% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/due_date.R
\name{calculate_due_date}
\alias{calculate_due_date}
\title{Calculate due date}
\usage{
calculate_due_date(
  start_date,
  start_type = c("LMP", "conception", "transfer_day_3", "transfer_day_5",
    "transfer_day_6"),
  cycle = 28
)
}
\arguments{
\item{start_date}{Start date}

\item{start_type}{Start type}

\item{cycle}{Cycle length}
}
\value{
Your due date
}
\description{
Calculate due date
}
\examples{
my_start_date <- as.Date("2023-01-31")
calculate_due_date(my_start_date)
due_date <- calculate_due_date(my_start_date, "conception")
due_date
class(due_date)
}
