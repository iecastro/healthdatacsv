
test_that("output is tibble", {
  expect_is(get_agencies(), "tbl_df")
})


test_that("output is tibble", {
  expect_is(get_agencies("CDC"),
            "tbl_df")
})
