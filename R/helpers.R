#' Function to extract names of agencies cataloged in the healthdata.gov API
#'
#' @param namecheck enter partial name or initials of agency to search
#'        catalog for string pattern. Use title case.
#'        Defaults to NULL and pulls all agencies cataloged in API
#'
#' @return a [tibble][tibble::tibble-package] of names
#' @examples
#' \dontrun{
#' list_agencies()
#' list_agencies("Institute")
#' list_agencies("Substance Abuse")
#' }
#' @export

list_agencies <- function(namecheck = NULL) {
  api_call <- healthdata_api("data.json")

  parsed <- api_call$parsed

  parsed_dataset <- parsed$dataset

  if (is.null(namecheck)) {
    pubs <- jsonlite::flatten(parsed_dataset) %>%
      as_tibble() %>%
      select(.data$publisher.name) %>%
      distinct()
  } else {
    x <- namecheck

    pubs <- jsonlite::flatten(parsed_dataset) %>%
      as_tibble() %>%
      select(.data$publisher.name) %>%
      distinct() %>%
      mutate(
        partial_match =
          stringr::str_detect(.data$publisher.name, x)
      ) %>%
      filter(.data$partial_match == TRUE) %>%
      select(-.data$partial_match)
  }

  return(pubs)
}


#' Helper function to extract keywords listed in the healthdata.gov API
#'
#' @param agency enter full agency name in title case (results from
#'        list_agencies()) to pull keywords tagged in the listed
#'        agency's products. Defaults to NULL and pulls all keywords cataloged
#' @param data_viewer if TRUE, keywords are loaded to the data viewer
#' @return a [tibble][tibble::tibble-package] with publisher (agency)
#'         name(s) and respective keywords
#' @examples
#' \dontrun{
#' get_keywords()
#' get_keywords("Centers for Disease Control and Prevention")
#' }
#' @export

get_keywords <- function(agency = NULL,
                         data_viewer = FALSE) {
  api_call <- healthdata_api("data.json")

  parsed <- api_call$parsed

  parsed_dataset <- parsed$dataset

  if (is.null(agency)) {
    keywords <- jsonlite::flatten(parsed_dataset) %>%
      as_tibble() %>%
      select(
        .data$publisher.name,
        .data$keyword
      ) %>%
      tidyr::unnest(cols = c(.data$keyword)) %>%
      distinct()
  } else {
    keywords <- jsonlite::flatten(parsed_dataset) %>%
      as_tibble() %>%
      select(
        .data$publisher.name,
        .data$keyword
      ) %>%
      tidyr::unnest(cols = c(.data$keyword)) %>%
      distinct() %>%
      filter(.data$publisher.name == agency)
  }

  if(nrow(keywords) == 0){
    message(
      paste0("Your query did not return any results. ",
             "This is likely because",
             "`", agency, "`",
             "does not match the catalog.",
             "\nUse list_agencies() to find agency names in the catalog.")
    )
  }

  if(isTRUE(data_viewer)) {
    View(keywords)
    return(keywords)
  } else {
    return(keywords)
  }
}
