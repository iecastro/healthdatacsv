
<!-- README.md is generated from README.Rmd. Please edit that file -->

# healthdatacsv

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Travis build
status](https://travis-ci.org/iecastro/healthdatacsv.svg?branch=master)](https://travis-ci.org/iecastro/healthdatacsv)
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

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(healthdatacsv)

# query API based on keywords
fetch_catalog(keyword = "alcohol|drugs")
#> # A tibble: 137 x 6
#>    publisher.name   product   description   modified distribution csv_avail
#>    <chr>            <chr>     <chr>         <chr>    <list>       <lgl>    
#>  1 Centers for Dis… Alzheime… "<p>2011-201… 2019-05… <df[,6] [4 … TRUE     
#>  2 U.S. Food and D… All FDA … "<p>Contains… 2010-10… <df[,6] [1 … FALSE    
#>  3 U.S. Food and D… Adverse … "<p>The Adve… 2004-01… <df[,6] [1 … FALSE    
#>  4 U.S. Food and D… Drugs to… "<p>Companie… 2013-09… <df[,6] [1 … FALSE    
#>  5 Centers for Dis… U.S. Chr… "<p>CDC's Di… 2018-07… <df[,6] [4 … TRUE     
#>  6 Centers for Dis… CDC PRAM… "<ol start=\… 2018-07… <df[,6] [4 … TRUE     
#>  7 Centers for Dis… CDC PRAM… "<ol start=\… 2018-07… <df[,6] [4 … TRUE     
#>  8 Centers for Dis… CDC PRAM… "<ol start=\… 2018-07… <df[,6] [4 … TRUE     
#>  9 Centers for Dis… CDC PRAM… "<ol start=\… 2018-07… <df[,6] [4 … TRUE     
#> 10 Centers for Dis… CDC PRAM… "<ol start=\… 2018-07… <df[,6] [4 … TRUE     
#> # … with 127 more rows

# query API and dowload data for single product
fetch_catalog("Centers for Disease Control and Prevention",
                               keyword = "built environment") %>% 
  fetch_csv()
#> # A tibble: 1 x 6
#>   publisher.name   product   description   modified downloadURL   data_file
#>   <chr>            <chr>     <chr>         <chr>    <chr>         <list>   
#> 1 Centers for Dis… CDC Nutr… "<p>This dat… 2018-09… https://data… <tibble …

# query API and dowload data for multiple data products
# data files will be nested in a list-column 
fetch_catalog(keyword = "alcohol") %>% 
  slice(1:2) %>% 
  fetch_csv()
#> # A tibble: 2 x 6
#>   publisher.name   product   description   modified downloadURL   data_file
#>   <chr>            <chr>     <chr>         <chr>    <chr>         <list>   
#> 1 Centers for Dis… Alzheime… "<p>2011-201… 2019-05… https://data… <tibble …
#> 2 Centers for Dis… U.S. Chr… "<p>CDC's Di… 2018-07… https://data… <tibble …
```

## Basic workflow

**healthdatacsv** is pipe friendly, so it’s easy to integrate into a
tidy workflow. For example, say you’re interested in searching CDC
datasets related to the built environment.

Let’s fetch the catalog of available data
products:

``` r
cdc_built_env <- fetch_catalog("Centers for Disease Control and Prevention",
                               keyword = "built environment")

cdc_built_env
#> # A tibble: 1 x 6
#>   publisher.name   product    description   modified distribution csv_avail
#>   <chr>            <chr>      <chr>         <chr>    <list>       <lgl>    
#> 1 Centers for Dis… CDC Nutri… "<p>This dat… 2018-09… <df[,6] [4 … TRUE
```

In this case, there is only one product available. To learn more, you
can simply `pull` the description:

``` r
cdc_built_env %>%
  pull(description)
#> [1] "<p>This dataset contains policy data for 50 US states and DC from 2001 to 2017. Data include information related to state legislation and regulations on nutrition, physical activity, and obesity in settings such as early care and education centers, restaurants, schools, work places, and others. To identify individual bills, use the identifier ProvisionID.  A bill or citation may appear more than once because it could apply to multiple health or policy topics, settings, or states. As of Q 2 2016, data include only enacted legislation.</p>\n"
```

This dataset relates to state legislation on nutrition, physical
activity, and obesity during 2001-2017. Data only includes enacted
legislation.

To download the data, we pass the catalog df to the `fetch_csv`
function. Since there is only one dataset to download, we can `unnest`
in the same pipe. *If the catalog has more than one product that you’ld
like to keep, it is recommended to unnest each product separately.* If
the catalog consists of several time points of the same dataset, you
could unnest in one pipe, given all column names are the same.

``` r
data_raw <- cdc_built_env %>%
  fetch_csv() %>% #> 
  tidyr::unnest(data_file)

data_raw %>%
  glimpse()
#> Observations: 33,182
#> Variables: 28
#> $ publisher.name <chr> "Centers for Disease Control and Prevention", "Ce…
#> $ product        <chr> "CDC Nutrition, Physical Activity, and Obesity - …
#> $ description    <chr> "<p>This dataset contains policy data for 50 US s…
#> $ modified       <chr> "2018-09-25", "2018-09-25", "2018-09-25", "2018-0…
#> $ downloadURL    <chr> "https://data.cdc.gov/api/views/nxst-x9p4/rows.cs…
#> $ Year           <dbl> 2015, 2015, 2011, 2009, 2009, 2007, 2010, 2010, 2…
#> $ Quarter        <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1…
#> $ LocationAbbr   <chr> "FL", "NY", "NY", "NY", "MN", "OK", "PA", "NJ", "…
#> $ LocationDesc   <chr> "Florida", "New York", "New York", "New York", "M…
#> $ HealthTopic    <chr> "Physical Activity", "Nutrition", "Obesity", "Obe…
#> $ PolicyTopic    <chr> "Pedestrians/Walking", "School Nutrition", "Appro…
#> $ DataSource     <chr> "DNPAO", "DNPAO", "DNPAO", "DNPAO", "DNPAO", "DNP…
#> $ Setting        <chr> "Community", "School/After School", "School/After…
#> $ Title          <chr> "Florida Shared-Use Nonmotorized Trail Network", …
#> $ Status         <chr> "Dead", "Introduced", "Dead", "Dead", "Dead", "En…
#> $ Citation       <chr> "SB1186", "AB544", "A5296", "A7804", "S1484", "H2…
#> $ StatusAltValue <dbl> 3, 0, 3, 3, 3, 1, 1, 3, 1, 3, 3, 3, 3, 3, 3, 1, 3…
#> $ DataType       <chr> "Text", "Text", "Text", "Text", "Text", "Text", "…
#> $ Comments       <chr> "(Abstract - \"Creates the Florida Shared-Use Non…
#> $ EnactedDate    <chr> NA, NA, NA, NA, NA, "01/01/2007 12:00:00 AM", "01…
#> $ EffectiveDate  <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ GeoLocation    <chr> "(28.932040377, -81.928960539)", "(42.827001032, …
#> $ DisplayOrder   <dbl> 69, 21, 28, 33, 68, 3, 14, 10, 69, 28, 28, 28, 32…
#> $ PolicyTypeID   <chr> "LEG", "LEG", "LEG", "LEG", "LEG", "LEG", "LEG", …
#> $ HealthTopicID  <chr> "003PA", "001NUT", "002OB", "002OB", "003PA", "00…
#> $ PolicyTopicID  <chr> "052PED", "043SNU", "002APP", "014ADW", "049BED",…
#> $ SettingID      <chr> "002COM", "004SAS", "004SAS", "004SAS", "002COM",…
#> $ ProvisionID    <dbl> 6860, 6929, 4330, 1133, 1778, 1956, 1066, 2992, 6…
```

### Some helper functions

`list_agencies()` will query and download names of agencies listed in
the catalog. You can enter partial name or initials of agency of
interest to check if it has data cataloged in the API. Argument relies
on [regular
expression](https://stringr.tidyverse.org/articles/regular-expressions.html)
to detect string matches.

``` r

list_agencies("NIH|CDC|FDA")
#> # A tibble: 4 x 1
#>   publisher.name                                                           
#>   <chr>                                                                    
#> 1 National Institutes of Health (NIH)                                      
#> 2 National Institutes of Health (NIH), Department of Health & Human Servic…
#> 3 National Institute on Drug Abuse (NIDA), National Institutes of Health (…
#> 4 National Cancer Institute (NCI), National Institutes of Health (NIH)

list_agencies("Institute|Drug")
#> # A tibble: 7 x 1
#>   publisher.name                                                           
#>   <chr>                                                                    
#> 1 U.S. Food and Drug Administration                                        
#> 2 National Institutes of Health (NIH)                                      
#> 3 National Institute of Environmental Health Sciences (NIEHS)              
#> 4 U.S. Food and Drug Administration, Department of Health & Human Services 
#> 5 National Institutes of Health (NIH), Department of Health & Human Servic…
#> 6 National Institute on Drug Abuse (NIDA), National Institutes of Health (…
#> 7 National Cancer Institute (NCI), National Institutes of Health (NIH)
```

The resulting dataframe will depend on matches to the string supplied.
To pull all agencies cataloged, simply use `list_agencies` with the
default argument:

``` r

list_agencies() %>% 
  print(n=Inf)
#> # A tibble: 31 x 1
#>    publisher.name                                                          
#>    <chr>                                                                   
#>  1 Centers for Disease Control and Prevention                              
#>  2 Centers for Medicare & Medicaid Services                                
#>  3 Office of the National Coordinator for Health Information Technology    
#>  4 U.S. Food and Drug Administration                                       
#>  5 Substance Abuse & Mental Health Services Administration                 
#>  6 Agency for Healthcare Research and Quality, Department of Health & Huma…
#>  7 Health Resources and Services Administration                            
#>  8 National Library of Medicine (NLM)                                      
#>  9 National Institutes of Health (NIH)                                     
#> 10 Department of Health & Human Services                                   
#> 11 National Institute of Environmental Health Sciences (NIEHS)             
#> 12 Office of the National Coordinator for Health Information Technology, D…
#> 13 Administration for Children and Families                                
#> 14 Centers for Medicare & Medicaid Services, Department of Health & Human …
#> 15 Centers for Disease Control and Prevention, Department of Health & Huma…
#> 16 Assistant Secretary for Planning & Evaluation, Department of Health & H…
#> 17 U.S. Food and Drug Administration, Department of Health & Human Services
#> 18 Office of Medicare Hearings and Appeals                                 
#> 19 Substance Abuse & Mental Health Services Administration, Department of …
#> 20 Administration for Children and Families, Department of Health & Human …
#> 21 National Institutes of Health (NIH), Department of Health & Human Servi…
#> 22 Indian Health Service                                                   
#> 23 National Institute on Drug Abuse (NIDA), National Institutes of Health …
#> 24 Office of Inspector General, Department of Health & Human Services      
#> 25 Office of Inspector General                                             
#> 26 Administration for Community Living                                     
#> 27 Health Resources and Services Administration, Department of Health & Hu…
#> 28 Administration for Community Living, Department of Health & Human Servi…
#> 29 National Cancer Institute (NCI), National Institutes of Health (NIH)    
#> 30 Department of Health & Human Services, Agency for Healthcare Research a…
#> 31 Departmental Appeals Board
```

`get_keywords()` will extract all keywords cataloged. The function
accepts as argument a full *agency* name (in proper title case) which
can be obtained with `list_agencies`.

``` r

get_keywords("National Institutes of Health (NIH)")
#> # A tibble: 78 x 2
#>    publisher.name                      keyword                          
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
#> # … with 68 more rows
```

Conversely, this function can be run with the default value for a data
frame of all keywords and agencies cataloged.

``` r

get_keywords()
#> # A tibble: 3,155 x 2
#>    publisher.name                        keyword                           
#>    <chr>                                 <chr>                             
#>  1 Centers for Disease Control and Prev… antibody                          
#>  2 Centers for Disease Control and Prev… chlamydia trachomatis             
#>  3 Centers for Disease Control and Prev… division of parasitic diseases an…
#>  4 Centers for Disease Control and Prev… latent class                      
#>  5 Centers for Medicare & Medicaid Serv… directory                         
#>  6 Centers for Medicare & Medicaid Serv… medical equipment                 
#>  7 Centers for Medicare & Medicaid Serv… supplier                          
#>  8 Centers for Medicare & Medicaid Serv… supplies                          
#>  9 Centers for Disease Control and Prev… leading causes of death           
#> 10 Centers for Disease Control and Prev… mortality                         
#> # … with 3,145 more rows
```

Additionally, keywords object can be loaded to the data viewer for
easier filtering, and text search by setting the `data_viewer` argument
to `TRUE`:

``` r

get_keywords("National Institutes of Health (NIH)",
             data_viewer = TRUE)
```

#### Info

Development of this package is partly supported by a research grant from
the National Institute on Alcohol Abuse and Alcoholism - NIH Grant
\#R34AA026745. This product is not endorsed nor certified by either
healthdata.gov or NIH/NIAAA.
