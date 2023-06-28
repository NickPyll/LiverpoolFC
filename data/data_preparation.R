########## Setup Environment ####

# plotly package needed for creating and publishing visuals
library(plotly)
# packageVersion('plotly')

# # Set up API credentials (this is in .Rprofile for me...)
# Sys.setenv("plotly_username" = "<your user id>")
# Sys.setenv("plotly_api_key" = "<your password>")

# packages needed for data manipulation
library(dplyr)
library(magrittr)
library(tidyr)
library(stringr)
library(readr)

########## Updates and Fixed todo ####
# fix all manual date/season refs with dynamic coding 
# current solution ctrl F "update_me" to find

########## Load Current Rankings ####

# load spi power rankings from fivethirtyeight.com
x.spi.538 <- read_csv('https://projects.fivethirtyeight.com/soccer-api/club/spi_global_rankings.csv') %>%
  filter(league == 'Barclays Premier League') %>%
  select(-league, -rank) %>%
  rename(Team_538 = name) %>%
  mutate(Team_538 = str_trim(gsub(" ", "", Team_538)))

# load premier league clubs
source("data/ref_clubs.R")

# load historical predictions from fivethirtyeight.com
x.match_pred.538 <- read_csv('https://projects.fivethirtyeight.com/soccer-api/club/spi_matches.csv') %>%
  filter(league == 'Barclays Premier League',
         date > as.Date('1/8/2019', format = '%d/%m/%Y')) %>%
  select(team1, team2, prob1, prob2, probtie) %>%
  inner_join(x.premier.league.clubs %>%
               select(Team, Team_538) %>%
               rename(team1 = Team_538),
             by = 'team1') %>%
  rename(HomeTeam = Team) %>%
  inner_join(x.premier.league.clubs %>%
               select(Team, Team_538) %>%
               rename(team2 = Team_538),
             by = 'team2') %>%
  rename(AwayTeam = Team) %>%
  mutate(HomeTeam = str_trim(gsub(" ", "", HomeTeam)),
         AwayTeam = str_trim(gsub(" ", "", AwayTeam)),
         GameID = paste0(HomeTeam, AwayTeam)) %>%
  select(GameID, HomeTeam, AwayTeam, prob1, prob2, probtie)
  
########## Load Current Season ####

# load current premier league season update_me
y.2324 <- 
  read_csv('https://www.football-data.co.uk/mmz4281/2324/E0.csv') %>%
  mutate(
    HomeTeam = str_replace_all(str_trim(gsub(" ", "", HomeTeam)), "[^[:alnum:]]", ""), 
    AwayTeam = str_replace_all(str_trim(gsub(" ", "", AwayTeam)), "[^[:alnum:]]", ""))
    
# create copy for separate use update_me
x.current.data <- 
  y.2324 %>%
  select(Date, HomeTeam, AwayTeam, FTHG, FTAG)

# see when data was last updated
max(as.Date(as.character(x.current.data$Date), format = '%d/%m/%Y'))

# create date footnote
x.current.date = format(max(as.Date(as.character(x.current.data$Date), format = '%d/%m/%Y')), format = '%b-%d-%Y')
footnote = paste('Data sourced ', x.current.date, 'from football-data.co.uk')

# load historic premier league seasons update_me
y.2223 <- read_csv('https://www.football-data.co.uk/mmz4281/2223/E0.csv')
y.2122 <- read_csv('https://www.football-data.co.uk/mmz4281/2122/E0.csv')
y.2021 <- read_csv('https://www.football-data.co.uk/mmz4281/2021/E0.csv')
y.1920 <- read_csv('https://www.football-data.co.uk/mmz4281/1920/E0.csv')
y.1819 <- read_csv('https://www.football-data.co.uk/mmz4281/1819/E0.csv')
y.1718 <- read_csv('https://www.football-data.co.uk/mmz4281/1718/E0.csv')
y.1617 <- read_csv('https://www.football-data.co.uk/mmz4281/1617/E0.csv')
y.1516 <- read_csv('https://www.football-data.co.uk/mmz4281/1516/E0.csv')
y.1415 <- read_csv('https://www.football-data.co.uk/mmz4281/1415/E0.csv')
y.1314 <- read_csv('https://www.football-data.co.uk/mmz4281/1314/E0.csv')
y.1213 <- read_csv('https://www.football-data.co.uk/mmz4281/1213/E0.csv')
y.1112 <- read_csv('https://www.football-data.co.uk/mmz4281/1112/E0.csv')
y.1011 <- read_csv('https://www.football-data.co.uk/mmz4281/1011/E0.csv')
y.0910 <- read_csv('https://www.football-data.co.uk/mmz4281/0910/E0.csv')

# create fixture list
x.fixture.list <- 
  x.premier.league.clubs %>%
  select(-Team_538, -TeamColor) %>%
  rename(HomeTeam = Team) %>%
  mutate(k = 1) %>%
  inner_join(x.premier.league.clubs %>%
                 select(-Team_538, -TeamColor) %>%
                 rename(AwayTeam = Team) %>%
                 mutate(k = 1),
             by = 'k') %>%
  select(-k) %>%
  filter(HomeTeam != AwayTeam) %>%
  left_join(y.2324 %>% # update_me
              select(HomeTeam, AwayTeam) %>%
              mutate(played = 1), 
             by = c('HomeTeam', 'AwayTeam')) 

########## Load Historical Data ####

# data for Liverpool league position by year
source("data/ref_liv_hist.R")

########## Data Transformation ####

# logic for identifying champions and actual position
rby.data <-
  x.liverpool.league.history %>%
  mutate(ActualPosition = 
           if_else(League == 1, Position,
           if_else(League == 2, Position + NumTeamsFirstDiv,
                  Position + NumTeamsFirstDiv + NumTeamsSecondDiv))) %>%
  mutate(Champions = if_else(Position == 1, ActualPosition, NA_real_))

# format variables and create GameID update_me
x.current.data %<>%
  mutate(
    HomeTeam = str_trim(gsub(" ", "", HomeTeam)),  
    AwayTeam = str_trim(gsub(" ", "", AwayTeam)),
    GameID = paste0(HomeTeam, AwayTeam),
    Date = as.Date(as.character(Date), format = '%d/%m/%Y'))
y.2324 %<>%
  select(Date, HomeTeam, AwayTeam, FTHG, FTAG) %>%
  filter(HomeTeam == 'Liverpool' | AwayTeam == 'Liverpool') %>%
  mutate(
    Date = as.Date(as.character(Date), format = '%d/%m/%Y'),
    GameID = paste0(HomeTeam, AwayTeam),
    HomeTeam = paste0(as.character(HomeTeam), '2324'),
    AwayTeam = paste0(as.character(AwayTeam), '2324'),
    Season = '2324')
y.2223 %<>%
  select(Date, HomeTeam, AwayTeam, FTHG, FTAG) %>%
  filter(HomeTeam == 'Man City' | AwayTeam == 'Man City') %>%
  mutate(
    Date = as.Date(as.character(Date), format = '%d/%m/%Y'),
    GameID = paste0(HomeTeam, AwayTeam),
    HomeTeam = paste0(as.character(HomeTeam), '2223'),
    AwayTeam = paste0(as.character(AwayTeam), '2223'),
    Season = '2223')
y.2122 %<>%
  select(Date, HomeTeam, AwayTeam, FTHG, FTAG) %>%
  filter(HomeTeam == 'Man City' | AwayTeam == 'Man City') %>%
  mutate(
    Date = as.Date(as.character(Date), format = '%d/%m/%Y'),
    GameID = paste0(HomeTeam, AwayTeam),
    HomeTeam = paste0(as.character(HomeTeam), '2122'),
    AwayTeam = paste0(as.character(AwayTeam), '2122'),
    Season = '2122')
y.2021 %<>%
  select(Date, HomeTeam, AwayTeam, FTHG, FTAG) %>%
  filter(HomeTeam == 'Man City' | AwayTeam == 'Man City') %>%
  mutate(
    Date = as.Date(as.character(Date), format = '%d/%m/%Y'),
    GameID = paste0(HomeTeam, AwayTeam),
    HomeTeam = paste0(as.character(HomeTeam), '2021'),
    AwayTeam = paste0(as.character(AwayTeam), '2021'),
    Season = '2021')
y.1920 %<>%
  select(Date, HomeTeam, AwayTeam, FTHG, FTAG) %>%
  filter(HomeTeam == 'Liverpool' | AwayTeam == 'Liverpool') %>%
  mutate(
    Date = as.Date(as.character(Date), format = '%d/%m/%Y'),
    GameID = paste0(HomeTeam, AwayTeam),
    HomeTeam = paste0(as.character(HomeTeam), '1920'),
    AwayTeam = paste0(as.character(AwayTeam), '1920'),
    Season = '1920')
y.1819 %<>%
  select(Date, HomeTeam, AwayTeam, FTHG, FTAG) %>%
  filter(HomeTeam == 'Man City' | AwayTeam == 'Man City') %>%
  mutate(
    Date = as.Date(as.character(Date), format = '%d/%m/%Y'),
    GameID = paste0(HomeTeam, AwayTeam),
    HomeTeam = paste0(as.character(HomeTeam), '1819'),
    AwayTeam = paste0(as.character(AwayTeam), '1819'),
    Season = '1819') 
y.1718 %<>%
  select(Date, HomeTeam, AwayTeam, FTHG, FTAG) %>%
  filter(HomeTeam == 'Man City' | AwayTeam == 'Man City') %>%
  mutate(
    Date = as.Date(as.character(Date), format = '%d/%m/%Y'),
    GameID = paste0(HomeTeam, AwayTeam),
    HomeTeam = paste0(as.character(HomeTeam), '1718'),
    AwayTeam = paste0(as.character(AwayTeam), '1718'),
    Season = '1718') 
y.1617 %<>%
  select(Date, HomeTeam, AwayTeam, FTHG, FTAG) %>%
  filter(HomeTeam == 'Chelsea' | AwayTeam == 'Chelsea') %>%
  mutate(
    Date = as.Date(as.character(Date), format = '%d/%m/%y'),
    GameID = paste0(HomeTeam, AwayTeam),
    HomeTeam = paste0(as.character(HomeTeam), '1617'),
    AwayTeam = paste0(as.character(AwayTeam), '1617'),
    Season = '1617') 
y.1516 %<>%
  select(Date, HomeTeam, AwayTeam, FTHG, FTAG) %>%
  filter(HomeTeam == 'Leicester' | AwayTeam == 'Leicester') %>%
  mutate(
    Date = as.Date(as.character(Date), format = '%d/%m/%y'),
    GameID = paste0(HomeTeam, AwayTeam),
    HomeTeam = paste0(as.character(HomeTeam), '1516'),
    AwayTeam = paste0(as.character(AwayTeam), '1516'),
    Season = '1516') 
y.1415 %<>%
  select(Date, HomeTeam, AwayTeam, FTHG, FTAG) %>%
  filter(HomeTeam == 'Chelsea' | AwayTeam == 'Chelsea') %>%
  mutate(
    Date = as.Date(as.character(Date), format = '%d/%m/%y'),
    GameID = paste0(HomeTeam, AwayTeam),
    HomeTeam = paste0(as.character(HomeTeam), '1415'),
    AwayTeam = paste0(as.character(AwayTeam), '1415'),
    Season = '1415') 
y.1314 %<>%
  select(Date, HomeTeam, AwayTeam, FTHG, FTAG) %>%
  filter(HomeTeam == 'Man City' | AwayTeam == 'Man City') %>%
  mutate(
    Date = as.Date(as.character(Date), format = '%d/%m/%y'),
    GameID = paste0(HomeTeam, AwayTeam),
    HomeTeam = paste0(as.character(HomeTeam), '1314'),
    AwayTeam = paste0(as.character(AwayTeam), '1314'),
    Season = '1314') 
y.1213 %<>%
  select(Date, HomeTeam, AwayTeam, FTHG, FTAG) %>%
  filter(HomeTeam == 'Man United' | AwayTeam == 'Man United') %>%
  mutate(
    Date = as.Date(as.character(Date), format = '%d/%m/%y'),
    GameID = paste0(HomeTeam, AwayTeam),
    HomeTeam = paste0(as.character(HomeTeam), '1213'),
    AwayTeam = paste0(as.character(AwayTeam), '1213'),
    Season = '1213') 
y.1112 %<>%
  select(Date, HomeTeam, AwayTeam, FTHG, FTAG) %>%
  filter(HomeTeam == 'Man City' | AwayTeam == 'Man City') %>%
  mutate(
    Date = as.Date(as.character(Date), format = '%d/%m/%y'),
    GameID = paste0(HomeTeam, AwayTeam),
    HomeTeam = paste0(as.character(HomeTeam), '1112'),
    AwayTeam = paste0(as.character(AwayTeam), '1112'),
    Season = '1112') 
y.1011 %<>%
  select(Date, HomeTeam, AwayTeam, FTHG, FTAG) %>%
  filter(HomeTeam == 'Man United' | AwayTeam == 'Man United') %>%
  mutate(
    Date = as.Date(as.character(Date), format = '%d/%m/%y'),
    GameID = paste0(HomeTeam, AwayTeam),
    HomeTeam = paste0(as.character(HomeTeam), '1011'),
    AwayTeam = paste0(as.character(AwayTeam), '1011'),
    Season = '1011') 
y.0910 %<>%
  select(Date, HomeTeam, AwayTeam, FTHG, FTAG) %>%
  filter(HomeTeam == 'Chelsea' | AwayTeam == 'Chelsea') %>%
  mutate(
    Date = as.Date(as.character(Date), format = '%d/%m/%y'),
    GameID = paste0(HomeTeam, AwayTeam),
    HomeTeam = paste0(as.character(HomeTeam), '0910'),
    AwayTeam = paste0(as.character(AwayTeam), '0910'),
    Season = '0910') 

# Combine 10 years of data 
x.data.10yr <-
  mget(ls(pattern="^y\\.\\d+")) %>%
  bind_rows() %>%
  mutate(
    HomeTeam = str_trim(gsub(" ", "", HomeTeam)),  
    AwayTeam = str_trim(gsub(" ", "", AwayTeam)))
    
# create df of home team results
x.home <-
  x.current.data %>%
  mutate(Team = HomeTeam,
         GoalsScored = FTHG,
         GoalsConceded = FTAG) %>%
  select(GameID, Date, Team, GoalsScored, GoalsConceded)
x.home.10yr <-
  x.data.10yr %>%
  mutate(Team = HomeTeam,
         GoalsScored = FTHG,
         GoalsConceded = FTAG) %>%
  select(GameID, Date, Team, GoalsScored, GoalsConceded)

# create df of away team results
x.away <-
  x.current.data %>%
  mutate(Team = AwayTeam,
         GoalsScored = FTAG,
         GoalsConceded = FTHG) %>%
  select(GameID, Date, Team, GoalsScored, GoalsConceded)
x.away.10yr <-
  x.data.10yr %>%
  mutate(Team = AwayTeam,
         GoalsScored = FTAG,
         GoalsConceded = FTHG) %>%
  select(GameID, Date, Team, GoalsScored, GoalsConceded)

# combine home and away dfs
x.data <- rbind(x.home, x.away) %>%
  mutate(played = 1) %>%
  arrange(Date, GameID) %>%
  # logic for calculating goal differential and points earned
  mutate(GoalDifferential = GoalsScored - GoalsConceded,
         PointsEarned = if_else(GoalsScored > GoalsConceded, 3,
                        if_else(GoalsScored < GoalsConceded, 0, 1))) %>%
  group_by(Team) %>%
  # create week number
  mutate(Week = row_number()) %>%
  ungroup()

# create a week df to complete
x.week.teams <-
  data.frame(Week = seq(1, max(x.data$Week), 1)) %>%
  mutate(k = 1) %>%
  inner_join(x.premier.league.clubs %>%
               mutate(k = 1),
             by = 'k') %>%
  select(-k)

# aggregate totals by team
x.data %<>%
  right_join(x.week.teams,
            by = c("Week", "Team")) %>%
  arrange(Date, GameID) %>%
  mutate(PointsEarned = if_else(is.na(PointsEarned), 0, PointsEarned),
         GoalsScored = if_else(is.na(GoalsScored), 0, GoalsScored),
         GoalsConceded = if_else(is.na(GoalsConceded), 0, GoalsConceded),
         GoalDifferential = if_else(is.na(GoalDifferential), 0, GoalDifferential)) %>%
  group_by(Team) %>%
  mutate(PointsTally = cumsum(PointsEarned),
         GoalsScoredTally = cumsum(GoalsScored),
         GoalsConcededTally = cumsum(GoalsConceded),
         GoalDifferentialTally = cumsum(GoalDifferential))

# determine league position by week
x.rank <-
  x.data %>%
  group_by(Week) %>%
  arrange(desc(PointsTally), desc(GoalDifferentialTally), desc(GoalsScoredTally)) %>%
  # create league position
  mutate(Position = row_number()) %>%
  ungroup() 

# combine home and away dfs for 10 year data update_me
x.data.10yr <- rbind(x.home.10yr, x.away.10yr) %>%
  # filter to only champions
  filter(Team %in% c(
    'Liverpool2324',
    'ManCity2223',
    'ManCity2122',
    'ManCity2021',
    'Liverpool1920',
    'ManCity1819',
    'ManCity1718',
    'Chelsea1617',
    'Leicester1516',
    'Chelsea1415',
    'ManCity1314',
    'ManUnited1213',
    'ManCity1112',
    'ManUnited1011',
    'Chelsea0910')) %>%
  arrange(Date, GameID) %>%
  # logic for calculating goal differential and points earned
  mutate(GoalDifferential = GoalsScored - GoalsConceded,
         PointsEarned = if_else(GoalsScored > GoalsConceded, 3,
                        if_else(GoalsScored < GoalsConceded, 0, 1))) %>%
  group_by(Team) %>%
  # create week number and cumulative sums
  mutate(Week = row_number(),
         PointsTally = cumsum(PointsEarned),
         GoalsScoredTally = cumsum(GoalsScored),
         GoalsConcededTally = cumsum(GoalsConceded),
         GoalDifferentialTally = cumsum(GoalDifferential)) %>%
  ungroup() %>%
  group_by(Week) %>%
  arrange(desc(PointsTally), desc(GoalDifferentialTally), desc(GoalsScoredTally)) %>%
  # create league position
  mutate(Position = row_number()) %>%
  ungroup()

# graph looks better starting from a common point of 0
x.week.zero <-
  x.data %>%
  select(Team) %>%
  distinct() %>%
  mutate(Week = 0,
         PointsTally = 0) %>%
  spread(Team, PointsTally)
x.week.zero.10yr <-
  x.data.10yr %>%
  select(Team) %>%
  distinct() %>%
  mutate(Week = 0,
         PointsTally = 0) %>%
  spread(Team, PointsTally)
x.week.zero.gd <-
  x.data %>%
  select(Team) %>%
  distinct() %>%
  mutate(Week = 0,
         GoalDifferentialTally = 0) %>%
  spread(Team, GoalDifferentialTally)

# data for points by week graph
pbw.data <-
  x.data %>%
  filter(!is.na(played)) %>%
  select(Week, Team, PointsTally) %>%
  spread(Team, PointsTally) %>%
  bind_rows(x.week.zero) %>%
  arrange(Week)

# data for points by week graph (10 years)
pbw.data.10yr <-
  x.data.10yr %>%
  select(Week, Team, PointsTally) %>%
  spread(Team, PointsTally) %>%
  bind_rows(x.week.zero) %>%
  arrange(Week)

# data for goal differential by week graph
gdbw.data <-
  x.data %>%
  filter(!is.na(played)) %>%
  select(Week, Team, GoalDifferentialTally) %>%
  spread(Team, GoalDifferentialTally) %>%
  bind_rows(x.week.zero.gd) %>%
  arrange(Week)

# data for rank by week graph
rbw.data <-
  x.rank %>%
  select(Week, Team, Position) %>%
  spread(Team, Position) %>%
  arrange(Week)

# determine current league position for each team
x.current.rank <-
  x.data %>%
  group_by(Team) %>%
  filter(Week == max(Week)) %>%
  ungroup() %>%
  select(Team, GoalsScoredTally, GoalsConcededTally, GoalDifferentialTally, PointsTally) %>%
  arrange(desc(PointsTally), desc(GoalDifferentialTally), desc(GoalsScoredTally)) %>%
  # create league position
  mutate(Position = row_number()) %>%
  select(Team, Position)

# collect remaining fixtures
x.remaining.fixtures <-
  x.fixture.list %>%
  filter(is.na(played)) %>%
  select(-played) %>%
  left_join(x.current.rank %>%
              rename(HomePosition = Position),
            by = c("HomeTeam" = "Team")) %>%
  left_join(x.current.rank %>%
              rename(AwayPosition = Position),
            by = c("AwayTeam" = "Team"))

# join league position
x.strength.of.schedule <-
  x.remaining.fixtures %>%
  select(HomeTeam, AwayPosition) %>%
  rename(Team = HomeTeam,
         Position = AwayPosition) %>%
  bind_rows(x.remaining.fixtures %>%
              select(AwayTeam, HomePosition) %>%
              rename(Team = AwayTeam,
                     Position = HomePosition)) %>%
  arrange(Team, desc(Position)) %>%
  group_by(Team) %>%
  mutate(Week = row_number()) %>%
  ungroup()

# data for remaining opponent graph
orbw.data <- 
  x.strength.of.schedule %>%
  select(Team, Week, Position) %>%
  spread(Team, Position) %>%
  arrange(Week)

# data for animated points by week
apbw.data <-
  pbw.data %>%
  gather("Team", "Points", Arsenal:Wolves) %>%
  inner_join(x.premier.league.clubs,
             by = 'Team') %>%
  arrange(Team, Week)

# create vector for team colors
teamcolors <- 
  apbw.data %>%
  select(TeamColor) %>%
  distinct() %>%
  pull()

# helper function to create frames for animation
accumulate_by <- function(dat, var) {
  var <- lazyeval::f_eval(var, dat)
  lvls <- plotly:::getLevels(var)
  dats <- lapply(seq_along(lvls), function(x) {
    cbind(dat[var %in% lvls[seq(1, x)], ], frame = lvls[[x]])
  })
  dplyr::bind_rows(dats)
}

# create animation frames
apbw.data %<>%
  accumulate_by(~Week)

x.team.stats <-
  x.spi.538 %>%
  mutate(p_score_0 = dpois(0, lambda = off),
         p_score_1 = dpois(1, lambda = off),
         p_score_2 = dpois(2, lambda = off),
         p_score_3 = dpois(3, lambda = off),
         p_score_4 = dpois(4, lambda = off),
         p_score_5 = dpois(5, lambda = off),
         p_score_6 = dpois(6, lambda = off),
         p_score_7 = dpois(7, lambda = off),
         p_score_8 = dpois(8, lambda = off)) %>%
  inner_join(x.premier.league.clubs %>%
               select(-TeamColor),
             by = 'Team_538') %>%
  select(-Team_538) 

# add stats to past fixtures
x.past.fixtures <-
  x.current.data %>%
  select(HomeTeam, AwayTeam) %>%
  inner_join(x.team.stats %>%
               select(Team, 
                      p_score_0, p_score_1, p_score_2, p_score_3, 
                      p_score_4, p_score_5, p_score_6, p_score_7, p_score_8) %>%
               rename(HomeTeam = Team,
                      Home_score_0 = p_score_0, 
                      Home_score_1 = p_score_1, 
                      Home_score_2 = p_score_2, 
                      Home_score_3 = p_score_3, 
                      Home_score_4 = p_score_4, 
                      Home_score_5 = p_score_5,
                      Home_score_6 = p_score_6, 
                      Home_score_7 = p_score_7, 
                      Home_score_8 = p_score_8),
             by = 'HomeTeam') %>%
  inner_join(x.team.stats %>%
               select(Team, 
                      p_score_0, p_score_1, p_score_2, p_score_3, 
                      p_score_4, p_score_5, p_score_6, p_score_7, p_score_8) %>%
               rename(AwayTeam = Team,
                      Away_score_0 = p_score_0, 
                      Away_score_1 = p_score_1, 
                      Away_score_2 = p_score_2, 
                      Away_score_3 = p_score_3, 
                      Away_score_4 = p_score_4, 
                      Away_score_5 = p_score_5,
                      Away_score_6 = p_score_6, 
                      Away_score_7 = p_score_7, 
                      Away_score_8 = p_score_8),
             by = 'AwayTeam') 

# add stats to remaining fixtures
x.remaining.fixtures %<>%
  select(HomeTeam, AwayTeam) %>%
  inner_join(x.team.stats %>%
               select(Team, 
                      p_score_0, p_score_1, p_score_2, p_score_3, 
                      p_score_4, p_score_5, p_score_6, p_score_7, p_score_8) %>%
               rename(HomeTeam = Team,
                      Home_score_0 = p_score_0, 
                      Home_score_1 = p_score_1, 
                      Home_score_2 = p_score_2, 
                      Home_score_3 = p_score_3, 
                      Home_score_4 = p_score_4, 
                      Home_score_5 = p_score_5,
                      Home_score_6 = p_score_6, 
                      Home_score_7 = p_score_7, 
                      Home_score_8 = p_score_8),
             by = 'HomeTeam') %>%
  inner_join(x.team.stats %>%
               select(Team, 
                      p_score_0, p_score_1, p_score_2, p_score_3, 
                      p_score_4, p_score_5, p_score_6, p_score_7, p_score_8) %>%
               rename(AwayTeam = Team,
                      Away_score_0 = p_score_0, 
                      Away_score_1 = p_score_1, 
                      Away_score_2 = p_score_2, 
                      Away_score_3 = p_score_3, 
                      Away_score_4 = p_score_4, 
                      Away_score_5 = p_score_5,
                      Away_score_6 = p_score_6, 
                      Away_score_7 = p_score_7, 
                      Away_score_8 = p_score_8),
             by = 'AwayTeam') 

# calculate test matrix 
x.predicted.past.fixtures <-
  x.past.fixtures %>%
  gather(key = "Home_score_n", value = "Home_score", starts_with("Home_")) %>%
  gather(key = "Away_score_n", value = "Away_score", starts_with("Away_")) %>%
  mutate(probability = 
           if_else(str_extract(Home_score_n, '\\d') == str_extract(Away_score_n, '\\d'),
                   2*Home_score*Away_score,
                   Home_score*Away_score)) %>%
  mutate(result = paste("Home", 
                        str_extract(Home_score_n, '\\d'), "Away", 
                        str_extract(Away_score_n, '\\d'), sep = "_")) %>%
  mutate(GameID = paste0(HomeTeam, AwayTeam)) %>%
  select(GameID, HomeTeam, AwayTeam, probability, result) %>%
  separate(result, c("text1", "P_FTHG", "text2", "P_FTAG"), "_") %>%
  select(-text1, -text2) %>%
  mutate(P_FTHG = as.numeric(P_FTHG),
         P_FTAG = as.numeric(P_FTAG)) %>%
  mutate(HomePoints_pred = if_else(P_FTHG > P_FTAG, 3,
                                   if_else(P_FTHG < P_FTAG, 0, 1)),
         AwayPoints_pred = if_else(P_FTHG < P_FTAG, 3,
                                   if_else(P_FTHG > P_FTAG, 0, 1))) %>%
  group_by(GameID, HomeTeam, AwayTeam, HomePoints_pred, AwayPoints_pred) %>%
  summarise(p_sum = sum(probability)) %>%
  ungroup() %>%
  # Tie in probability gives home advantage
  arrange(GameID, desc(p_sum), desc(HomePoints_pred)) %>%
  group_by(GameID) %>%
  slice(1) %>%
  ungroup() %>%
  inner_join(x.current.data %>%
               select(GameID, FTHG, FTAG),
             by = 'GameID') %>%
  mutate(HomePoints_act = if_else(FTHG > FTAG, 3,
                                  if_else(FTHG < FTAG, 0, 1)),
         AwayPoints_act = if_else(FTHG < FTAG, 3,
                                  if_else(FTHG > FTAG, 0, 1))) %>%
  select(GameID, HomePoints_pred, HomePoints_act, FTHG, FTAG) %>%
  inner_join(x.match_pred.538,
             by = 'GameID') %>%
  mutate(HomePoints_pred.538 = if_else(prob1 > prob2 & prob1 > probtie, 3,
                                       if_else(prob2 > prob1 & prob2 > probtie, 0, 1))) %>%
  inner_join(x.past.fixtures %>%
               gather(key = "Home_score_n", value = "Home_score", starts_with("Home_")) %>%
               gather(key = "Away_score_n", value = "Away_score", starts_with("Away_")) %>%
               mutate(probability = Home_score*Away_score) %>%
               mutate(result = paste("Home",
                                     str_extract(Home_score_n, '\\d'), "Away",
                                     str_extract(Away_score_n, '\\d'), sep = "_")) %>%
               mutate(GameID = paste0(HomeTeam, AwayTeam)) %>%
               select(GameID, HomeTeam, AwayTeam, probability, result) %>%
               separate(result, c("text1", "P_FTHG", "text2", "P_FTAG"), "_") %>%
               select(-text1, -text2) %>%
               mutate(P_FTHG = as.numeric(P_FTHG),
                      P_FTAG = as.numeric(P_FTAG)) %>%
               mutate(HomePoints_pred.nodraw = if_else(P_FTHG > P_FTAG, 3,
                                                       if_else(P_FTHG < P_FTAG, 0, 1)),
                      AwayPoints_pred.nodraw = if_else(P_FTHG < P_FTAG, 3,
                                                       if_else(P_FTHG > P_FTAG, 0, 1))) %>%
               filter(HomePoints_pred.nodraw != 1) %>%
               group_by(GameID, HomePoints_pred.nodraw, AwayPoints_pred.nodraw) %>%
               summarise(p_sum = sum(probability)) %>%
               ungroup() %>%
               # Tie in probability gives home advantage
               arrange(GameID, desc(p_sum), desc(HomePoints_pred.nodraw)) %>%
               group_by(GameID) %>%
               slice(1) %>%
               ungroup(),
             by = 'GameID')

prop <- with(x.predicted.past.fixtures, table(HomePoints_act, HomePoints_pred)) %>%
  prop.table()
prop

prop <- with(x.predicted.past.fixtures, table(HomePoints_act, HomePoints_pred.538)) %>%
  prop.table()
prop

prop <- with(x.predicted.past.fixtures, table(HomePoints_act, HomePoints_pred.nodraw)) %>%
  prop.table()
prop

# calculate result matrix 
x.predicted.remaining.fixtures <-
  x.remaining.fixtures %>%
  gather(key = "Home_score_n", value = "Home_score", starts_with("Home_")) %>%
  gather(key = "Away_score_n", value = "Away_score", starts_with("Away_")) %>%
  mutate(probability = 
           if_else(str_extract(Home_score_n, '\\d') == str_extract(Away_score_n, '\\d'),
                   2*Home_score*Away_score,
                   Home_score*Away_score)) %>%
  mutate(result = paste("Home", 
                        str_extract(Home_score_n, '\\d'), "Away", 
                        str_extract(Away_score_n, '\\d'), sep = "_")) %>%
  mutate(GameID = paste0(HomeTeam, AwayTeam)) %>%
  select(GameID, HomeTeam, AwayTeam, probability, result) %>%
  separate(result, c("text1", "P_FTHG", "text2", "P_FTAG"), "_") %>%
  select(-text1, -text2) %>%
  mutate(P_FTHG = as.numeric(P_FTHG),
         P_FTAG = as.numeric(P_FTAG)) %>%
  mutate(HomePoints = if_else(P_FTHG > P_FTAG, 3,
                              if_else(P_FTHG < P_FTAG, 0, 1)),
         AwayPoints = if_else(P_FTHG < P_FTAG, 3,
                              if_else(P_FTHG > P_FTAG, 0, 1))) %>%
  group_by(GameID, HomeTeam, AwayTeam, HomePoints, AwayPoints) %>%
  summarise(p_sum = sum(probability)) %>%
  ungroup() %>%
  # Tie in probability gives home advantage
  arrange(GameID, desc(p_sum), desc(HomePoints)) %>%
  group_by(GameID) %>%
  slice(1) %>%
  ungroup()

# add predicted results to actual results
ppbw.data <-
  x.predicted.remaining.fixtures %>%
  select(HomeTeam, HomePoints) %>%
  rename(Team = HomeTeam, PointsEarned = HomePoints) %>%
  bind_rows(x.predicted.remaining.fixtures %>%
              select(AwayTeam, AwayPoints) %>%
              rename(Team = AwayTeam, PointsEarned = AwayPoints)) %>%
  arrange(Team, PointsEarned) %>%
  group_by(Team) %>%
  mutate(Week = 39 - row_number()) %>%
  ungroup() %>%
  bind_rows(x.data %>%
              filter(!is.na(played)) %>%
              select(Week, Team, PointsEarned)) %>%
  arrange(Team, Week) %>%
  group_by(Team) %>%
  mutate(PointsTally = cumsum(PointsEarned)) %>%
  select(-PointsEarned) %>%
  spread(Team, PointsTally)

# goals scored by team
gsbt.data <-
  x.data %>%
  mutate(GoalsScored = if_else(is.na(played), NA_real_, GoalsScored)) %>%
  select(Week, Team, GoalsScored) %>%
  arrange(Team) %>%
  spread(Team, GoalsScored)

# goals conceded by team
gcbt.data <-
  x.data %>%
  mutate(GoalsConceded = if_else(is.na(played), NA_real_, GoalsConceded)) %>%
  select(Week, Team, GoalsConceded) %>%
  arrange(Team) %>%
  spread(Team, GoalsConceded)

# goal differential by team
gdbt.data <-
  x.data %>%
  mutate(GoalsScored = if_else(is.na(played), NA_real_, GoalsScored),
         GoalsConceded = if_else(is.na(played), NA_real_, GoalsConceded)) %>%
  mutate(GoalDifferential = GoalsScored - GoalsConceded) %>%
  select(Week, Team, GoalDifferential) %>%
  arrange(Team) %>%
  spread(Team, GoalDifferential)

# remove unnecessary objects
rm(list = ls(pattern = "^x"))
rm(list = ls(pattern = "^y"))

