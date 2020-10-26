
cdc_built_env <- fetch_catalog("Centers for Disease Control and Prevention",
                               keyword = "built environment")

test_that("output is tibble", {
  expect_is(fetch_data(cdc_built_env), "tbl_df")
})


test_that("nested data is tibble", {
  expect_is(fetch_data(cdc_built_env)[[6]][[1]], "tbl_df")
})


test_that("columns separated", {
  expect_gt(fetch_data(cdc_built_env)[[6]][[1]] %>%
                     ncol(),
                   1)
})


nodata <- fetch_catalog() %>%
  filter(csv_avail == FALSE)

test_that("message is displayed", {
  expect_error(fetch_data(nodata))
})
