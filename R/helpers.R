#' Helper function  to extract names of agencies cataloged in healthdata.gov
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

  base_url <- "http://www.healthdata.gov/api"

  data_url <- modify_url(base_url, path = "data.json") %>% GET()

  parsed <- jsonlite::fromJSON(content(data_url, "text"))

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


#' Helper function to extract keywords listed in API
#'
#' @param agency enter full agency name in title case to pull keywords tagged in agency's products.
#'        Defaults to NULL and pulls all keywords cataloged
#' @return a tibble with publisher (agency) name(s) and respective keywords
#' @examples \dontrun{
#' get_keywords()
#' get_keywords("Centers for Disease Control and Prevention")
#' }
#' @export

get_keywords <- function(agency = NULL){

  base_url <- "http://www.healthdata.gov/api"

  data_url <- modify_url(base_url, path = "data.json") %>% GET()

  parsed <- jsonlite::fromJSON(content(data_url, "text"))

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

}


