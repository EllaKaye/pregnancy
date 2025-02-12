meds <- data.frame(
  medication = c("A", "B", "C", "C"),
  format = c("tablet", "tablet", "injection", "injection"),
  quantity = c(1, 2, 2, 1),
  start_date = as.Date(c("2025-04-01", "2025-04-03", "2025-04-05", "2025-04-06")),
  stop_date = as.Date(c("2025-04-04", "2025-04-05", "2025-04-05", "2025-04-06"))
)

saveRDS(meds, "./tests/testthat/fixtures/meds.rds")
