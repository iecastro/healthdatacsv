#' Function to fetch the current available catalog from healthdata.gov
#' This function allows to pull the catalog in its entirety or filter by
#' agency, keyword(s), or both
#'
#' @param agency name of agency to pull in API call.
#'        This requires the full agency name in proper case. Function list_agencies() can
#'        be used for a list of available agencies.
#'        Defaults to NULL.
#' @param keyword keyword(s) to pull in API call.
#'        This argument can be supplied on its own or with an agency argument.  The
#'        keyword argument uses regular expression to detect presence of pattern in a string.
#'        Function get_keywords() can be used for a list of exact keywords available in API.
#'        Defaults to NULL.
#' @return a tibble with descriptive metadata of the available catalog including a nested
#'         list-column of the data distribution
#' @examples \dontrun{
#' fetch_catalog("Centers for Disease Control and Prevention")
#' cdc_alc <- fetch_catalog("Centers for Disease Control and Prevention",
#'                           keyword = "alcohol|alcohol use")
#' }
#' @export

fetch_catalog <- function(agency = NULL,
                          keyword = NULL){

  parsed <- healthdata_api()

  parsed_dataset <- parsed$dataset

  if (is.null(agency)) {

    catalog <-
      jsonlite::flatten(parsed_dataset) %>%
      as_tibble() %>%
      select(publisher.name,
             product = title,
             description,
             modified,
             distribution,
             keyword) %>%
      mutate(csv_avail =
          stringr::str_detect(distribution, "csv"))

  } else {

    catalog <-
      jsonlite::flatten(parsed_dataset) %>%
      as_tibble() %>%
      select(publisher.name,
             product = title,
             description,
             modified,
             distribution,
             keyword)  %>%
      filter(publisher.name == agency)  %>%
      mutate(csv_avail =
               stringr::str_detect(distribution, "csv"))

  }

  if (is.null(keyword)){

    return(
      catalog %>%
             select(-keyword))

  } else {

    x <- keyword

    return(
      catalog %>%
             mutate(keyword = purrr::map(keyword,
                                         stringr::str_detect, x),
                    keyword = purrr::map_lgl(keyword, any)) %>%
             filter(keyword == TRUE) %>%
             select(-keyword))
  }

}



#' Function to fetch data from the healthdata.gov API
#' This function will pull data if available from healthdata.gov in csv format
#'
#' @param catalog this argument requires a catalog (tibble) created with fetch_catalog()
#' @return a nested tibble with descriptive metadata of a data product and a list-column
#'         of the available dataset.
#' @examples \dontrun{
#' cdc_alc <- fetch_catalog("Centers for Disease Control and Prevention",
#'                           keyword = "alcohol|alcohol use")
#'
#' nested_df_alc <- cdc_alc %>%
#'    slice(1:2) %>%  # pull Alzheimer's and Chronic Indicators datasets
#'    fetch_csv()
#' }
#' @export

fetch_csv <- function(catalog){

  catalog %>%
    tidyr::unnest(cols = c(distribution)) %>%
    mutate(is_csv = stringr::str_detect(downloadURL, "csv")) %>%
    filter(csv_avail == TRUE &
             is_csv == TRUE) %>%
    select(publisher.name, product, description,
           modified, downloadURL) %>%
    mutate(data_file =
             purrr::map(downloadURL, ~GET(.) %>%
                          content()
             ))
}

#' healdata.gov API call for data.json endpoint
#' @keywords internal

healthdata_api <- function(path = "data.json"){

  user <- user_agent("http://github.com/iecastro/healthdatacsv")

  data_url <- modify_url("http://www.healthdata.gov/api",
                         path = path)

  response <- GET(data_url, user)

  parsed <- jsonlite::fromJSON(content(response, "text"))

  if (http_error(response)) {
    stop(
      sprintf(
        "HealthData.gov API request failed [%s]\n%s\n<%s>",
        status_code(resp),
        parsed$message,
        parsed$documentation_url
      ),
      call. = FALSE
    )
  }

  return(parsed)

}





