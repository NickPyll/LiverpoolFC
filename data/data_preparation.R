# Setup environment ----

## Libraries ----
library(plotly)
# packageVersion('plotly')

# # Set up API credentials (this is in .Rprofile for me...)
# Sys.setenv("plotly_username" = "<your user id>")
# Sys.setenv("plotly_api_key" = "<your password>")

# packages needed for data manipulation
library(tidyverse)
library(magrittr)

## Updates and fixes todo ----
# fix all manual date/season refs with dynamic coding 
# ctrl F "update_me" or "fix_me" to find

# Load data----

## Load raw premier league seasons ----
# create ids for seasons
season.year.end <- 2023
year.range <- 2000:season.year.end # update_me fix_me logic has to be changed to add pre 2000 seasons
year.list <- paste0(substr(year.range, 3, 4), substr(year.range + 1, 3, 4))
current.season.id <- tail(year.list, 1)

# initialize empty data frame
x.seasons <- data.frame(Date = as.Date(character()),
                        GameID = character(),
                        HomeTeam = character(), 
                        AwayTeam = character(), 
                        FTHG = integer(),
                        FTAG = integer(),
                        stringsAsFactors = FALSE) 

# iterate through csv files
for (i in year.list){
  df <- read_csv(paste0('https://www.football-data.co.uk/mmz4281/', i, '/E0.csv')) |> 
    mutate(Season = i,
           HomeTeam = str_replace_all(str_trim(gsub(" ", "", HomeTeam)), "[^[:alnum:]]", ""),
           AwayTeam = str_replace_all(str_trim(gsub(" ", "", AwayTeam)), "[^[:alnum:]]", ""),
           GameID = paste0(HomeTeam, AwayTeam)) |> 
    select(Season, Date, GameID, HomeTeam, AwayTeam, FTHG, FTAG) |> 
    filter(!is.na(HomeTeam))
  
  # date format changed in 2017
  if (as.numeric(i) < 1718) {
    
    # except for 2002 / 2003 season...
    if(i == '0203'){
      df %<>%
        mutate(Date = as.Date(as.character(Date), format = '%d/%m/%Y'))
      } else {
        df %<>%
          mutate(Date = as.Date(as.character(Date), format = '%d/%m/%y'))
      }
  } else {
    df %<>%
      mutate(Date = as.Date(as.character(Date), format = '%d/%m/%Y'))
  }
  
  x.seasons <- x.seasons |> bind_rows(df)
  rm(df)
}

rm(list = ls(pattern = "^year."))
rm(i)

## Club metadata ----
# load premier league clubs
source("data/ref_clubs.R")

## Liverpool historical data ----

# data for Liverpool league position by year
source("data/ref_liv_hist.R")

# Clean and transform data ----
# create fixture list for current season, filling in missing games
x.fixture.list <- 
  premier.league.clubs |>
  select(Team) |>
  rename(HomeTeam = Team) |>
  mutate(k = 1) |>
  inner_join(premier.league.clubs |>
               select(Team) |>
               rename(AwayTeam = Team) |>
               mutate(k = 1),
             by = 'k') |>
  select(-k) |>
  filter(HomeTeam != AwayTeam) |>
  left_join(x.seasons |>
              filter(Season == current.season.id) |>
              select(HomeTeam, AwayTeam) |>
              mutate(played = 1),
            by = c('HomeTeam', 'AwayTeam')) 

# transform current season data
x.seasons <- 
  x.seasons |>
  mutate(Team = HomeTeam,
         GoalsScored = FTHG,
         GoalsConceded = FTAG) |>
  select(Season, GameID, Date, Team, GoalsScored, GoalsConceded) |> 
  bind_rows(x.seasons |>
              mutate(Team = AwayTeam,
                     GoalsScored = FTAG,
                     GoalsConceded = FTHG) |>
              select(Season, GameID, Date, Team, GoalsScored, GoalsConceded)) |> 
  mutate(played = 1) |>
  arrange(Season, Date, GameID) |>
  # logic for calculating goal differential and points earned
  mutate(GoalDifferential = GoalsScored - GoalsConceded,
         PointsEarned = if_else(GoalsScored > GoalsConceded, 3,
                                if_else(GoalsScored < GoalsConceded, 0, 1))) |>
  group_by(Season,Team) |>
  # create week number
  mutate(Week = row_number()) |>
  ungroup() 

x.current.week <- x.seasons |> filter(Season == current.season.id) |> summarize(max(Week)) |> pull()
  
# create a week df to complete
x.week.teams <-
  data.frame(Week = seq(0, x.current.week, 1)) |>
  mutate(Season = current.season.id) |>
  inner_join(premier.league.clubs |>
               select(Team) |> 
               mutate(Season = current.season.id),
             by = 'Season') 

## Current season data ----
x.current.season <-
  x.seasons |> 
  filter(Season == current.season.id) |> 
  right_join(x.week.teams,
             by = c("Week", "Team", "Season")) |>
  mutate(PointsEarned = if_else(is.na(PointsEarned), 0, PointsEarned),
         GoalsScored = if_else(is.na(GoalsScored), 0, GoalsScored),
         GoalsConceded = if_else(is.na(GoalsConceded), 0, GoalsConceded),
         GoalDifferential = if_else(is.na(GoalDifferential), 0, GoalDifferential)) |> 
  mutate(PointsEarned = if_else(Team == 'Everton' & Week == 0 & Season == '2324', -6, 
                                if_else(Team == 'NottmForest' & Week == 0 & Season == '2324', -4, PointsEarned)), # point deductions applied here
         played = if_else(Week == 0, 0, played)) |>
  arrange(Week, GameID) |>
  group_by(Team) |>
  mutate(PointsTally = cumsum(PointsEarned),
         GoalsScoredTally = cumsum(GoalsScored),
         GoalsConcededTally = cumsum(GoalsConceded),
         GoalDifferentialTally = cumsum(GoalDifferential)) |> 
  ungroup()

## Create historical champion data set ----
x.seasons.champions <-
  x.seasons |> 
  left_join(premier.league.champions, 
            by = 'Season') |> 
  mutate(Champion = if_else(Season == current.season.id, 'Liverpool', Champion)) |> 
  filter(Team == Champion) |> 
  mutate(Champion = paste0(Team, Season)) |> 
  arrange(Season, Week) |> 
  group_by(Champion) |>
  # create week number and cumulative sums
  mutate(PointsTally = cumsum(PointsEarned),
         GoalsScoredTally = cumsum(GoalsScored),
         GoalsConcededTally = cumsum(GoalsConceded),
         GoalDifferentialTally = cumsum(GoalDifferential)) |>
  ungroup() 

## Points by week ----
pbw.data <-
  x.current.season |>
  filter(!is.na(played)) |>
  select(Week, Team, PointsTally) |>
  spread(Team, PointsTally) |>
  arrange(Week)

pbw.order <- 
  x.current.season |>
  slice_max(Week, by = Team) |>
  arrange(desc(PointsTally), desc(GoalDifferentialTally), desc(GoalsScoredTally)) |>
  mutate(Team = fct_inorder(Team)) |>
  pull(Team) |>
  levels()

## Points by week (past champions) ----
pbw.champions.data <-
  x.seasons.champions |>
  select(Week, Champion, PointsTally) |>
  spread(Champion, PointsTally) |>
  arrange(Week)

pbw.champions.order <- 
  x.seasons.champions |>
  slice_max(Week, by = Champion) |>
  arrange(desc(Week), desc(PointsTally)) |>
  mutate(Champion = fct_inorder(Champion)) |>
  pull(Champion) |>
  levels() # update_me should sort this based on current week instead of end week

## Goal differential by week----
gdbw.data <-
  x.current.season |>
  filter(!is.na(played)) |>
  select(Week, Team, GoalDifferentialTally) |>
  spread(Team, GoalDifferentialTally) |>
  arrange(Week)

gdbw.order <- 
  x.current.season |>
  slice_max(Week, by = Team) |>
  arrange(desc(Week), desc(GoalDifferentialTally), desc(GoalsScoredTally)) |>
  mutate(Team = fct_inorder(Team)) |>
  pull(Team) |>
  levels() 

## Goal differential ----
gdbt.data <-
  x.current.season |>
  mutate(GoalsScored = if_else(is.na(played), NA_real_, GoalsScored),
         GoalsConceded = if_else(is.na(played), NA_real_, GoalsConceded)) |>
  mutate(GoalDifferential = GoalsScored - GoalsConceded) |>
  select(Week, Team, GoalDifferential) |>
  arrange(Team) |>
  spread(Team, GoalDifferential)

## Goals scored ----
gsbt.data <-
  x.current.season |>
  mutate(GoalsScored = if_else(is.na(played), NA_real_, GoalsScored)) |>
  select(Week, Team, GoalsScored) |>
  arrange(Team) |>
  spread(Team, GoalsScored)

## Goals conceded ----
gcbt.data <-
  x.current.season |>
  mutate(GoalsConceded = if_else(is.na(played), NA_real_, GoalsConceded)) |>
  select(Week, Team, GoalsConceded) |>
  arrange(Team) |>
  spread(Team, GoalsConceded)

## Rank by week ----
rbw.data <-
  x.current.season |>
  group_by(Week) |>
  arrange(desc(PointsTally), desc(GoalDifferentialTally), desc(GoalsScoredTally)) |>
  mutate(Position = row_number()) |>
  ungroup() |> 
  select(Week, Team, Position) |>
  spread(Team, Position) |>
  arrange(Week)

rbw.order <- 
  x.current.season |>
  group_by(Week) |>
  arrange(desc(PointsTally), desc(GoalDifferentialTally), desc(GoalsScoredTally)) |>
  mutate(Position = row_number()) |>
  ungroup() |> 
  slice_max(Week, by = Team) |>
  arrange(desc(Week), Position) |>
  mutate(Team = fct_inorder(Team)) |>
  pull(Team) |>
  levels()

## Remaining opponent ----

# collect remaining fixtures
x.remaining.fixtures <-
  x.fixture.list |>
  filter(is.na(played)) |>
  select(-played) |>
  left_join(x.current.season |>
              filter(Week == x.current.week) |> 
              arrange(desc(PointsTally), desc(GoalDifferentialTally), desc(GoalsScoredTally)) |>
              mutate(HomePosition = row_number()) |>
              ungroup() |> 
              select(Team, HomePosition),
            by = c("HomeTeam" = "Team")) |>
  left_join(x.current.season |>
              filter(Week == x.current.week) |> 
              arrange(desc(PointsTally), desc(GoalDifferentialTally), desc(GoalsScoredTally)) |>
              mutate(AwayPosition = row_number()) |>
              ungroup() |> 
              select(Team, AwayPosition),
            by = c("AwayTeam" = "Team"))

# join league position
x.strength.of.schedule <-
  x.remaining.fixtures |>
  select(HomeTeam, AwayPosition) |>
  rename(Team = HomeTeam,
         Position = AwayPosition) |>
  bind_rows(x.remaining.fixtures |>
              select(AwayTeam, HomePosition) |>
              rename(Team = AwayTeam,
                     Position = HomePosition)) |>
  arrange(Team, desc(Position)) |>
  group_by(Team) |>
  mutate(Week = row_number()) |>
  ungroup()

orbw.data <- 
  x.strength.of.schedule |>
  select(Team, Week, Position) |>
  spread(Team, Position) |>
  arrange(Week)

## Rank by year ----
rby.data <-
  x.liverpool.league.history |>
  mutate(ActualPosition = # logic for identifying champions and actual position
           if_else(League == 1, Position,
                   if_else(League == 2, Position + NumTeamsFirstDiv,
                           Position + NumTeamsFirstDiv + NumTeamsSecondDiv))) |>
  mutate(Champions = if_else(Position == 1, ActualPosition, NA_real_))

# remove unnecessary objects
rm(list = ls(pattern = "^x"))
rm(list = ls(pattern = "^y"))
rm(current.season.id)

