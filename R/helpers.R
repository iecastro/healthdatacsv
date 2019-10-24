list_agencies <- function(){

  base_url <- "http://www.healthdata.gov/api"

  data_url <- modify_url(base_url, path = "data.json") %>% GET()

  parsed <- jsonlite::fromJSON(content(data_url, "text"))

  parsed_dataset <- parsed$dataset

  pubs <- jsonlite::flatten(parsed_dataset) %>%
    as_tibble() %>%
    select(publisher.name)%>%
    distinct()

  print(pubs)
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


