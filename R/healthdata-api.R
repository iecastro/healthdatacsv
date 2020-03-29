#' Fetch the available catalog from healthdata.gov
#'
#' This function allows users to pull the catalog in its entirety,
#' filter by agency, keyword(s), or both
#'
#' @param agency name of agency to pull in API call.
#'        This requires the full agency name in proper case.
#'        Function list_agencies() can be used for a list of
#'        available agencies. Defaults to NULL.
#' @param keyword keyword(s) to pull in API call.
#'        This argument can be supplied on its own or with an agency argument.
#'        The keyword argument uses regular expression to detect presence of
#'        pattern in a string. Function get_keywords() can be used for a list
#'        of exact keywords available in API. Defaults to NULL.
#' @return a [`tibble`][tibble::tibble()] with descriptive metadata of
#'         the available catalog including a nested list-column of the
#'         data distribution.
#' @examples
#' \dontrun{
#' fetch_catalog("Centers for Disease Control and Prevention")
#'
#' cdc_alc <- fetch_catalog("Centers for Disease Control and Prevention",
#'   keyword = "alcohol|alcohol use"
#' )
#' }
#' @export

fetch_catalog <- function(agency = NULL,
                          keyword = NULL) {

  api_call <- healthdata_api("data.json")

  parsed <- api_call$parsed

  parsed_dataset <- parsed$dataset

  x <- keyword

  catalog <-
    jsonlite::flatten(parsed_dataset) %>%
    as_tibble() %>%
    select(
      publisher = .data$publisher.name,
      product = .data$title,
      .data$description,
      .data$modified,
      .data$distribution,
      .data$keyword
    ) %>%
    mutate(
      csv_avail =
        suppressWarnings(stringr::str_detect(.data$distribution, "csv"))
    )

  if (!is.null(agency)) {
    catalog <- catalog %>%
      filter(.data$publisher == agency)
  }

  if (is.null(keyword)) {
    catalog %>%
      select(-.data$keyword)
  } else {
    catalog %>%
      mutate(
        keyword = purrr::map(
          keyword,
          stringr::str_detect, x
        ),
        keyword = purrr::map_lgl(keyword, any)
      ) %>%
      filter(.data$keyword == TRUE) %>%
      select(-.data$keyword)
  }
}


#' Fetch data from the healthdata.gov API
#'
#' This function will download data healthdata.gov,
#' if available in csv format
#'
#' @param catalog this argument requires a catalog (tibble) created
#'        with fetch_catalog()
#' @return a [`tibble`][tibble::tibble()] with descriptive metadata
#'         of a data product and a list-column of the available dataset.
#' @examples
#' \dontrun{
#' cdc_alc <- fetch_catalog("Centers for Disease Control and Prevention",
#'   keyword = "alcohol|alcohol use"
#' )
#'
#' nested_df_alc <- cdc_alc %>%
#'   dplyr::slice(1:2) %>% # pull Alzheimer's and Chronic Indicators datasets
#'   fetch_data()
#' }
#' @export

fetch_data <- function(catalog) {
  df <- catalog %>%
    filter(.data$csv_avail == TRUE)

  if (nrow(df) == 0){
    stop(
      paste0("It seems there was nothing to download for you. ",
             "Make sure the product you're trying to get ",
             "has a download option in CSV format by checking ",
             "that column `csv_avail` is true in the catalog supplied.")
    )
  }

  csv_list <- df %>%
    tidyr::unnest(cols = c(.data$distribution)) %>%
    mutate(is_csv = stringr::str_detect(.data$downloadURL, "csv")) %>%
    filter(.data$is_csv == TRUE) %>%
    select(
      .data$publisher,
      .data$product,
      .data$description,
      .data$modified,
      .data$downloadURL
    ) %>%
    mutate(
      data_tbl =
        purrr::map(.data$downloadURL, ~ vroom::vroom(., delim = ",")
        )
    )

  csv_list
}

#' healdata.gov API call for data.json endpoint
#' @noRd

healthdata_api <- function(path) {
  user <- user_agent("http://github.com/iecastro/healthdatacsv")

  data_url <- modify_url("http://www.healthdata.gov/api",
    path = path
  )

  response <- GET(data_url, user)

  parsed <- jsonlite::fromJSON(httr::content(response, "text",
                                             encoding = "UTF-8"))

  if (http_error(response)) {
    stop(
      sprintf(
        "HealthData.gov API request failed [%s]\n%s\n<%s>",
        status_code(response),
        parsed$message,
        parsed$documentation_url
      ),
      call. = FALSE
    )
  }

  return(list(
    "response" = response,
    "parsed" = parsed)
    )
}
