#' Access and download data from the healthdata.gov catalog
#'
#' @author Ivan Castro
#' @name healthdatacsv
#'
#' @importFrom dplyr as_tibble select mutate filter
#' @importFrom httr user_agent modify_url GET http_error
#' @importFrom jsonlite fromJSON flatten
#' @importFrom stringr str_detect
#' @importFrom purrr map map_lgl
#' @importFrom tidyr unnest
#' @importFrom tibble tibble
NULL
