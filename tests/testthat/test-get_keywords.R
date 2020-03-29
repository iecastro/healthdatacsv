
test_that("output is tibble", {
  expect_is(get_keywords(), "tbl_df")
})


test_that("output is tibble", {
  expect_is(get_keywords("Centers for Disease Control and Prevention"),
            "tbl_df")
})


test_that("message is displayed for wrong agency name", {
  expect_message(get_keywords("CDC"))
})
