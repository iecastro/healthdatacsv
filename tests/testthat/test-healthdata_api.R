
with_mock_api({
  api_call <- healthdata_api("data.json")

  test_that("Requests happen", {
    expect_equal(httr::status_code(api_call$response), 200)
    expect_equal(httr::http_type(api_call$response), "application/json")
  })
})


with_mock_api({
  api_call <- healthdata_api("data.json")

  test_that("Response is cached", {
    expect_true(httpcache::hitCache("http://www.healthdata.gov/data.json"))
  })
})


