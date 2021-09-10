# Load R Packages ---------------------------------------------------------

library(tidyverse)     # Core Set of R Data Science Tools (dplyr, ggplot2, tidyr, readr, etc.)
library(ggthemes)     # Core Set of R Data Science Tools (dplyr, ggplot2, tidyr, readr, etc.)

# Import Texas County Data ------------------------------------------------

tx_cnty_data <- read_rds("clean_data/texas_cnty_data.rds") 

# Review Data Available ---------------------------------------------------

glimpse(tx_cnty_data) ## Preview The Data

# 1. Draw A Bar Chart -----------------------------------------------------

## Subset the Top 10 Counties for Vaccine Uptake

top_10_vax <- tx_cnty_data |> 
  arrange(desc(pct_vaccinated_eligible)) |> 
  slice(1:10)

## Draw Bar Chart of Top 10 Counties

top_10_vax |> 
  ggplot() + 
  aes(x=reorder(county, pct_vaccinated_eligible), y = pct_vaccinated_eligible, fill = pct_vaccinated_eligible) +
  geom_col() +
  scale_y_continuous(labels = scales::percent) +
  theme_minimal() +
  theme(legend.position  = "none",
        plot.title = element_text(face = "bold")) +
  labs(title = "Top 10 Counties for Vacine Uptake",
       subtitle = "As of September 9th, 2021",
       caption = "Data: Texas Department of State Health Services",
       x = "Counties",
       y = "% Fully Vaccinated (Population 12+)")

ggsave("figures/1_top_10_counties_vaccine_uptake.png", device = "png", dpi = 300, width = 6, height = 4, bg = "white")
