
test_that("output is tibble", {
  skip_on_cran()
  expect_is(get_agencies(), "tbl_df")
})


test_that("output is tibble", {
  skip_on_cran()
  expect_is(get_agencies("CDC"),
            "tbl_df")
})
