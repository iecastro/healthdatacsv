#' Helper function  to extract names of agencies cataloged in healthdata.gov
#'
#'

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


