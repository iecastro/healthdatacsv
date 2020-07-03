#' Access and download data from the healthdata.gov catalog
#'
#' @author Ivan Castro
#' @name healthdatacsv
#'
#' @importFrom dplyr as_tibble select mutate filter distinct
#' @importFrom httr user_agent modify_url http_error status_code
#' @importFrom httpcache GET startLog
#' @importFrom jsonlite fromJSON flatten
#' @importFrom stringr str_detect regex
#' @importFrom purrr map map_lgl
#' @importFrom tidyr unnest
#' @importFrom tibble tibble
#' @importFrom rlang .data
#' @importFrom utils View
#' @importFrom vroom vroom
NULL
