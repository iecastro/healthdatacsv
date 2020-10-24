

test_that("output is tibble", {
  expect_is(fetch_catalog(), "tbl_df")
  expect_is(fetch_catalog(agency = "Centers for Disease Control and Prevention"),
            "tbl_df")
  expect_is(fetch_catalog(keyword = "adopt"), "tbl_df")
  expect_is(fetch_catalog(agency = "Centers for Disease Control and Prevention",
                          keyword = "influenza"),
            "tbl_df")

})


test_that("message is displayed for wrong argument input", {
  expect_message(fetch_catalog("CDC"))
  expect_message(fetch_catalog(keyword = "adpt"))
  expect_message(fetch_catalog(agency = "cdc", keyword = "adpt"))
  expect_message(fetch_catalog(agency = "cdc", keyword = "adopt"))
  expect_message(fetch_catalog(agency = "Centers for Disease Control and Prevention",
                               keyword = "adopt"))

})


test_that("keyword accepts regex pattern", {
  expect_equal(
    nrow(fetch_catalog(keyword = "influenza|adopt")),
      nrow(fetch_catalog(keyword = "influenza")) +
      nrow(fetch_catalog(keyword = "adopt"))
  )

})
