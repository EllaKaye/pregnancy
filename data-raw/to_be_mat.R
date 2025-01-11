`I` <- c("was", "am", "will be")
you <- c("were", "are", "will be")
she <- c("was", "is", "will be")

to_be_mat <- rbind(`I`, you, she)

colnames(to_be_mat) <- c("past", "present", "future")

usethis::use_data(to_be_mat, internal = TRUE, overwrite = TRUE)