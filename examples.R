# fetch_catalog

# examples

fetch_catalog()

fetch_catalog(keyword = "alcohol|drugs")

fetch_catalog("Centers for Disease Control and Prevention")

fetch_catalog("Centers for Disease Control and Prevention",
              keyword = "cancer")

# fetch csv

# will pull if data available in csv format
# will crash (in cloud) with large files
# i.e. CDC PRAMS have ~500k rows


#---- test

nih_catalog <- fetch_catalog("National Institutes of Health (NIH)")

nih_catalog


alc_catalog <- fetch_catalog(keyword = "alcohol")

alc_catalog


(data <- alc_catalog %>% slice(1:2))

x <- fetch_csv(data)

x %>%
  slice(1) %>%
  tidyr::unnest(data_file)

(data_single <- alc_catalog %>% slice(2))

x2 <- data_single %>%
  fetch_csv()

x2 %>%
  tidyr::unnest(data_file)


#--- example workflow------------------------------------
cdc_catalog <- fetch_catalog("Centers for Disease Control and Prevention")


get_keywords("Centers for Disease Control and Prevention")

cdc_alc <- fetch_catalog("Centers for Disease Control and Prevention",
                         keyword = "alcohol|alcohol use")

cdc_alc

cdc_alc %>%
  slice(1:2) %>%
  pull(description)


nested_df_alc <- cdc_alc %>%
  slice(1:2) %>%
  fetch_csv()


alz <- nested_df_alc %>%
  slice(1) %>%
  tidyr::unnest(data_file)

alz

#---- hopefully smaller df
cdc_built_env <- fetch_catalog("Centers for Disease Control and Prevention",
                               keyword = "built environment")

cdc_built_env

cdc_built_env %>%
  pull(description)

# fetch data related to state legislation on
# nutrition, phys. activity, and obesity
# time point 2001-2017
data_raw <- cdc_built_env %>%
  fetch_csv() %>%
  tidyr::unnest(data_file)

data_raw %>%
  glimpse()

