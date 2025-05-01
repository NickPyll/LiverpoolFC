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
library(janitor)
library(slider)

## Updates and fixes todo ----
# fix all manual date/season refs with dynamic coding
# ctrl F "update_me" or "fix_me" to find

# Load data----

## Load raw premier league seasons ----
# create ids for seasons
season.year.end <- 2024
year.range <- 2000:season.year.end # update_me fix_me logic has to be changed to add pre 2000 seasons
year.list <- paste0(substr(year.range, 3, 4), substr(year.range + 1, 3, 4))
current.season.id <- tail(year.list, 1)

# initialize empty data frame
x.seasons <- data.frame(
  date = as.Date(character()),
  game_id = character(),
  home_team = character(),
  away_team = character(),
  fthg = integer(),
  ftag = integer(),
  stringsAsFactors = FALSE
)

# iterate through csv files
for (i in year.list) {
  print(paste("Ingesting data from season", i))

  df <-
    read_csv(
      paste0(
        "https://www.football-data.co.uk/mmz4281/", # data source
        i, # season
        "/E0.csv"
      ), # E0 is premier league
      show_col_types = FALSE
    ) |>
    mutate(
      Season = i,
      HomeTeam = str_replace_all(str_trim(gsub(" ", "", HomeTeam)), "[^[:alnum:]]", ""),
      AwayTeam = str_replace_all(str_trim(gsub(" ", "", AwayTeam)), "[^[:alnum:]]", ""),
      GameID = paste0(HomeTeam, AwayTeam)
    ) |>
    select(Season, Date, GameID, HomeTeam, AwayTeam, FTHG, FTAG) |>
    filter(!is.na(HomeTeam)) |>
    clean_names()

  # date format changed in 2017
  if (as.numeric(i) < 1718) {
    # except for 2002 / 2003 season...
    if (i == "0203") {
      df %<>%
        mutate(date = as.Date(as.character(date), format = "%d/%m/%Y"))
    } else {
      df %<>%
        mutate(date = as.Date(as.character(date), format = "%d/%m/%y"))
    }
  } else {
    df %<>%
      mutate(date = as.Date(as.character(date), format = "%d/%m/%Y"))
  }

  x.seasons <- x.seasons |> bind_rows(df)
  rm(df)
}

rm(list = ls(pattern = "^year."))
rm(i)

## Club metadata ----
# load premier league clubs
source("seasonal_analysis/data/ref_clubs.R")

## Liverpool historical data ----

# data for Liverpool league position by year
source("seasonal_analysis/data/ref_liv_hist.R")

# Clean and transform data ----
# create fixture list for current season, filling in missing games
x.fixture.list <-
  premier.league.clubs |>
  select(team) |>
  rename(home_team = team) |>
  mutate(k = 1) |>
  inner_join(
    premier.league.clubs |>
      select(team) |>
      rename(away_team = team) |>
      mutate(k = 1),
    by = "k"
  ) |>
  select(-k) |>
  filter(home_team != away_team) |>
  left_join(
    x.seasons |>
      filter(season == current.season.id) |>
      select(home_team, away_team) |>
      mutate(played = 1),
    by = c("home_team", "away_team")
  )

# transform current season data
x.seasons <-
  x.seasons |>
  mutate(
    team = home_team,
    goals_scored = fthg,
    goals_conceded = ftag
  ) |>
  select(season, game_id, date, team, goals_scored, goals_conceded) |>
  bind_rows(x.seasons |>
    mutate(
      team = away_team,
      goals_scored = ftag,
      goals_conceded = fthg
    ) |>
    select(season, game_id, date, team, goals_scored, goals_conceded)) |>
  mutate(played = 1) |>
  arrange(season, date, game_id) |>
  # logic for calculating goal differential and points earned
  mutate(
    goal_differential = goals_scored - goals_conceded,
    points_earned = if_else(goals_scored > goals_conceded, 3,
      if_else(goals_scored < goals_conceded, 0, 1)
    )
  ) |>
  group_by(season, team) |>
  # create week number
  mutate(week = row_number()) |>
  ungroup()

x.current.week <- x.seasons |>
  filter(season == current.season.id) |>
  summarize(max(week)) |>
  pull()

# create a week df to complete
x.week.teams <-
  data.frame(week = seq(0, x.current.week, 1)) |>
  mutate(season = current.season.id) |>
  inner_join(
    premier.league.clubs |>
      select(team) |>
      mutate(season = current.season.id),
    by = "season"
  )

## Current season data ----
x.current.season <-
  x.seasons |>
  filter(season == current.season.id) |>
  right_join(x.week.teams,
    by = c("week", "team", "season")
  ) |>
  mutate(
    points_earned = if_else(is.na(points_earned), 0, points_earned),
    goals_scored = if_else(is.na(goals_scored), 0, goals_scored),
    goals_conceded = if_else(is.na(goals_conceded), 0, goals_conceded),
    goal_differential = if_else(is.na(goal_differential), 0, goal_differential)
  ) |>
  mutate(
    points_earned = if_else(team == "Everton" & week == 0 & season == "2324", -6,
      if_else(team == "NottmForest" & week == 0 & season == "2324", -4, points_earned)
    ), # point deductions applied here
    played = if_else(week == 0, 0, played)
  ) |>
  arrange(week, game_id) |>
  group_by(team) |>
  mutate(
    points_tally = cumsum(points_earned),
    goals_scored_tally = cumsum(goals_scored),
    goals_conceded_tally = cumsum(goals_conceded),
    goal_differential_tally = cumsum(goal_differential)
  ) |>
  ungroup()

## Create historical champion data set ----
x.seasons.champions <-
  x.seasons |>
  left_join(premier.league.champions,
    by = "season"
  ) |>
  mutate(champion = if_else(season == current.season.id, "Liverpool", champion)) |>
  filter(team == champion) |>
  mutate(champion = paste0(team, season)) |>
  arrange(season, week) |>
  group_by(champion) |>
  # create week number and cumulative sums
  mutate(
    points_tally = cumsum(points_earned),
    goals_scored_tally = cumsum(goals_scored),
    goals_conceded_tally = cumsum(goals_conceded),
    goal_differential_tally = cumsum(goal_differential)
  ) |>
  ungroup()

## Points by week ----
pbw.data <-
  x.current.season |>
  filter(!is.na(played)) |>
  select(week, team, points_tally) |>
  spread(team, points_tally) |>
  arrange(week)

pbw.order <-
  x.current.season |>
  slice_max(week, by = team) |>
  arrange(desc(points_tally), desc(goal_differential_tally), desc(goals_scored_tally)) |>
  mutate(team = fct_inorder(team)) |>
  pull(team) |>
  levels()

## Points by week (past champions) ----
pbw.champions.data <-
  x.seasons.champions |>
  select(week, champion, points_tally) |>
  spread(champion, points_tally) |>
  arrange(week)

pbw.champions.order <-
  x.seasons.champions |>
  slice_max(week, by = champion) |>
  arrange(desc(week), desc(points_tally)) |>
  mutate(champion = fct_inorder(champion)) |>
  pull(champion) |>
  levels() # update_me should sort this based on current week instead of end week

## Points per game by week ----
ppgbw.data <-
  x.current.season |>
  filter(!is.na(played)) |>
  mutate(points_per_game = points_tally / week) |>
  select(week, team, points_per_game) |>
  spread(team, points_per_game) |>
  arrange(week)

ppgbw.order <-
  x.current.season |>
  filter(!is.na(played)) |>
  mutate(points_per_game = points_tally / week) |>
  select(week, team, points_per_game) |>
  slice_max(week, by = team) |>
  arrange(desc(points_per_game)) |>
  mutate(team = fct_inorder(team)) |>
  pull(team) |>
  levels()

## L5 Form ----
ppgbwl5.data <-
  x.current.season |>
  filter(!is.na(played), week > 0) |>
  group_by(team) |>
  arrange(week) |>
  mutate(points_per_week_last5 = slide_dbl(points_earned, mean, .before = 4, .complete = FALSE)) |>
  ungroup() |>
  select(week, team, points_per_week_last5) |>
  spread(team, points_per_week_last5)

ppgbwl5.order <-
  x.current.season |>
  filter(!is.na(played), week > 0) |>
  group_by(team) |>
  arrange(week) |>
  mutate(points_per_week_last5 = slide_dbl(points_earned, mean, .before = 4, .complete = FALSE)) |>
  ungroup() |>
  select(week, team, points_per_week_last5, points_tally) |>
  slice_max(week, by = team) |>
  arrange(desc(points_per_week_last5), desc(points_tally)) |>
  mutate(team = fct_inorder(team)) |>
  pull(team) |>
  levels()

## Goal differential by week----
gdbw.data <-
  x.current.season |>
  filter(!is.na(played)) |>
  select(week, team, goal_differential_tally) |>
  spread(team, goal_differential_tally) |>
  arrange(week)

gdbw.order <-
  x.current.season |>
  slice_max(week, by = team) |>
  arrange(desc(week), desc(goal_differential_tally), desc(goals_scored_tally)) |>
  mutate(team = fct_inorder(team)) |>
  pull(team) |>
  levels()

## Goal differential ----
gdbt.data <-
  x.current.season |>
  filter(week > 0) |>
  mutate(
    goals_scored = if_else(is.na(played), NA_real_, goals_scored),
    goals_conceded = if_else(is.na(played), NA_real_, goals_conceded)
  ) |>
  mutate(goal_differential = goals_scored - goals_conceded) |>
  select(week, team, goal_differential) |>
  arrange(team) |>
  spread(team, goal_differential)

## Goals scored ----
gsbt.data <-
  x.current.season |>
  filter(week > 0) |>
  mutate(goals_scored = if_else(is.na(played), NA_real_, goals_scored)) |>
  select(week, team, goals_scored) |>
  arrange(team) |>
  spread(team, goals_scored)

## Goals conceded ----
gcbt.data <-
  x.current.season |>
  filter(week > 0) |>
  mutate(goals_conceded = if_else(is.na(played), NA_real_, goals_conceded)) |>
  select(week, team, goals_conceded) |>
  arrange(team) |>
  spread(team, goals_conceded)

## Rank by week ----
rbw.data <-
  x.current.season |>
  filter(week > 0) |>
  group_by(week) |>
  arrange(desc(points_tally), desc(goal_differential_tally), desc(goals_scored_tally)) |>
  mutate(position = row_number()) |>
  ungroup() |>
  select(week, team, position) |>
  spread(team, position) |>
  arrange(week)

rbw.order <-
  x.current.season |>
  group_by(week) |>
  arrange(desc(points_tally), desc(goal_differential_tally), desc(goals_scored_tally)) |>
  mutate(position = row_number()) |>
  ungroup() |>
  slice_max(week, by = team) |>
  arrange(desc(week), position) |>
  mutate(team = fct_inorder(team)) |>
  pull(team) |>
  levels()

## Remaining opponent ----

x.current_form <-
  x.current.season |>
  filter(!is.na(played), week > 0) |>
  group_by(team) |>
  arrange(week) |>
  mutate(form = slide_dbl(points_earned, mean, .before = 4, .complete = FALSE)) |>
  ungroup() |>
  select(week, team, form) |>
  slice_max(week, by = team) |>
  select(team, form)

# collect remaining fixtures
x.remaining.fixtures <-
  x.fixture.list |>
  filter(is.na(played)) |>
  select(-played) |>
  left_join(
    x.current.season |>
      filter(week == x.current.week) |>
      arrange(desc(points_tally), desc(goal_differential_tally), desc(goals_scored_tally)) |>
      mutate(home_position = row_number()) |>
      ungroup() |>
      select(team, home_position),
    by = c("home_team" = "team")
  ) |>
  left_join(
    x.current.season |>
      filter(week == x.current.week) |>
      arrange(desc(points_tally), desc(goal_differential_tally), desc(goals_scored_tally)) |>
      mutate(away_position = row_number()) |>
      ungroup() |>
      select(team, away_position),
    by = c("away_team" = "team")
  ) |>
  left_join(
    x.current_form |>
      rename(away_form = form),
    by = c("away_team" = "team")
  ) |>
  left_join(
    x.current_form |>
      rename(home_form = form),
    by = c("home_team" = "team")
  )

# join league position
x.remaining_rank <-
  x.remaining.fixtures |>
  select(home_team, away_position) |>
  rename(
    team = home_team,
    position = away_position
  ) |>
  bind_rows(x.remaining.fixtures |>
    select(away_team, home_position) |>
    rename(
      team = away_team,
      position = home_position
    )) |>
  arrange(team, desc(position)) |>
  group_by(team) |>
  mutate(week = row_number()) |>
  ungroup()

ropbw.data <-
  x.remaining_rank |>
  select(team, week, position) |>
  spread(team, position) |>
  arrange(week)

# join form
rofbw.data <-
  x.remaining.fixtures |>
  select(home_team, away_form) |>
  rename(
    team = home_team,
    opponent_form = away_form
  ) |>
  bind_rows(x.remaining.fixtures |>
    select(away_team, home_form) |>
    rename(
      team = away_team,
      opponent_form = home_form
    )) |>
  group_by(team) |>
  mutate(week = row_number()) |>
  ungroup() |>
  spread(team, opponent_form) |>
  arrange(week)


## Rank by year ----
rby.data <-
  x.liverpool.league.history |>
  mutate(
    actual_position = # logic for identifying champions and actual position
      if_else(league == 1, position,
        if_else(league == 2, position + num_teams_firstdiv,
          position + num_teams_firstdiv + num_teams_seconddiv
        )
      )
  ) |>
  mutate(champions = if_else(position == 1, actual_position, NA_real_))

# remove unnecessary objects
rm(list = ls(pattern = "^x"))
rm(list = ls(pattern = "^y"))
rm(current.season.id)
