fetch_catalog <- function(agency = NULL,
                          keyword = NULL){

  base_url <- "http://www.healthdata.gov/api"

  data_url <- modify_url(base_url, path = "data.json") %>% GET()

  parsed <- jsonlite::fromJSON(content(data_url, "text"))

  parsed_dataset <- parsed$dataset

  if (is.null(agency)) {

    catalog <- jsonlite::flatten(parsed_dataset) %>%
      as_tibble() %>%
      select(publisher.name,
             product = title,
             description,
             modified,
             distribution,
             keyword) %>%
      mutate(csv_avail =
               suppressMessages(stringr::str_detect(distribution, "csv")))

  } else {

    catalog <- jsonlite::flatten(parsed_dataset) %>%
      as_tibble() %>%
      select(publisher.name,
             product = title,
             description,
             modified,
             distribution,
             keyword)  %>%
      filter(publisher.name == agency)  %>%
      mutate(csv_avail =
               suppressMessages(stringr::str_detect(distribution, "csv")))

  }

  if (is.null(keyword)){

    return(catalog %>%
             select(-keyword))

  } else {

    x <- keyword

    return(catalog %>%
             mutate(keyword = purrr::map(keyword,
                                         suppressMessages(stringr::str_detect), x),
                    keyword = purrr::map_lgl(keyword, any)) %>%
             filter(keyword == TRUE) %>%
             select(-keyword))
  }

}



fetch_csv <- function(data){

  data %>%
    tidyr::unnest(cols = c(distribution)) %>%
    mutate(is_csv = stringr::str_detect(downloadURL, "csv")) %>%
    filter(csv_avail == TRUE &
             is_csv == TRUE) %>%
    select(- `@type`, -mediaType, -title, -accessURL,
           -format, -csv_avail, -is_csv) %>%
    mutate(data_file =
             purrr::map(downloadURL, ~GET(.) %>%
                          content()
             ))
}


