
test_that("output is tibble", {
  skip_on_cran()
  expect_is(get_keywords(), "tbl_df")
})


test_that("output is tibble", {
  skip_on_cran()
  expect_is(get_keywords("Centers for Disease Control and Prevention"),
            "tbl_df")
})


test_that("message is displayed for wrong agency name", {
  skip_on_cran()
  expect_message(get_keywords("CDC"))
})
