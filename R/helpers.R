#' Helper function  to extract names of agencies cataloged in the healthdata.gov API
#'
#' @param namecheck enter partial name or initials of agency to search catalog for
#'        string pattern. Use title case.
#'        Defaults to NULL and pulls all agencies cataloged in API
#'
#' @return a one-column tibble of names
#' @examples \dontrun{
#' list_agencies()
#' list_agencies("Institute")
#' list_agencies("Substance Abuse")
#' }
#' @export

list_agencies <- function(namecheck = NULL){

  parsed <- healthdata_api()

  parsed_dataset <- parsed$dataset

  if (is.null(namecheck)){

    pubs <- jsonlite::flatten(parsed_dataset) %>%
      as_tibble() %>%
      select(publisher.name)%>%
      distinct()

  } else {

    x <- namecheck

    pubs <- jsonlite::flatten(parsed_dataset) %>%
      as_tibble() %>%
      select(publisher.name)%>%
      distinct() %>%
      mutate(partial_match =
               stringr::str_detect(publisher.name, x)) %>%
      filter(partial_match == TRUE) %>%
      select(-partial_match)

  }

  return(pubs)
}


#' Helper function to extract keywords listed in the healthdata.gov API
#'
#' @param agency enter full agency name in title case (results from list_agencies()) to pull keywords
#'        tagged in the listed agency's products.
#'        Defaults to NULL and pulls all keywords cataloged
#' @return a tibble with publisher (agency) name(s) and respective keywords
#' @examples \dontrun{
#' get_keywords()
#' get_keywords("Centers for Disease Control and Prevention")
#' }
#' @export

get_keywords <- function(agency = NULL){

  parsed <- healthdata_api()

  parsed_dataset <- parsed$dataset

  if (is.null(agency)){

    keywords <- jsonlite::flatten(parsed_dataset) %>%
      as_tibble() %>%
      select(publisher.name,
             keyword)  %>%
      tidyr::unnest(cols = c(keyword)) %>%
      distinct()

  } else {

    keywords <- jsonlite::flatten(parsed_dataset) %>%
      as_tibble() %>%
      select(publisher.name,
             keyword)  %>%
      tidyr::unnest(cols = c(keyword)) %>%
      distinct() %>%
      filter(publisher.name == agency)

  }

  View(keywords)

  return(keywords)

}


