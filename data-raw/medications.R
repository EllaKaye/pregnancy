## code to prepare `medications` dataset goes here

library(tibble)
library(lubridate)

medications <- tribble(
  ~medication, ~format, ~quantity, ~start_date, ~stop_date,
  "progynova", "pills", 3, ymd("2025-04-21"), ymd("2025-04-30"),
  "LDA", "pills", 1, ymd("2025-04-21"), ymd("2025-05-07"),
  "prednisolone", "pills", 2, ymd("2025-04-26"), ymd("2025-05-07"),
  "progynova", "pills", 6, ymd("2025-05-01"), ymd("2025-07-11"),
  "cyclogest", "pessary", 2, ymd("2025-05-03"), ymd("2025-07-11"),
  "lubion", "injection", 1, ymd("2025-05-03"), ymd("2025-07-11"),
  "clexane", "injection", 1, ymd("2025-05-08"), ymd("2025-09-05"),
  "prednisolone", "pills", 4, ymd("2025-05-08"), ymd("2025-07-11"),
  "prednisolone", "pills", 3, ymd("2025-07-12"), ymd("2025-07-14"),
  "prednisolone", "pills", 2, ymd("2025-07-15"), ymd("2025-07-17"),
  "prednisolone", "pills", 1, ymd("2025-07-18"), ymd("2025-07-20"),
  "prednisolone", "pills", 1, ymd("2025-07-22"), ymd("2025-07-22"),
  "prednisolone", "pills", 1, ymd("2025-07-24"), ymd("2025-07-24"),
  "prednisolone", "pills", 1, ymd("2025-07-26"), ymd("2025-07-26")
)


usethis::use_data(medications, overwrite = TRUE)
