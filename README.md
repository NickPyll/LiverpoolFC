# Liverpool FC - Analyzing the Beautiful Game and the Team I Love

These visuals use the `plotly` package. This website https://plot.ly/r/line-charts/ was a good resource for getting started.

You do not need to set up API credentials to produce these visuals locally, only if you want to publish them to the website https://plot.ly/r/getting-started.

Data used in this exploration was sourced from:  
http://www.football-data.co.uk

```{r}
########## Setup Environment ####

# plotly package needed for creating and publishing visuals
library(plotly)
# packageVersion('plotly')

# # Set up API credentials
# Sys.setenv("plotly_username" = "<your user id>")
# Sys.setenv("plotly_api_key" = "<your password>")

# packages needed for data manipulation
library(dplyr)
library(magrittr)
library(tidyr)
library(stringr)
library(readr)

# load premier league seasons
x.1920 <- read_csv('https://www.football-data.co.uk/mmz4281/1920/E0.csv')
x.1819 <- read_csv('https://www.football-data.co.uk/mmz4281/1819/E0.csv')
x.1718 <- read_csv('https://www.football-data.co.uk/mmz4281/1718/E0.csv')
x.1617 <- read_csv('https://www.football-data.co.uk/mmz4281/1617/E0.csv')
x.1516 <- read_csv('https://www.football-data.co.uk/mmz4281/1516/E0.csv')
x.1415 <- read_csv('https://www.football-data.co.uk/mmz4281/1415/E0.csv')
x.1314 <- read_csv('https://www.football-data.co.uk/mmz4281/1314/E0.csv')
x.1213 <- read_csv('https://www.football-data.co.uk/mmz4281/1213/E0.csv')
x.1112 <- read_csv('https://www.football-data.co.uk/mmz4281/1112/E0.csv')
x.1011 <- read_csv('https://www.football-data.co.uk/mmz4281/1011/E0.csv')
x.0910 <- read_csv('https://www.football-data.co.uk/mmz4281/0910/E0.csv')

```
