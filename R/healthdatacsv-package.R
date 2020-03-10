#' Access and download data from the healthdata.gov catalog
#'
#' @author Ivan Castro
#' @name healthdatacsv
#'
#' @importFrom dplyr as_tibble select mutate filter distinct
#' @importFrom httr user_agent modify_url GET http_error status_code
#' @importFrom jsonlite fromJSON flatten
#' @importFrom stringr str_detect regex
#' @importFrom purrr map map_lgl
#' @importFrom tidyr unnest
#' @importFrom tibble tibble
#' @importFrom rlang .data
#' @importFrom utils View
#' @importFrom vroom vroom
NULL
