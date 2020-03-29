
test_that("output is tibble", {
  expect_is(fetch_catalog(), "tbl_df")
})


