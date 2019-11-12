library(jsonlite)
library(dplyr)
library(magrittr)
library(tidyr)
library(stringr)
library(readr)

# set path for import league data
json_file <- 'https://datahub.io/sports-data/english-premier-league/datapackage.json'

# read data
# json_data <- fromJSON(paste(readLines(json_file), collapse = ""))
json_data <- fromJSON(readr::read_file(json_file))

# list data objects (current season is second in list)
print(json_data$resources$name)

x.1819 <- read.csv(url(json_data$resources$path[2]), skipNul = TRUE)
x.1718 <- read.csv(url(json_data$resources$path[3]), skipNul = TRUE)
x.1617 <- read.csv(url(json_data$resources$path[4]), skipNul = TRUE)
x.1516 <- read.csv(url(json_data$resources$path[5]), skipNul = TRUE)
x.1415 <- read.csv(url(json_data$resources$path[6]), skipNul = TRUE)
x.1314 <- read.csv(url(json_data$resources$path[7]), skipNul = TRUE)
x.1213 <- read.csv(url(json_data$resources$path[8]), skipNul = TRUE)
x.1112 <- read.csv(url(json_data$resources$path[9]), skipNul = TRUE)
x.1011 <- read.csv(url(json_data$resources$path[10]), skipNul = TRUE)
x.0910 <- read.csv(url(json_data$resources$path[11]), skipNul = TRUE)

########## Manual Entry Data ####
# manually enter updated data
# x.data.update <-
#   tribble(
#     ~Date, ~HomeTeam, ~AwayTeam, ~FTHG, ~FTAG,
#     '2019-04-23', 'Watford', 'Southampton', 1, 1,
#     '2019-04-23', 'Tottenham', 'Brighton', 1, 0,
#     '2019-04-24', 'Man United', 'Man City', 0, 2,
#     '2019-04-24', 'Wolves', 'Arsenal', 3, 1
# )
# 
# x.data.update %<>%
#   mutate(
#     Date = as.Date(as.character(Date), format = '%Y-%m-%d'))

# Pull Liverpool games from manual update
# x.data.update.10yr <-
#   x.data.update %>%
#   filter(HomeTeam == 'Liverpool' | AwayTeam == 'Liverpool')

# add the updated data
# x.current.data %<>%
#   mutate(
#     Date = as.Date(as.character(Date), format = '%Y-%m-%d'),
#     HomeTeam = as.character(HomeTeam),
#     AwayTeam = as.character(AwayTeam)) %>%
#   bind_rows(x.data.update %>%
#               filter(Date > max(as.Date(as.character(x.current.data$Date), format = '%Y-%m-%d')))) 
# 
# # add the updated data
# x.1819 %<>%
#   mutate(
#     Date = as.Date(as.character(Date), format = '%Y-%m-%d'),
#     HomeTeam = as.character(HomeTeam),
#     AwayTeam = as.character(AwayTeam)) %>%
#   bind_rows(x.data.update.10yr %>%
#               filter(Date > max(as.Date(as.character(x.1819$Date), format = '%Y-%m-%d')))) 

# Remaining Fixtures for Manchester City and Liverpool
# x.remaining.fixtures <-
#   tribble(
#     ~Week, ~Liverpool, ~ManCity,
#     36, 'Huddersfield', 'Burnley',
#     37, 'Newcastle', 'Leicester',
#     38, 'Wolves', 'Brighton'
#   )
    
# Five Thirty Eight probabilities
# x.rem.prob <-
#   tribble(
#     ~Team, ~pwin, ~pdraw,
#     'Liverpool', .89, .09,
#     'Liverpool', .65, .21,
#     'Liverpool', .80, .15,
#     'Man City', .74, .16,
#     'Man City', .83, .13,
#     'Man City', .75, .16
# )

# add current rank to remaining opponents
# x.liverpool.opp.rank <-
#   inner_join(x.remaining.fixtures, x.current.rank, by = c('Liverpool' = 'Team')) %>%
#   rename(Liverpool.Opponent = Position) %>%
#   select(Liverpool.Opponent) %>%
#   arrange(Liverpool.Opponent) 
# 
# x.mancity.opp.rank <-
#   inner_join(x.remaining.fixtures, x.current.rank, by = c('ManCity' = 'Team')) %>%
#   rename(ManCity.Opponent = Position) %>%
#   select(ManCity.Opponent) %>%
#   arrange(ManCity.Opponent) 

# remaining weeks  
# x.week <- 
#   x.remaining.fixtures %>%
#   select(Week)

# combine data
# orbw.data <- cbind(x.week, x.liverpool.opp.rank, x.mancity.opp.rank)

