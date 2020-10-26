#' Extract names of agencies cataloged in the healthdata.gov API
#'
#' This function will download a list of Agencies listed as having
#' an available data product in the
#' [healthdata.gov](https://healthdata.gov/) data API endpoint.
#'
#' @param agency enter partial name or initials of agency to search
#'        catalog for string pattern.
#'        Defaults to `NULL` and pulls all agencies cataloged in API
#'
#' @return a [`tibble`][tibble::tibble()] of names
#' @examples
#' \dontrun{
#' get_agencies()
#'
#' get_agencies("institute")
#'
#' get_agencies("substance abuse")
#' }
#' @export

get_agencies <- function(agency = NULL) {

  api_call <- healthdata_api("data.json")

  parsed <- api_call$parsed

  parsed_dataset <- parsed$dataset

  x <- agency

  pubs <- jsonlite::flatten(parsed_dataset) %>%
    as_tibble() %>%
    select(publisher = .data$publisher.name) %>%
    distinct()

  if (!is.null(agency)){
    pubs <- pubs %>%
      mutate(partial_match =
               stringr::str_detect(.data$publisher,
                                   stringr::regex(x,
                                                  ignore_case = TRUE))
      ) %>%
      filter(.data$partial_match == TRUE) %>%
      select(-.data$partial_match)
  }

  pubs
}


#' Extract keywords listed in the healthdata.gov API
#'
#' This is a helper function that will download either all keywords
#' listed in the [healthdata.gov](https://healthdata.gov/) data API, or
#' pairings of agency and keywords listed.
#'
#' @param agency enter full agency name in title case (results from
#'        `get_agencies()`) to pull keywords tagged in the listed
#'        agency's products. Defaults to `NULL` and pulls all keywords cataloged
#' @return a [`tibble`][tibble::tibble()] with publisher (agency)
#'         name(s) and respective keywords
#' @examples
#' \dontrun{
#' get_keywords()
#'
#' get_keywords("Centers for Disease Control and Prevention")
#' }
#' @export

get_keywords <- function(agency = NULL) {

  api_call <- healthdata_api("data.json")

  parsed <- api_call$parsed

  parsed_dataset <- parsed$dataset

  keywords <- jsonlite::flatten(parsed_dataset) %>%
    as_tibble() %>%
    select(
      publisher = .data$publisher.name,
      .data$keyword
    ) %>%
    tidyr::unnest(cols = c(.data$keyword)) %>%
    distinct()

  if (!is.null(agency)) {

    keywords <- keywords %>%
      filter(.data$publisher == agency)
  }

  if(nrow(keywords) == 0){
    message(
      paste("Your query did not return any results.",
             "\nThis is likely because",
             "*",agency,"*",
             "does not match the catalog.",
             "\nUse get_agencies() to find agency names as listed in the catalog.")
    )
  }

  keywords
}

