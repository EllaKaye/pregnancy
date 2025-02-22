# nolint start: object_name_linter
`I` <- c("was", "am", "will be")
You <- c("were", "are", "will be")
She <- c("was", "is", "will be")
# nolint end

to_be_mat <- rbind(`I`, You, She)

colnames(to_be_mat) <- c("past", "present", "future")

usethis::use_data(to_be_mat, internal = TRUE, overwrite = TRUE)
