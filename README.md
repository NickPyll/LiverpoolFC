# Liverpool FC - Analyzing the Beautiful Game and the Team I Love

These visuals use the `plotly` package. This website https://plot.ly/r/line-charts/ was a good resource for getting started.

You do not need to set up API credentials to produce these visuals locally, only if you want to publish them to the website https://plot.ly/r/getting-started.

Data used in this exploration was sourced from:  
https://datahub.io/sports-data/english-premier-league

```{r}
########## Setup Environment ####

# plotly package needed for creating and publishing visuals
library(plotly)
# packageVersion('plotly')

# # Set up API credentials
# Sys.setenv("plotly_username" = "<your user id>")
# Sys.setenv("plotly_api_key" = "<your password>")

# packages needed for data manipulation
library(jsonlite)
library(dplyr)
library(magrittr)
library(tidyr)
library(stringr)

# set path for import league data
json_file <- 'https://datahub.io/sports-data/english-premier-league/datapackage.json'

# read data
json_data <- fromJSON(paste(readLines(json_file), collapse = ""))

# list data objects (current season is second in list)
print(json_data$resources$name)

```
