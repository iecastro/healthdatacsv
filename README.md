
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
#> # A tibble: 137 x 6
#>    publisher.name   product   description   modified distribution csv_avail
#>    <chr>            <chr>     <chr>         <chr>    <list>       <lgl>    
#>  1 Centers for Dis… U.S. Chr… "<p>CDC's Di… 2018-07… <df[,6] [4 … TRUE     
#>  2 Centers for Dis… Alzheime… "<p>2011-201… 2019-05… <df[,6] [4 … TRUE     
#>  3 Centers for Dis… CDC PRAM… "<ol start=\… 2018-07… <df[,6] [4 … TRUE     
#>  4 Centers for Dis… CDC PRAM… "<ol start=\… 2018-07… <df[,6] [4 … TRUE     
#>  5 Centers for Dis… CDC PRAM… "<ol start=\… 2018-07… <df[,6] [4 … TRUE     
#>  6 Centers for Dis… CDC PRAM… "<ol start=\… 2018-07… <df[,6] [4 … TRUE     
#>  7 Centers for Dis… CDC PRAM… "<ol start=\… 2018-07… <df[,6] [4 … TRUE     
#>  8 Centers for Dis… CDC PRAM… "<ol start=\… 2018-07… <df[,6] [4 … TRUE     
#>  9 Centers for Dis… CDC PRAM… "<ol start=\… 2018-07… <df[,6] [4 … TRUE     
#> 10 Centers for Dis… CDC PRAM… "<ol start=\… 2018-07… <df[,6] [4 … TRUE     
#> # … with 127 more rows
```

  - Querying API and downloading data for single product:

<!-- end list -->

``` r
fetch_catalog("Centers for Disease Control and Prevention",
                               keyword = "built environment") %>% 
  fetch_csv()
#> # A tibble: 1 x 6
#>   publisher.name   product    description   modified downloadURL   data_tbl
#>   <chr>            <chr>      <chr>         <chr>    <chr>         <list>  
#> 1 Centers for Dis… CDC Nutri… "<p>This dat… 2018-09… https://data… <tibble…
```

  - Querying API and downloading data for multiple data products. Data
    will be nested in a list-column:

<!-- end list -->

``` r
library(dplyr) # for table manipulation verbs

# query catalog
fetch_catalog(keyword = "alcohol")
#> # A tibble: 123 x 6
#>    publisher.name   product   description   modified distribution csv_avail
#>    <chr>            <chr>     <chr>         <chr>    <list>       <lgl>    
#>  1 Centers for Dis… U.S. Chr… "<p>CDC's Di… 2018-07… <df[,6] [4 … TRUE     
#>  2 Centers for Dis… Alzheime… "<p>2011-201… 2019-05… <df[,6] [4 … TRUE     
#>  3 Centers for Dis… CDC PRAM… "<ol start=\… 2018-07… <df[,6] [4 … TRUE     
#>  4 Centers for Dis… CDC PRAM… "<ol start=\… 2018-07… <df[,6] [4 … TRUE     
#>  5 Centers for Dis… CDC PRAM… "<ol start=\… 2018-07… <df[,6] [4 … TRUE     
#>  6 Centers for Dis… CDC PRAM… "<ol start=\… 2018-07… <df[,6] [4 … TRUE     
#>  7 Centers for Dis… CDC PRAM… "<ol start=\… 2018-07… <df[,6] [4 … TRUE     
#>  8 Centers for Dis… CDC PRAM… "<ol start=\… 2018-07… <df[,6] [4 … TRUE     
#>  9 Centers for Dis… CDC PRAM… "<ol start=\… 2018-07… <df[,6] [4 … TRUE     
#> 10 Centers for Dis… CDC PRAM… "<ol start=\… 2018-07… <df[,6] [4 … TRUE     
#> # … with 113 more rows

# fetch data
fetch_catalog(keyword = "alcohol") %>% 
  slice(1:2) %>% # dplyr 
  fetch_csv()
#> # A tibble: 2 x 6
#>   publisher.name   product   description    modified downloadURL   data_tbl
#>   <chr>            <chr>     <chr>          <chr>    <chr>         <list>  
#> 1 Centers for Dis… U.S. Chr… "<p>CDC's Div… 2018-07… https://data… <tibble…
#> 2 Centers for Dis… Alzheime… "<p>2011-2017… 2019-05… https://data… <tibble…
```

`fetch_csv()` wraps the [vroom](https://vroom.r-lib.org/) function,
which helps quickly read relatively large delimited files:

``` r
# PRAMS data
# CDC surveillance for reproductive health

# query catalog for available products
fetch_catalog(keyword = "reproductive health") %>% 
  select(1:2)
#> # A tibble: 14 x 2
#>    publisher.name                              product                     
#>    <chr>                                       <chr>                       
#>  1 Centers for Disease Control and Prevention  U.S. Chronic Disease Indica…
#>  2 Centers for Disease Control and Prevention  CDC PRAMStat Data for 2011  
#>  3 Centers for Disease Control and Prevention  CDC PRAMStat Data for 2000  
#>  4 Centers for Disease Control and Prevention  CDC PRAMStat Data for 2001  
#>  5 Centers for Disease Control and Prevention  CDC PRAMStat Data for 2002  
#>  6 Centers for Disease Control and Prevention  CDC PRAMStat Data for 2003  
#>  7 Centers for Disease Control and Prevention  CDC PRAMStat Data for 2004  
#>  8 Centers for Disease Control and Prevention  CDC PRAMStat Data for 2005  
#>  9 Centers for Disease Control and Prevention  CDC PRAMStat Data for 2006  
#> 10 Centers for Disease Control and Prevention  CDC PRAMStat Data for 2007  
#> 11 Centers for Disease Control and Prevention  CDC PRAMStat Data for 2008  
#> 12 Centers for Disease Control and Prevention  CDC PRAMStat Data for 2009  
#> 13 Centers for Disease Control and Prevention  CDC PRAMStat Data for 2010  
#> 14 Centers for Disease Control and Prevention… Assisted Reproductive Techn…

# query, filter, and fetch
prams <- fetch_catalog(keyword = "reproductive health") %>% 
  mutate(year = readr::parse_number(product)) %>% 
  filter(year > 2008) %>% 
  arrange(year) %>% 
  fetch_csv()

prams %>% 
  select(product, data_tbl)
#> # A tibble: 3 x 2
#>   product                    data_tbl               
#>   <chr>                      <list>                 
#> 1 CDC PRAMStat Data for 2009 <tibble [656,610 × 27]>
#> 2 CDC PRAMStat Data for 2010 <tibble [558,054 × 27]>
#> 3 CDC PRAMStat Data for 2011 <tibble [520,381 × 27]>
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

To download the data, we pass the catalog df to the `fetch_csv`
function. Since there is only one dataset to download, we can `unnest`
in the same pipe. *If the catalog has more than one product that you’d
like to keep, it is recommended to unnest each product separately.* If
the catalog consists of several time points of the same dataset, you
could unnest in one pipe, given all column names are the same.

``` r
data_raw <- cdc_built_env %>%
  fetch_csv() %>% #> 
  tidyr::unnest(data_tbl)

data_raw %>%
  glimpse()
#> Observations: 33,182
#> Variables: 28
#> $ publisher.name <chr> "Centers for Disease Control and Prevention", "Ce…
#> $ product        <chr> "CDC Nutrition, Physical Activity, and Obesity - …
#> $ description    <chr> "<p>This dataset contains policy data for 50 US s…
#> $ modified       <chr> "2018-09-25", "2018-09-25", "2018-09-25", "2018-0…
#> $ downloadURL    <chr> "https://data.cdc.gov/api/views/nxst-x9p4/rows.cs…
#> $ Year           <dbl> 2011, 2011, 2011, 2010, 2015, 2007, 2012, 2010, 2…
#> $ Quarter        <dbl> 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
#> $ LocationAbbr   <chr> "TN", "TN", "FL", "DC", "AL", "OK", "MI", "CO", "…
#> $ LocationDesc   <chr> "Tennessee", "Tennessee", "Florida", "District of…
#> $ HealthTopic    <chr> "Nutrition", "Obesity", "Obesity", "Nutrition", "…
#> $ PolicyTopic    <chr> "Media Campaigns", "Food Restrictions", "Incentiv…
#> $ DataSource     <chr> "DNPAO", "DNPAO", "DNPAO", "DNPAO", "DNPAO", "DNP…
#> $ Setting        <chr> "School/After School", "Restaurant/Retail", "Comm…
#> $ Title          <chr> "Tort Liability and Reform", "Public Funds and Fi…
#> $ Status         <chr> "Enacted", "Dead", "Dead", "Enacted", "Enacted", …
#> $ Citation       <chr> "H1151", "H1385", "H455", "R1136", "SB260", "H283…
#> $ StatusAltValue <dbl> 1, 3, 3, 1, 1, 1, 1, 1, 3, 3, 1, 1, 3, 3, 3, 1, 3…
#> $ DataType       <chr> "Text", "Text", "Text", "Text", "Text", "Text", "…
#> $ Comments       <chr> "(Abstract - Removes a statutory reference to cer…
#> $ EnactedDate    <chr> "01/01/2011 12:00:00 AM", NA, NA, "01/01/2010 12:…
#> $ EffectiveDate  <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ GeoLocation    <chr> "(35.68094058, -85.774490914)", "(35.68094058, -8…
#> $ DisplayOrder   <dbl> 19, 35, 38, 1, 26, 3, 26, 1, 21, 23, 1, 2, 2, 15,…
#> $ PolicyTypeID   <chr> "LEG", "LEG", "LEG", "LEG", "LEG", "LEG", "LEG", …
#> $ HealthTopicID  <chr> "001NUT", "002OB", "002OB", "001NUT", "001NUT", "…
#> $ PolicyTopicID  <chr> "031MDC", "020FOR", "029INC", "001AHF", "053INP",…
#> $ SettingID      <chr> "004SAS", "006RES", "002COM", "002COM", "002COM",…
#> $ ProvisionID    <dbl> 4565, 4567, 3683, 2502, 6898, 1956, 5624, 2461, 1…
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
#> # A tibble: 3,161 x 2
#>    publisher.name                        keyword                           
#>    <chr>                                 <chr>                             
#>  1 Centers for Disease Control and Prev… antibody                          
#>  2 Centers for Disease Control and Prev… chlamydia trachomatis             
#>  3 Centers for Disease Control and Prev… division of parasitic diseases an…
#>  4 Centers for Disease Control and Prev… latent class                      
#>  5 Centers for Disease Control and Prev… 2020                              
#>  6 Centers for Disease Control and Prev… botulism                          
#>  7 Centers for Disease Control and Prev… foodborne                         
#>  8 Centers for Disease Control and Prev… infant                            
#>  9 Centers for Disease Control and Prev… nedss                             
#> 10 Centers for Disease Control and Prev… netss                             
#> # … with 3,151 more rows
```

Additionally, keywords object can be loaded to the data viewer for
easier filtering, and text search by setting the `data_viewer` argument
to `TRUE`:

``` r
get_keywords("National Institutes of Health (NIH)",
             data_viewer = TRUE)
```

#### Info

Development of this package was partly supported by a research grant
from the National Institute on Alcohol Abuse and Alcoholism - NIH Grant
\#R34AA026745. This product is not endorsed nor certified by either
healthdata.gov or NIH/NIAAA.

Please note that the ‘healthdatacsv’ project is released with a
[Contributor Code of Conduct](.github/CODE_OF_CONDUCT.md). By
contributing to this project, you agree to abide by its terms.
