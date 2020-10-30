

test_that("output is tibble", {
  skip_on_cran()
  cdc_built_env <- fetch_catalog("Centers for Disease Control and Prevention",
                                 keyword = "built environment")
  expect_is(fetch_data(cdc_built_env), "tbl_df")
})


test_that("nested data is tibble", {
  skip_on_cran()
  cdc_built_env <- fetch_catalog("Centers for Disease Control and Prevention",
                                 keyword = "built environment")
  expect_is(fetch_data(cdc_built_env)[[6]][[1]], "tbl_df")
})


test_that("columns separated", {
  skip_on_cran()
  cdc_built_env <- fetch_catalog("Centers for Disease Control and Prevention",
                                 keyword = "built environment")
  expect_gt(fetch_data(cdc_built_env)[[6]][[1]] %>%
                     ncol(),
                   1)
})


