
api_call <- healthdata_api("data.json")

test_that("succesful status response code", {
  expect_equal(httr::status_code(api_call$response), 200)
})

