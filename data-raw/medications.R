## code to prepare `medications` dataset goes here
medications <- tibble::tribble(
  ~medication, ~format, ~quantity, ~start_date, ~stop_date,
  "progynova", "tablet", 3, as.Date("2025-04-21"), as.Date("2025-04-30"),
  "LDA", "tablet", 1, as.Date("2025-04-21"), as.Date("2025-05-07"),
  "prednisolone", "tablet", 2, as.Date("2025-04-26"), as.Date("2025-05-07"),
  "progynova", "tablet", 6, as.Date("2025-05-01"), as.Date("2025-07-11"),
  "cyclogest", "pessary", 2, as.Date("2025-05-03"), as.Date("2025-07-11"),
  "lubion", "injection", 1, as.Date("2025-05-03"), as.Date("2025-07-11"),
  "clexane", "injection", 1, as.Date("2025-05-08"), as.Date("2025-09-05"),
  "prednisolone", "tablet", 4, as.Date("2025-05-08"), as.Date("2025-07-11"),
  "prednisolone", "tablet", 3, as.Date("2025-07-12"), as.Date("2025-07-14"),
  "prednisolone", "tablet", 2, as.Date("2025-07-15"), as.Date("2025-07-17"),
  "prednisolone", "tablet", 1, as.Date("2025-07-18"), as.Date("2025-07-20"),
  "prednisolone", "tablet", 1, as.Date("2025-07-22"), as.Date("2025-07-22"),
  "prednisolone", "tablet", 1, as.Date("2025-07-24"), as.Date("2025-07-24"),
  "prednisolone", "tablet", 1, as.Date("2025-07-26"), as.Date("2025-07-26")
)


usethis::use_data(medications, overwrite = TRUE)
