
# Load R Packages ---------------------------------------------------------

library(janitor)       # Package with useful + convenient data cleaning functions
library(readxl)        # Package with useful functions for working with Excel Files
library(tidyverse)     # Core Set of R Data Science Tools (dplyr, ggplot2, tidyr, readr, etc.)
library(tidycensus)    # Package for getting statistical and spatial data from the US Census

# Import Vaccine Data -----------------------------------------------------

# vax_url <- "https://dshs.texas.gov/immunize/covid19/COVID-19-Vaccine-Data-by-County.xls" 
# download.file(url=vax_url, destfile = "raw_data/tx_vaccine_uptake.xlsx")

vax_data <- read_excel("raw_data/tx_vaccine_uptake.xlsx", sheet = "By County") |> 
  clean_names() |> 
  filter(county_name!="Texas",
         county_name!="Federal Long-Term Care Vaccination Program",
         county_name!="Federal Pharmacy Retail Vaccination Program",
         county_name!="Other") |> 
  rename(county=county_name)

# Add DSHS Case Fatality Data ---------------------------------------------

case_fatality_data <- read_excel("raw_data/CaseCountData.xlsx", sheet = "Case and Fatalities", skip = 1) |> 
  clean_names() |> 
  filter(county!="Unknown",
         county!="Grand Total")

# Add Election Results for 2020 -------------------------------------------

election_data <- read_csv("raw_data/countypres_2000-2020.csv") |> 
  clean_names() |> 
  filter(year==2020,
         state=="TEXAS") |> 
  group_by(county_name) |> 
  slice_max(candidatevotes) |> 
  mutate(county_name=str_to_title(county_name),
         candidate=str_to_title(candidate),
         vote_share_2020 = round(candidatevotes/totalvotes, digits = 3)) |> 
  select(county=county_name, prez_candidate_2020=candidate, vote_share_2020)

# Pull Census Variables ---------------------------------------------------

# census_vars <- tidycensus::load_variables(2019, "acs5/profile")

census_var_ls <- c(tot_pop = "B01003_001",
                   med_inc = "B19013_001",
                   broadband = "DP02_0152P",
                   labor_part_16 = "DP03_0002P",
                   unemployment = "DP03_0009P",
                   w_health_insurance = "DP03_0096P")

census_table <- get_acs(state = "TX", 
                        geography = "county", 
                        output = "wide",
                        variables = census_var_ls, 
                        geometry = TRUE) |> 
  select(-ends_with("M"), -GEOID) |> 
  clean_names() |> 
  rename(county=name) %>%  
  rename_with(~str_replace_all(., "_e|e$", "")) |> 
  mutate(county = str_replace_all(county, " County, Texas", ""))


# Combine All The Data Into One Table -------------------------------------
  
tx_cnty_data <- vax_data |> 
  left_join(case_fatality_data, by = "county") |> 
  left_join(election_data, by = "county") |>
  left_join(census_table, by = "county") |> 
  mutate(people_fully_vaccinated = as.numeric(people_fully_vaccinated),
         population_12 = as.numeric(population_12),
         population_65 = as.numeric(population_65),
         pct_vaccinated_eligible = people_fully_vaccinated/population_12,
         pct_vaccinated_all = people_fully_vaccinated/tot_pop,
         share_above_65 = population_65/tot_pop) |> 
  sf::st_as_sf()

write_rds(tx_cnty_data, "clean_data/texas_cnty_data.rds")
