# Load R Packages ---------------------------------------------------------

library(tidyverse)     # Core Set of R Data Science Tools (dplyr, ggplot2, tidyr, readr, etc.)
library(ggthemes)     # Core Set of R Data Science Tools (dplyr, ggplot2, tidyr, readr, etc.)

# Import Texas County Data ------------------------------------------------

tx_cnty_data <- read_rds("clean_data/texas_cnty_data.rds") 

# Review Data Available ---------------------------------------------------

glimpse(tx_cnty_data) ## Preview The Data

# Pivot the Data Longways -------------------------------------------------

long_data <- tx_cnty_data |> 
  as_tibble() |> 
  mutate(cases_per1k = (confirmed_cases/tot_pop)*1000,
         deaths_per1k = (fatalities/tot_pop)*1000) |> 
  pivot_longer(cols = c("cases_per1k","deaths_per1k","broadband",
                        "labor_part_16","unemployment","w_health_insurance","share_above_65"),
               names_to = "comparison_features",
               values_to = "values") |> 
  select(county, pct_vaccinated_eligible, comparison_features, values)

# 1. Comparing Vaccine Uptake to Deaths Per 1k -----------------------------

long_data |> 
  filter(comparison_features=="deaths_per1k") |> 
  ggplot() + 
  aes(y = pct_vaccinated_eligible, x = values, alpha = values) +
  geom_point() +
  geom_smooth(method="lm") +
  # facet_wrap(~comparison_features) +
  scale_y_continuous(labels = scales::percent) +
  scale_color_gradient_tableau(palette = "Blue", labels = scales::percent) +
  theme_minimal() +
  theme(legend.position  = "none",
        plot.title = element_text(face = "bold")) +
  labs(title = "What May Be Driving Uptake?",
       subtitle = "As of September 9th, 2021",
       caption = "Data: Texas Department of State Health Services and US Census",
       x = "Deaths For Every 1,000 Persons",
       y = "% Fully Vaccinated (Population 12+)")

ggsave("figures/3_uptake_vs_deaths_per1k.png", device = "png", dpi = 300, width = 6, height = 4, bg = "white")

# 2. Comparing Vaccine Uptake to Cases Per 1k -----------------------------

long_data |> 
  filter(comparison_features=="cases_per1k") |> 
  ggplot() + 
  aes(y = pct_vaccinated_eligible, x = values, alpha = values) +
  geom_point() +
  geom_smooth(method="lm") +
  # facet_wrap(~comparison_features) +
  scale_y_continuous(labels = scales::percent) +
  scale_color_gradient_tableau(palette = "Blue", labels = scales::percent) +
  theme_minimal() +
  theme(legend.position  = "none",
        plot.title = element_text(face = "bold")) +
  labs(title = "What May Be Driving Uptake?",
       subtitle = "As of September 9th, 2021",
       caption = "Data: Texas Department of State Health Services and US Census",
       x = "Cases For Every 1,000 Persons",
       y = "% Fully Vaccinated (Population 12+)")

ggsave("figures/3_uptake_vs_cases_per1k.png", device = "png", dpi = 300, width = 6, height = 4, bg = "white")

# 3. Comparing Vaccine Uptake to Deaths Per 1k -----------------------------

long_data |> 
  ggplot() + 
  aes(y = pct_vaccinated_eligible, x = values, alpha = values) +
  geom_point() +
  geom_smooth(method="lm") +
  facet_wrap(~comparison_features, scales = "free_x") +
  scale_y_continuous(labels = scales::percent) +
  scale_color_gradient_tableau(palette = "Blue", labels = scales::percent) +
  theme_minimal() +
  theme(legend.position  = "none",
        plot.title = element_text(face = "bold")) +
  labs(title = "What May Be Driving Uptake?",
       subtitle = "As of September 9th, 2021",
       caption = "Data: Texas Department of State Health Services and US Census",
       x = "Share (%) of Feature",
       y = "% Fully Vaccinated (Population 12+)")

ggsave("figures/3_uptake_vs_many_features.png", device = "png", dpi = 300, width = 8, height = 6, bg = "white")
