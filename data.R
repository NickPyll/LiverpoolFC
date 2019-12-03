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

########## Load Current Season ####

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

x.current.data <- 
  x.1920 %>%
  select(Date, HomeTeam, AwayTeam, FTHG, FTAG)

# see when data was last updated
max(as.Date(as.character(x.current.data$Date), format = '%d/%m/%Y'))

# premier league clubs
x.premier.league.clubs <-
  tribble(
    ~Team,
    'Arsenal', 'Aston Villa', 'Bournemouth', 'Brighton', 'Burnley', 'Chelsea', 
    'Crystal Palace', 'Everton', 'Leicester', 'Liverpool', 'Man City', 'Man United', 
    'Newcastle', 'Norwich', 'Sheffield United', 'Southampton', 'Tottenham', 'Watford', 
    'West Ham', 'Wolves')

x.fixture.list <- 
  x.premier.league.clubs %>%
  rename(HomeTeam = Team) %>%
  mutate(k = 1) %>%
  inner_join(x.premier.league.clubs %>%
                 rename(AwayTeam = Team) %>%
                 mutate(k = 1),
             by = 'k') %>%
  select(-k) %>%
  filter(HomeTeam != AwayTeam) %>%
  left_join(x.1920 %>%
              select(HomeTeam, AwayTeam) %>%
              mutate(played = 1), 
             by = c('HomeTeam', 'AwayTeam'))

########## Load Historical Data ####
# data for Liverpool league position by year
x.liverpool.league.history <-
  tribble(
    ~Year, ~Position, ~League, ~NumTeamsFirstDiv, ~NumTeamsSecondDiv,
    1893, 1, 3, 16, 12,
    1894, 1, 2, 16, 15,
    1895, 16, 1, 16, 16,
    1896, 1, 2, 16, 16,
    1897, 5, 1, 16, 16,
    1898, 9, 1, 16, 16,
    1899, 2, 1, 18, 18,
    1900, 10, 1, 18, 18,
    1901, 1, 1, 18, 18,
    1902, 11, 1, 18, 18,
    1903, 5, 1, 18, 18,
    1904, 17, 1, 18, 18,
    1905, 1, 2, 18, 18,
    1906, 1, 1, 20, 20, 
    1907, 15, 1, 20, 20,
    1908, 8, 1, 20, 20,
    1909, 16, 1, 20, 20,
    1910, 2, 1, 20, 20,
    1911, 13, 1, 20, 20,
    1912, 17, 1, 20, 20,
    1913, 12, 1, 20, 20,
    1914, 16, 1, 20, 20,
    1915, 13, 1, 20, 20,
    1916, NA, NA, 20, 20,
    1917, NA, NA, 20, 20,
    1918, NA, NA, 20, 20,
    1919, NA, NA, 22, 22,
    1920, 4, 1, 22, 22,
    1921, 4, 1, 22, 22,
    1922, 1, 1, 22, 22,
    1923, 1, 1, 22, 22,
    1924, 12, 1, 22, 22,
    1925, 4, 1, 22, 22,
    1926, 7, 1, 22, 22,
    1927, 9, 1, 22, 22,
    1928, 16, 1, 22, 22,
    1929, 4, 1, 22, 22,
    1930, 12, 1, 22, 22,
    1931, 9, 1, 22, 22,
    1932, 10, 1, 22, 22,
    1933, 14, 1, 22, 22,
    1934, 18, 1, 22, 22,
    1935, 7, 1, 22, 22,
    1936, 19, 1, 22, 22,
    1937, 18, 1, 22, 22,
    1938, 11, 1, 22, 22,
    1939, 11, 1, 22, 22,
    1940, NA, NA, 22, 22,
    1941, NA, NA, 22, 22,
    1942, NA, NA, 22, 22,
    1943, NA, NA, 22, 22,
    1944, NA, NA, 22, 22,
    1945, NA, NA, 22, 22,
    1946, NA, NA, 22, 22,
    1947, 1, 1, 22, 22,
    1948, 11, 1, 22, 22,
    1949, 12, 1, 22, 22,
    1950, 8, 1, 22, 22,
    1951, 9, 1, 22, 22,
    1952, 11, 1, 22, 22,
    1953, 17, 1, 22, 22,
    1954, 22, 1, 22, 22,
    1955, 11, 2, 22, 22,
    1956, 3, 2, 22, 22,
    1957, 3, 2, 22, 22,
    1958, 4, 2, 22, 22,
    1959, 4, 2, 22, 22,
    1960, 3, 2, 22, 22,
    1961, 3, 2, 22, 22,
    1962, 1, 2, 22, 22,
    1963, 8, 1, 22, 22,
    1964, 1, 1, 22, 22,
    1965, 7, 1, 22, 22,
    1966, 1, 1, 22, 22,
    1967, 5, 1, 22, 22,
    1968, 3, 1, 22, 22,
    1969, 2, 1, 22, 22,
    1970, 5, 1, 22, 22,
    1971, 5, 1, 22, 22,
    1972, 3, 1, 22, 22,
    1973, 1, 1, 22, 22,
    1974, 2, 1, 22, 22,
    1975, 2, 1, 22, 22,
    1976, 1, 1, 22, 22,
    1977, 1, 1, 22, 22,
    1978, 2, 1, 22, 22,
    1979, 1, 1, 22, 22,
    1980, 1, 1, 22, 22,
    1981, 5, 1, 22, 22,
    1982, 1, 1, 22, 22,
    1983, 1, 1, 22, 22,
    1984, 1, 1, 22, 22,
    1985, 2, 1, 22, 22,
    1986, 1, 1, 22, 22,
    1987, 2, 1, 21, 22,
    1988, 1, 1, 20, 22, 
    1989, 2, 1, 20, 22,
    1990, 1, 1, 20, 22,
    1991, 2, 1, 20, 22,
    1992, 6, 1, 22, 22,
    1993, 6, 1, 22, 22, 
    1994, 8, 1, 22, 22,
    1995, 4, 1, 22, 22,
    1996, 3, 1, 20, 22,
    1997, 4, 1, 20, 22,
    1998, 3, 1, 20, 22,
    1999, 7, 1, 20, 22,
    2000, 4, 1, 20, 22,
    2001, 3, 1, 20, 22,
    2002, 2, 1, 20, 22,
    2003, 5, 1, 20, 22,
    2004, 4, 1, 20, 22,
    2005, 5, 1, 20, 22,
    2006, 3, 1, 20, 22,
    2007, 3, 1, 20, 22,
    2008, 4, 1, 20, 22,
    2009, 2, 1, 20, 22,
    2010, 7, 1, 20, 22,
    2011, 6, 1, 20, 22,
    2012, 8, 1, 20, 22,
    2013, 7, 1, 20, 22,
    2014, 2, 1, 20, 22,
    2015, 6, 1, 20, 22,
    2016, 8, 1, 20, 22,
    2017, 4, 1, 20, 22,
    2018, 4, 1, 20, 22,
    2019, 2, 1, 20, 22
  )

########## Data Transformation ####
# logic for identifying champions and actual position
rby.data <-
  x.liverpool.league.history %>%
  mutate(ActualPosition = if_else(League == 1, Position,
                                  ifelse(League == 2, Position + NumTeamsFirstDiv,
                                         Position + NumTeamsFirstDiv + NumTeamsSecondDiv))) %>%
  mutate(Champions = if_else(Position == 1, ActualPosition, NA_real_))

# format variables and create GameID
x.current.data %<>%
  mutate(
    GameID = paste0(HomeTeam, AwayTeam),
    Date = as.Date(as.character(Date), format = '%d/%m/%Y'))
x.1920 %<>%
  select(Date, HomeTeam, AwayTeam, FTHG, FTAG) %>%
  filter(HomeTeam == 'Liverpool' | AwayTeam == 'Liverpool') %>%
  mutate(
    Date = as.Date(as.character(Date), format = '%d/%m/%Y'),
    GameID = paste0(HomeTeam, AwayTeam),
    HomeTeam = paste0(as.character(HomeTeam), '1920'),
    AwayTeam = paste0(as.character(AwayTeam), '1920'),
    Season = '1920')
x.1819 %<>%
  select(Date, HomeTeam, AwayTeam, FTHG, FTAG) %>%
  filter(HomeTeam == 'Man City' | AwayTeam == 'Man City') %>%
  mutate(
    Date = as.Date(as.character(Date), format = '%d/%m/%Y'),
    GameID = paste0(HomeTeam, AwayTeam),
    HomeTeam = paste0(as.character(HomeTeam), '1819'),
    AwayTeam = paste0(as.character(AwayTeam), '1819'),
    Season = '1819') 
x.1718 %<>%
  select(Date, HomeTeam, AwayTeam, FTHG, FTAG) %>%
  filter(HomeTeam == 'Man City' | AwayTeam == 'Man City') %>%
  mutate(
    Date = as.Date(as.character(Date), format = '%d/%m/%Y'),
    GameID = paste0(HomeTeam, AwayTeam),
    HomeTeam = paste0(as.character(HomeTeam), '1718'),
    AwayTeam = paste0(as.character(AwayTeam), '1718'),
    Season = '1718') 
x.1617 %<>%
  select(Date, HomeTeam, AwayTeam, FTHG, FTAG) %>%
  filter(HomeTeam == 'Chelsea' | AwayTeam == 'Chelsea') %>%
  mutate(
    Date = as.Date(as.character(Date), format = '%d/%m/%y'),
    GameID = paste0(HomeTeam, AwayTeam),
    HomeTeam = paste0(as.character(HomeTeam), '1617'),
    AwayTeam = paste0(as.character(AwayTeam), '1617'),
    Season = '1617') 
x.1516 %<>%
  select(Date, HomeTeam, AwayTeam, FTHG, FTAG) %>%
  filter(HomeTeam == 'Leicester' | AwayTeam == 'Leicester') %>%
  mutate(
    Date = as.Date(as.character(Date), format = '%d/%m/%y'),
    GameID = paste0(HomeTeam, AwayTeam),
    HomeTeam = paste0(as.character(HomeTeam), '1516'),
    AwayTeam = paste0(as.character(AwayTeam), '1516'),
    Season = '1516') 
x.1415 %<>%
  select(Date, HomeTeam, AwayTeam, FTHG, FTAG) %>%
  filter(HomeTeam == 'Chelsea' | AwayTeam == 'Chelsea') %>%
  mutate(
    Date = as.Date(as.character(Date), format = '%d/%m/%y'),
    GameID = paste0(HomeTeam, AwayTeam),
    HomeTeam = paste0(as.character(HomeTeam), '1415'),
    AwayTeam = paste0(as.character(AwayTeam), '1415'),
    Season = '1415') 
x.1314 %<>%
  select(Date, HomeTeam, AwayTeam, FTHG, FTAG) %>%
  filter(HomeTeam == 'Man City' | AwayTeam == 'Man City') %>%
  mutate(
    Date = as.Date(as.character(Date), format = '%d/%m/%y'),
    GameID = paste0(HomeTeam, AwayTeam),
    HomeTeam = paste0(as.character(HomeTeam), '1314'),
    AwayTeam = paste0(as.character(AwayTeam), '1314'),
    Season = '1314') 
x.1213 %<>%
  select(Date, HomeTeam, AwayTeam, FTHG, FTAG) %>%
  filter(HomeTeam == 'Man United' | AwayTeam == 'Man United') %>%
  mutate(
    Date = as.Date(as.character(Date), format = '%d/%m/%y'),
    GameID = paste0(HomeTeam, AwayTeam),
    HomeTeam = paste0(as.character(HomeTeam), '1213'),
    AwayTeam = paste0(as.character(AwayTeam), '1213'),
    Season = '1213') 
x.1112 %<>%
  select(Date, HomeTeam, AwayTeam, FTHG, FTAG) %>%
  filter(HomeTeam == 'Man City' | AwayTeam == 'Man City') %>%
  mutate(
    Date = as.Date(as.character(Date), format = '%d/%m/%y'),
    GameID = paste0(HomeTeam, AwayTeam),
    HomeTeam = paste0(as.character(HomeTeam), '1112'),
    AwayTeam = paste0(as.character(AwayTeam), '1112'),
    Season = '1112') 
x.1011 %<>%
  select(Date, HomeTeam, AwayTeam, FTHG, FTAG) %>%
  filter(HomeTeam == 'Man United' | AwayTeam == 'Man United') %>%
  mutate(
    Date = as.Date(as.character(Date), format = '%d/%m/%y'),
    GameID = paste0(HomeTeam, AwayTeam),
    HomeTeam = paste0(as.character(HomeTeam), '1011'),
    AwayTeam = paste0(as.character(AwayTeam), '1011'),
    Season = '1011') 
x.0910 %<>%
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
  rbind(x.1920, x.1819, x.1718, x.1617, x.1516, x.1415, x.1314, x.1213, x.1112, x.1011, x.0910)

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
  mutate(Team = str_trim(gsub(" ", "", Team)),
         GoalDifferential = GoalsScored - GoalsConceded,
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
               mutate(Team = str_trim(gsub(" ", "", Team)),
                      k = 1),
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
  mutate(Position = row_number(),
         Team = str_trim(gsub(" ", "", Team))) %>%
  ungroup() 

# combine home and away dfs for 10 year data
x.data.10yr <- rbind(x.home.10yr, x.away.10yr) %>%
  # filter to only champions
  filter(Team %in% c('Liverpool1920',
                     'Man City1819',
                     'Man City1718',
                     'Chelsea1617',
                     'Leicester1516',
                     'Chelsea1415',
                     'Man City1314',
                     'Man United1213',
                     'Man City1112',
                     'Man United1011',
                     'Chelsea0910')) %>%
  arrange(Date, GameID) %>%
  # logic for calculatiung goal differential and points earned
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
  mutate(Position = row_number(),
         Team = str_trim(gsub(" ", "", Team))) %>%
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
  mutate(HomeTeam = str_trim(gsub(" ", "", HomeTeam)),  
         AwayTeam = str_trim(gsub(" ", "", AwayTeam))) %>%
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

# remove unnecessary objects
rm(list = ls(pattern = "^x"))
rm(list = ls(pattern = "^json"))