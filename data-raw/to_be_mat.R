`I` <- c("was", "am", "will be")
You <- c("were", "are", "will be")
She <- c("was", "is", "will be")

to_be_mat <- rbind(`I`, You, She)

colnames(to_be_mat) <- c("past", "present", "future")

usethis::use_data(to_be_mat, internal = TRUE)