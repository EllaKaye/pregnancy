# calculate_test_date message

    Code
      calculate_test_date(start_date)
    Message
      i Estimated test date (urine): Tuesday, February 28, 2023
      i Estimated test date (blood): Sunday, February 26, 2023

# get_test_date informs when test date is not set

    Code
      get_test_date()
    Message
      ! You do not have `pregnancy.test_date` set as an option.
      i You can set it with `set_test_date()`.
      i You can also pass a value directly to the `test_date` argument where required.

---

    Code
      get_test_date()
    Message
      ! You do not have `pregnancy.test_date` set as an option.
      i You can set it with `set_test_date()`.
      i You can also pass a value directly to the `test_date` argument where required.

# set_test_date provides appropriate messages

    Code
      set_test_date(as.Date("2023-04-30"))
    Message
      v Test date set as April 30, 2023
      i Functions in the pregnancy package will now use this `test_date` option.
      i So, for this R session, you do not need to supply a value to the `test_date` argument (unless you wish to override the option).
      i To make this `test_date` option available in all R sessions, in your ".Rprofile", set `options(pregnancy.test_date = ...)`
        where ... is the value of `test_date`.
      i You can edit your ".Rprofile" by calling `usethis::edit_r_profile()`
      i You can retrieve the `test_date` option with `get_test_date()`,
        or with `getOption('pregnancy.test_date')`.

---

    Code
      set_test_date(NULL)
    Message
      v pregnancy.test_date option set to NULL.
      i You will need to explicitly pass a value to the `test_date` argument
        in functions that use it, or reset the option with `set_test_date()`.

