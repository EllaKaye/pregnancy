# functions relating to pregnancy progress

how_far_calculation <- function(on_date = Sys.Date(), due_date = NULL) {
  check_date(on_date)

  due_date <- due_date %||% getOption("pregnancy.due_date") %||% date_abort(due_date)
  check_date(due_date)

  # date calculations
  start_date <- due_date - 280

  days_along <- as.numeric(difftime(on_date, start_date, units = "days"))
  weeks_pregnant <- floor(days_along / 7)
  and_days_pregnant <- round(days_along %% 7)

  days_to_go = 280 - days_along
  weeks_to_go <- floor(days_to_go / 7)
  and_days_to_go <- round(days_to_go %% 7)

  percent_along <- round((days_along / 280) * 100)

  list(
    days_along = days_along,
    weeks_pregnant = weeks_pregnant,
    and_days_pregnant = and_days_pregnant,
    weeks_to_go = weeks_to_go,
    and_days_to_go = and_days_to_go,
    percent_along = percent_along,
    due_date = due_date
  )
}

how_far_message <- function(calc_results, on_date = Sys.Date(), person = NULL) {
  # grammar for output message
  person <- person %||% getOption("pregnancy.person") %||% "You"
  subject <- get_subject(person) # "I", "You" or person
  tense <- get_tense(Sys.Date(), on_date) # "present", "past", "future"
  verb <- to_be(subject, tense)

  # when more than a couple of weeks past due date (i.e. should no longer be pregnant)
  if (calc_results$weeks_pregnant > 42) {
    subject = ifelse(subject == "You", "you", subject)
    
    if (tense == "present") {
      message <- cli::format_inline(
        "Given a due date of {format(calc_results$due_date, '%B %d, %Y')}, {subject} would now be more than 42 weeks pregnant."
      )
    } else if (tense == "past") {
      message <- cli::format_inline(
        "Given a due date of {format(calc_results$due_date, '%B %d, %Y')}, on {format(on_date, '%B %d, %Y')}, {subject} would have been more than 42 weeks pregnant."
      )
    } else {
      message <- cli::format_inline(
        "Given a due date of {format(calc_results$due_date, '%B %d, %Y')}, on {format(on_date, '%B %d, %Y')}, {subject} would be more than 42 weeks pregnant."
      )
    }
    
    return(list(messages = message))
  }

  # format regular messages
  if (tense == "present") {
    messages <- c(
      cli::format_inline(
        "{subject} {verb} {calc_results$weeks_pregnant} week{?s} and {calc_results$and_days_pregnant} day{?s} pregnant."
      ),
      cli::format_inline(
        "That's {calc_results$weeks_to_go} week{?s} and {calc_results$and_days_to_go} day{?s} until the due date ({format(calc_results$due_date, '%B %d, %Y')})."
      ),
      cli::format_inline(
        "{subject} {verb} {calc_results$percent_along}% through the pregnancy."
      )
    )
  } else {
    subject = ifelse(subject == "You", "you", subject)
    messages <- cli::format_inline(
      "On {format(on_date, '%B %d, %Y')}, {subject} {verb} {calc_results$weeks_pregnant} week{?s} and {calc_results$and_days_pregnant} day{?s} pregnant."
    )
  }

  list(messages = messages)
}

# TODO: document
# TODO: check due date in relation to on_date/Sys.Date()
how_far <- function(on_date = Sys.Date(), due_date = NULL, person = NULL) {
  # Calculate pregnancy statistics
  calc_results <- how_far_calculation(on_date = on_date, due_date = due_date)
  
  # Generate appropriate messages
  message_results <- how_far_message(
    calc_results = calc_results,
    on_date = on_date,
    person = person
  )
  
  # Print messages
  cli::cli_inform(c("i" = message_results$messages))

  # Return days along invisibly
  invisible(calc_results$days_along)
}


