
cdc_built_env <- fetch_catalog("Centers for Disease Control and Prevention",
                               keyword = "built environment")

test_that("output is tibble", {
  expect_is(fetch_csv(cdc_built_env), "tbl_df")
})


test_that("nested data is tibble", {
  expect_is(fetch_csv(cdc_built_env)[[6]][[1]], "tbl_df")
})


test_that("columns separated", {
  expect_gt(fetch_csv(cdc_built_env)[[6]][[1]] %>%
                     ncol(),
                   1)
})
