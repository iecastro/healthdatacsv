
<!-- README.md is generated from README.Rmd. Please edit that file -->

# healthdatacsv <img src='man/figures/logo.png' align="right" height="139" />

<!-- badges: start -->

[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![Travis build
status](https://travis-ci.org/iecastro/healthdatacsv.svg?branch=master)](https://travis-ci.org/iecastro/healthdatacsv)
[![Codecov test
coverage](https://codecov.io/gh/iecastro/healthdatacsv/branch/master/graph/badge.svg)](https://codecov.io/gh/iecastro/healthdatacsv?branch=master)
[![peer-review](https://badges.ropensci.org/358_status.svg)](https://github.com/ropensci/software-review/issues/358)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/iecastro/healthdatacsv?branch=master&svg=true)](https://ci.appveyor.com/project/iecastro/healthdatacsv)
<!-- badges: end -->

**healthdatacsv** allows users to query the [healthdata.gov
API](https://healthdata.gov/node/25341) catalog and return tidy data
frames. This package focuses on the data.json endpoint and will download
datasets if available via file download, namely, in csv format.

## Installation

You can install the development version of **healthdatacsv** from
[GitHub](https://github.com/) with:

``` r
install.packages("remotes")
remotes::install_github("iecastro/healthdatacsv")
```

## Examples

``` r
library(healthdatacsv)
```

Basic examples which show you how to use **healthdatacsv**:

  - Querying API based on keywords:

<!-- end list -->

``` r
fetch_catalog(keyword = "alcohol|drugs")
#> 2020-07-15T17:18:37.405 HTTP GET http://www.healthdata.gov/data.json 200 477047 0.598 0.216 0.316 0.437 0.695 0.921
#> 2020-07-15T17:18:37.406 CACHE SET http://www.healthdata.gov/data.json
#> # A tibble: 134 x 6
#>    publisher     product     description         modified distribution csv_avail
#>    <chr>         <chr>       <chr>               <chr>    <list>       <lgl>    
#>  1 Centers for ~ Alzheimer'~ "<p>2011-2017. Thi~ 2020-02~ <df[,5] [4 ~ TRUE     
#>  2 Centers for ~ U.S. Chron~ "<p>CDC's Division~ 2020-01~ <df[,5] [4 ~ TRUE     
#>  3 Centers for ~ CDC PRAMSt~ "<ol start=\"2011\~ 2018-07~ <df[,5] [4 ~ TRUE     
#>  4 Centers for ~ CDC PRAMSt~ "<ol start=\"2000\~ 2018-07~ <df[,5] [4 ~ TRUE     
#>  5 Centers for ~ CDC PRAMSt~ "<ol start=\"2001\~ 2018-07~ <df[,5] [4 ~ TRUE     
#>  6 Centers for ~ CDC PRAMSt~ "<ol start=\"2002\~ 2018-07~ <df[,5] [4 ~ TRUE     
#>  7 Centers for ~ CDC PRAMSt~ "<ol start=\"2003\~ 2018-07~ <df[,5] [4 ~ TRUE     
#>  8 Centers for ~ CDC PRAMSt~ "<ol start=\"2004\~ 2018-07~ <df[,5] [4 ~ TRUE     
#>  9 Centers for ~ CDC PRAMSt~ "<ol start=\"2005\~ 2018-07~ <df[,5] [4 ~ TRUE     
#> 10 Centers for ~ CDC PRAMSt~ "<ol start=\"2006\~ 2018-07~ <df[,5] [4 ~ TRUE     
#> # ... with 124 more rows
```

  - Querying API and downloading data for single product:

<!-- end list -->

``` r
fetch_catalog("Centers for Disease Control and Prevention",
                               keyword = "built environment") %>% 
  fetch_data()
#> 2020-07-15T17:18:38.617 CACHE HIT http://www.healthdata.gov/data.json
#> # A tibble: 1 x 6
#>   publisher    product      description       modified downloadURL     data_tbl 
#>   <chr>        <chr>        <chr>             <chr>    <chr>           <list>   
#> 1 Centers for~ CDC Nutriti~ "<p>This dataset~ 2018-09~ https://data.c~ <tibble ~
```

  - Querying API and downloading data for multiple data products. Data
    will be nested in a list-column:

<!-- end list -->

``` r
library(dplyr) # for table manipulation verbs

# query catalog
fetch_catalog(keyword = "alcohol")
#> 2020-07-15T17:18:43.751 CACHE HIT http://www.healthdata.gov/data.json
#> # A tibble: 123 x 6
#>    publisher     product     description         modified distribution csv_avail
#>    <chr>         <chr>       <chr>               <chr>    <list>       <lgl>    
#>  1 Centers for ~ Alzheimer'~ "<p>2011-2017. Thi~ 2020-02~ <df[,5] [4 ~ TRUE     
#>  2 Centers for ~ U.S. Chron~ "<p>CDC's Division~ 2020-01~ <df[,5] [4 ~ TRUE     
#>  3 Centers for ~ CDC PRAMSt~ "<ol start=\"2011\~ 2018-07~ <df[,5] [4 ~ TRUE     
#>  4 Centers for ~ CDC PRAMSt~ "<ol start=\"2000\~ 2018-07~ <df[,5] [4 ~ TRUE     
#>  5 Centers for ~ CDC PRAMSt~ "<ol start=\"2001\~ 2018-07~ <df[,5] [4 ~ TRUE     
#>  6 Centers for ~ CDC PRAMSt~ "<ol start=\"2002\~ 2018-07~ <df[,5] [4 ~ TRUE     
#>  7 Centers for ~ CDC PRAMSt~ "<ol start=\"2003\~ 2018-07~ <df[,5] [4 ~ TRUE     
#>  8 Centers for ~ CDC PRAMSt~ "<ol start=\"2004\~ 2018-07~ <df[,5] [4 ~ TRUE     
#>  9 Centers for ~ CDC PRAMSt~ "<ol start=\"2005\~ 2018-07~ <df[,5] [4 ~ TRUE     
#> 10 Centers for ~ CDC PRAMSt~ "<ol start=\"2006\~ 2018-07~ <df[,5] [4 ~ TRUE     
#> # ... with 113 more rows

# fetch data
fetch_catalog(keyword = "alcohol") %>% 
  dplyr::slice(1) %>% # dplyr 
  fetch_data()
#> 2020-07-15T17:18:44.830 CACHE HIT http://www.healthdata.gov/data.json
#> # A tibble: 1 x 6
#>   publisher     product     description      modified downloadURL      data_tbl 
#>   <chr>         <chr>       <chr>            <chr>    <chr>            <list>   
#> 1 Centers for ~ Alzheimer'~ "<p>2011-2017. ~ 2020-02~ https://data.cd~ <tibble ~
```

`fetch_data()` wraps the [vroom](https://vroom.r-lib.org/) function,
which helps quickly read relatively large delimited files:

``` r
# PRAMS data
# CDC surveillance for reproductive health
# query, filter, and fetch
prams <- fetch_catalog(keyword = "reproductive health") %>% 
  mutate(year = readr::parse_number(product)) %>% 
  filter(year >= 2010) %>% 
  arrange(year) %>% 
  fetch_data()
#> 2020-07-15T17:18:52.449 CACHE HIT http://www.healthdata.gov/data.json

prams %>% 
  select(product, data_tbl)
#> # A tibble: 2 x 2
#>   product                    data_tbl               
#>   <chr>                      <list>                 
#> 1 CDC PRAMStat Data for 2010 <tibble [558,054 x 27]>
#> 2 CDC PRAMStat Data for 2011 <tibble [520,381 x 27]>
```

## Basic workflow

Say you’re interested in searching for CDC datasets related to the built
environment. You can use **healthdatacsv** to fetch the catalog of
available data products:

``` r
cdc_built_env <- fetch_catalog("Centers for Disease Control and Prevention",
                               keyword = "built environment")
#> 2020-07-15T17:19:32.480 CACHE HIT http://www.healthdata.gov/data.json

cdc_built_env
#> # A tibble: 1 x 6
#>   publisher     product       description        modified distribution csv_avail
#>   <chr>         <chr>         <chr>              <chr>    <list>       <lgl>    
#> 1 Centers for ~ CDC Nutritio~ "<p>This dataset ~ 2018-09~ <df[,5] [4 ~ TRUE
```

In this case, there is only one product available. To learn more about
the dataset, you can simply `pull` the description:

``` r
cdc_built_env %>%
  dplyr::pull(description)
#> [1] "<p>This dataset contains policy data for 50 US states and DC from 2001 to 2017. Data include information related to state legislation and regulations on nutrition, physical activity, and obesity in settings such as early care and education centers, restaurants, schools, work places, and others. To identify individual bills, use the identifier ProvisionID.  A bill or citation may appear more than once because it could apply to multiple health or policy topics, settings, or states. As of Q 2 2016, data include only enacted legislation.</p>\n"
```

This dataset relates to state legislation on nutrition, physical
activity, and obesity during 2001-2017. Data only includes enacted
legislation.

To download the data, we pass the catalog object to the `fetch_data`
function. Since there is only one dataset to download, we can `unnest`
in the same pipe. *If the catalog has more than one product that you’d
like to keep, it is recommended to unnest each product separately.* If
the catalog consists of several time points of the same dataset, you
could unnest in one pipe, given all column names are the same.

``` r
data_raw <- cdc_built_env %>%
  fetch_data() %>% #> 
  tidyr::unnest(data_tbl)

data_raw
#> # A tibble: 33,182 x 28
#>    publisher product description modified downloadURL  Year Quarter LocationAbbr
#>    <chr>     <chr>   <chr>       <chr>    <chr>       <dbl>   <dbl> <chr>       
#>  1 Centers ~ CDC Nu~ "<p>This d~ 2018-09~ https://da~  2011       1 TN          
#>  2 Centers ~ CDC Nu~ "<p>This d~ 2018-09~ https://da~  2011       1 TN          
#>  3 Centers ~ CDC Nu~ "<p>This d~ 2018-09~ https://da~  2011       1 FL          
#>  4 Centers ~ CDC Nu~ "<p>This d~ 2018-09~ https://da~  2010       1 DC          
#>  5 Centers ~ CDC Nu~ "<p>This d~ 2018-09~ https://da~  2015       2 AL          
#>  6 Centers ~ CDC Nu~ "<p>This d~ 2018-09~ https://da~  2007       1 OK          
#>  7 Centers ~ CDC Nu~ "<p>This d~ 2018-09~ https://da~  2012       1 MI          
#>  8 Centers ~ CDC Nu~ "<p>This d~ 2018-09~ https://da~  2010       1 CO          
#>  9 Centers ~ CDC Nu~ "<p>This d~ 2018-09~ https://da~  2010       1 MN          
#> 10 Centers ~ CDC Nu~ "<p>This d~ 2018-09~ https://da~  2011       1 DC          
#> # ... with 33,172 more rows, and 20 more variables: LocationDesc <chr>,
#> #   HealthTopic <chr>, PolicyTopic <chr>, DataSource <chr>, Setting <chr>,
#> #   Title <chr>, Status <chr>, Citation <chr>, StatusAltValue <dbl>,
#> #   DataType <chr>, Comments <chr>, EnactedDate <chr>, EffectiveDate <chr>,
#> #   GeoLocation <chr>, DisplayOrder <dbl>, PolicyTypeID <chr>,
#> #   HealthTopicID <chr>, PolicyTopicID <chr>, SettingID <chr>,
#> #   ProvisionID <dbl>
```

### Some helper functions

`get_agencies()` will query and download names of agencies listed in the
catalog. You can enter partial name or initials of agency of interest to
check if it has data cataloged in the API. Argument relies on [regular
expression](https://stringr.tidyverse.org/articles/regular-expressions.html)
to detect string matches.

``` r

get_agencies("NIH|CDC|FDA")
#> 2020-07-15T17:19:38.014 CACHE HIT http://www.healthdata.gov/data.json
#> # A tibble: 4 x 1
#>   publisher                                                                   
#>   <chr>                                                                       
#> 1 National Institutes of Health (NIH)                                         
#> 2 National Institutes of Health (NIH), Department of Health & Human Services  
#> 3 National Institute on Drug Abuse (NIDA), National Institutes of Health (NIH)
#> 4 National Cancer Institute (NCI), National Institutes of Health (NIH)

get_agencies("Institute|Drug")
#> 2020-07-15T17:19:39.088 CACHE HIT http://www.healthdata.gov/data.json
#> # A tibble: 7 x 1
#>   publisher                                                                   
#>   <chr>                                                                       
#> 1 U.S. Food and Drug Administration                                           
#> 2 National Institutes of Health (NIH)                                         
#> 3 National Institute of Environmental Health Sciences (NIEHS)                 
#> 4 U.S. Food and Drug Administration, Department of Health & Human Services    
#> 5 National Institutes of Health (NIH), Department of Health & Human Services  
#> 6 National Institute on Drug Abuse (NIDA), National Institutes of Health (NIH)
#> 7 National Cancer Institute (NCI), National Institutes of Health (NIH)
```

The resulting dataframe will depend on matches to the string supplied.
To pull all agencies cataloged, simply use `get_agencies` with the
default argument:

``` r
get_agencies()
#> 2020-07-15T17:19:40.025 CACHE HIT http://www.healthdata.gov/data.json
#> # A tibble: 32 x 1
#>    publisher                                                                    
#>    <chr>                                                                        
#>  1 Centers for Medicare & Medicaid Services                                     
#>  2 Centers for Disease Control and Prevention                                   
#>  3 Office of the National Coordinator for Health Information Technology         
#>  4 Centers for Medicare & Medicaid Services (CMS)                               
#>  5 U.S. Food and Drug Administration                                            
#>  6 Substance Abuse & Mental Health Services Administration                      
#>  7 Agency for Healthcare Research and Quality, Department of Health & Human Ser~
#>  8 Health Resources and Services Administration                                 
#>  9 National Library of Medicine (NLM)                                           
#> 10 National Institutes of Health (NIH)                                          
#> # ... with 22 more rows
```

`get_keywords()` will extract all keywords cataloged. The function
accepts as argument a full *agency* name (in proper title case) which
can be obtained with `get_agencies`.

``` r
get_keywords("National Institutes of Health (NIH)")
#> 2020-07-15T17:19:40.969 CACHE HIT http://www.healthdata.gov/data.json
#> # A tibble: 78 x 2
#>    publisher                           keyword                          
#>    <chr>                               <chr>                            
#>  1 National Institutes of Health (NIH) national-institutes-of-health-nih
#>  2 National Institutes of Health (NIH) parkinsons                       
#>  3 National Institutes of Health (NIH) tbi                              
#>  4 National Institutes of Health (NIH) mental health                    
#>  5 National Institutes of Health (NIH) mental illness                   
#>  6 National Institutes of Health (NIH) severe mental illness            
#>  7 National Institutes of Health (NIH) smi                              
#>  8 National Institutes of Health (NIH) brain                            
#>  9 National Institutes of Health (NIH) brain development                
#> 10 National Institutes of Health (NIH) diffusion tensor imaging         
#> # ... with 68 more rows
```

Conversely, this function can be run with no argument for a data frame
of all keywords and agencies cataloged.

#### Info

Development of this package partly supported by a research grant from
the National Institute on Alcohol Abuse and Alcoholism - NIH Grant
\#R34AA026745. This product is not endorsed nor certified by either
healthdata.gov or NIH/NIAAA.

Please note that the ‘healthdatacsv’ project is released with a
[Contributor Code of Conduct](.github/CODE_OF_CONDUCT.md). By
contributing to this project, you agree to abide by its terms.
