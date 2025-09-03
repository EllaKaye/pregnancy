## code to prepare `medications` dataset goes here
# fmt: skip
medications <- tibble::tribble(
  ~medication, ~format, ~quantity, ~start_date, ~stop_date,
  "progynova", "tablet", 3, as.Date("2025-07-21"), as.Date("2025-07-30"),
  "LDA", "tablet", 1, as.Date("2025-07-21"), as.Date("2025-08-07"),
  "prednisolone", "tablet", 2, as.Date("2025-07-26"), as.Date("2025-8-07"),
  "progynova", "tablet", 6, as.Date("2025-08-01"), as.Date("2025-10-11"),
  "cyclogest", "pessary", 2, as.Date("2025-08-03"), as.Date("2025-10-11"),
  "lubion", "injection", 1, as.Date("2025-08-03"), as.Date("2025-10-11"),
  "clexane", "injection", 1, as.Date("2025-08-08"), as.Date("2025-12-05"),
  "prednisolone", "tablet", 4, as.Date("2025-08-08"), as.Date("2025-10-11"),
  "prednisolone", "tablet", 3, as.Date("2025-10-12"), as.Date("2025-10-14"),
  "prednisolone", "tablet", 2, as.Date("2025-10-15"), as.Date("2025-10-17"),
  "prednisolone", "tablet", 1, as.Date("2025-10-18"), as.Date("2025-10-20"),
  "prednisolone", "tablet", 1, as.Date("2025-10-22"), as.Date("2025-10-22"),
  "prednisolone", "tablet", 1, as.Date("2025-10-24"), as.Date("2025-10-24"),
  "prednisolone", "tablet", 1, as.Date("2025-10-26"), as.Date("2025-10-26")
)

usethis::use_data(medications, overwrite = TRUE)
