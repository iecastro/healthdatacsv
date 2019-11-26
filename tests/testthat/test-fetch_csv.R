library(healthdatacsv)

cdc_built_env <- fetch_catalog("Centers for Disease Control and Prevention",
                               keyword = "built environment")

test_that("output is list", {
  expect_is(fetch_csv(cdc_built_env), "tbl_df")
})


test_that("data is nested tibble", {
  expect_is(fetch_csv(cdc_built_env)[[6]][[1]], "spec_tbl_df")
})
