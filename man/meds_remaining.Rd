% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/meds.R
\name{meds_remaining}
\alias{meds_remaining}
\title{Title}
\usage{
meds_remaining(
  on_date = Sys.Date(),
  meds = NULL,
  group = c("medication", "format")
)
}
\arguments{
\item{on_date}{date}

\item{meds}{meds}

\item{group}{group}
}
\value{
prints in console, returns a data frame invisibly
}
\description{
Title
}
\examples{
meds_remaining(on_date = as.Date("2023-04-30"), meds = medications)
}
