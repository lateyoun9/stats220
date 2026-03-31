# --------------------------------------------------
# STATS 220 Project 2: Part C and Part D exploration
# --------------------------------------------------

# Load the tidyverse collection of packages.
library(tidyverse)

# Read the published CSV file into a data frame called `logged_data`.
csv_url <- "https://docs.google.com/spreadsheets/d/e/2PACX-1vTfpj3N-gr781x29ItgF2DSBX9b2lNXM1nVEa-Ef4ltB-cjGV1t1G1WiWfZY6LAioGv_paJSzm64F7c/pub?gid=1567798230&single=true&output=csv"

logged_data <- read_csv(csv_url)

# Explore the imported data first.
glimpse(logged_data)
names(logged_data)
head(logged_data)

# Store the original column names so `rename()` can work reliably.
original_names <- names(logged_data)

if (length(original_names) < 6) {
  stop("The CSV file should contain at least 6 columns for this script.")
}

# Rename the variables of `logged_data` to create `latest_data`.
latest_data <- logged_data %>%
  rename(
    timestamp = all_of(original_names[1]),
    platform = all_of(original_names[2]),
    ad_type = all_of(original_names[3]),
    ad_duration_seconds = all_of(original_names[4]),
    click_response = all_of(original_names[5]),
    time_of_day = all_of(original_names[6])
  )

# Check the renamed data.
glimpse(latest_data)
names(latest_data)

# Clean the data so it is easier to analyse.
latest_data <- latest_data %>%
  mutate(
    timestamp = as.POSIXct(timestamp, format = "%d/%m/%Y %H:%M:%S"),
    ad_duration_seconds = as.numeric(ad_duration_seconds),
    click_response = factor(click_response, levels = c("Yes", "No"))
  )

# Explore summary values from the ad duration and click response variables.
summary_values <- latest_data %>%
  summarise(
    total_ads_logged = n(),
    average_duration = mean(ad_duration_seconds, na.rm = TRUE),
    max_duration = max(ad_duration_seconds, na.rm = TRUE),
    yes_clicks = sum(click_response == "Yes", na.rm = TRUE),
    click_rate = mean(click_response == "Yes", na.rm = TRUE)
  )

summary_values

# Count each platform after splitting the multiple-response entries.
platform_counts <- latest_data %>%
  separate_rows(platform, sep = ",\\s*") %>%
  count(platform, sort = TRUE)

platform_counts

# Count each ad type after splitting the multiple-response entries.
ad_type_counts <- latest_data %>%
  separate_rows(ad_type, sep = ",\\s*") %>%
  count(ad_type, sort = TRUE)

ad_type_counts

# Create the first informative bar chart for ad platforms.
bar_chart_1 <- ggplot(
  platform_counts,
  aes(x = reorder(platform, n), y = n)
) +
  geom_col(fill = "#457b9d") +
  coord_flip() +
  labs(
    title = "Number of observed ads by platform",
    x = "Platform",
    y = "Number of ads"
  ) +
  theme_minimal()

bar_chart_1

# Create the second informative bar chart for ad types.
bar_chart_2 <- ggplot(
  ad_type_counts,
  aes(x = reorder(ad_type, n), y = n)
) +
  geom_col(fill = "#e76f51") +
  coord_flip() +
  labs(
    title = "Number of observed ads by ad type",
    x = "Ad type",
    y = "Number of ads"
  ) +
  theme_minimal()

bar_chart_2

# ------------------------------------------
# Report-ready code for the final report
# ------------------------------------------

# Use this section as the code you are most likely to keep in your report.
report_summary_values <- latest_data %>%
  summarise(
    total_ads_logged = n(),
    average_duration = mean(ad_duration_seconds, na.rm = TRUE),
    max_duration = max(ad_duration_seconds, na.rm = TRUE),
    yes_clicks = sum(click_response == "Yes", na.rm = TRUE),
    click_rate = mean(click_response == "Yes", na.rm = TRUE)
  )

report_bar_chart_1 <- latest_data %>%
  separate_rows(platform, sep = ",\\s*") %>%
  count(platform, sort = TRUE) %>%
  ggplot(aes(x = reorder(platform, n), y = n)) +
  geom_col(fill = "#264653") +
  coord_flip() +
  labs(
    title = "Number of observed ads by platform",
    x = "Platform",
    y = "Number of ads"
  ) +
  theme_minimal()

report_bar_chart_2 <- latest_data %>%
  separate_rows(ad_type, sep = ",\\s*") %>%
  count(ad_type, sort = TRUE) %>%
  ggplot(aes(x = reorder(ad_type, n), y = n)) +
  geom_col(fill = "#f4a261") +
  coord_flip() +
  labs(
    title = "Number of observed ads by ad type",
    x = "Ad type",
    y = "Number of ads"
  ) +
  theme_minimal()

report_summary_values
report_bar_chart_1
report_bar_chart_2
