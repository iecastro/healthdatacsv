
test_that("output is tibble", {
  expect_is(list_agencies(), "tbl_df")
})


test_that("output is tibble", {
  expect_is(list_agencies("CDC"),
            "tbl_df")
})
