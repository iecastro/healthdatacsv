
<!-- README.md is generated from README.Rmd. Please edit that file -->

# healthdatacsv

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
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

# query API and dowload data
fetch_catalog("Centers for Disease Control and Prevention",
                               keyword = "built environment") %>% 
  fetch_csv()
#> # A tibble: 1 x 6
#>   publisher.name   product   description   modified downloadURL   data_file
#>   <chr>            <chr>     <chr>         <chr>    <chr>         <list>   
#> 1 Centers for Dis… CDC Nutr… "<p>This dat… 2018-09… https://data… <tibble …
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
in the same pipe. *If the catalog has more than one product that you’ll
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
accepts a full *agency* name (in proper title case) as argument; or it
can be run with the default value for a data frame of all keywords and
agencies cataloged.

``` r

get_keywords("National Institute on Drug Abuse (NIDA), National Institutes of Health (NIH)")
```

#### Info

Development of this package is partly supported by a research grant from
the National Institute on Alcohol Abuse and Alcoholism - NIH Grant
\#R34AA026745. This product is not endorsed nor certified by either
healthdata.gov or NIH/NIAAA.
