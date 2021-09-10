# Load R Packages ---------------------------------------------------------

library(tidyverse)     # Core Set of R Data Science Tools (dplyr, ggplot2, tidyr, readr, etc.)
library(ggthemes)     # Core Set of R Data Science Tools (dplyr, ggplot2, tidyr, readr, etc.)

# Import Texas County Data ------------------------------------------------

tx_cnty_data <- read_rds("clean_data/texas_cnty_data.rds") 

# Review Data Available ---------------------------------------------------

glimpse(tx_cnty_data) ## Preview The Data

# 1. Map of Vaccine Uptake 12+ --------------------------------------------

tx_cnty_data |> 
  ggplot() + 
  aes(fill = pct_vaccinated_eligible, color = pct_vaccinated_eligible) +
  geom_sf(size = 0.15) +
  scale_color_gradient_tableau(palette = "Blue", labels = scales::percent) +
  scale_fill_gradient_tableau(palette = "Blue", labels = scales::percent) +
  theme_void() +
  theme(legend.position  = "right",
        plot.title = element_text(face = "bold")) +
  labs(title = "Vacine Uptake Among Eligible Residents",
       subtitle = "As of September 9th, 2021",
       caption = "Data: Texas Department of State Health Services",
       x = "Counties",
       y = "% Fully Vaccinated (Population 12+)",
       fill = "% Fully Vaccinated (12+)",
       color = "% Fully Vaccinated (12+)")

ggsave("figures/2_map_of_vaccine_uptake_12plus.png", device = "png", dpi = 300, width = 6, height = 4, bg = "white")

# 2. Map of Vaccine Uptake All --------------------------------------------

tx_cnty_data |> 
  ggplot() + 
  aes(fill = pct_vaccinated_all, color = pct_vaccinated_all) +
  geom_sf(size = 0.15) +
  scale_color_gradient_tableau(palette = "Blue", labels = scales::percent) +
  scale_fill_gradient_tableau(palette = "Blue", labels = scales::percent) +
  theme_void() +
  theme(legend.position  = "right",
        plot.title = element_text(face = "bold")) +
  labs(title = "Vacine Uptake Among All Residents",
       subtitle = "As of September 9th, 2021",
       caption = "Data: Texas Department of State Health Services",
       x = "Counties",
       y = "% Fully Vaccinated (All)",
       fill = "% Fully Vaccinated (All)",
       color = "% Fully Vaccinated (All)")

ggsave("figures/2_map_of_vaccine_uptake_all.png", device = "png", dpi = 300, width = 6, height = 4, bg = "white")
