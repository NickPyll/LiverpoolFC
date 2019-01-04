# read current season
# x.data <- read.csv(url(json_data$resources$path[2]))
x.data <- read.csv('season-1819_csv.csv')
x.data %<>%
  mutate(
    Date = as.Date(as.character(Date), format = '%m/%d/%y')) 


# read last 10 seasons
# x.1819 <- read.csv(url(json_data$resources$path[2]))
x.1819 <- read.csv('season-1819_csv.csv')
x.1819 %<>%
  mutate(
    Date = as.Date(as.character(Date), format = '%m/%d/%y')) 
x.1718 <- read.csv(url(json_data$resources$path[3]))
x.1617 <- read.csv(url(json_data$resources$path[4]))
x.1516 <- read.csv(url(json_data$resources$path[5]))
x.1415 <- read.csv(url(json_data$resources$path[6]))
x.1314 <- read.csv(url(json_data$resources$path[7]))
x.1213 <- read.csv(url(json_data$resources$path[8]))
x.1112 <- read.csv(url(json_data$resources$path[9]))
x.1011 <- read.csv(url(json_data$resources$path[10]))
x.0910 <- read.csv(url(json_data$resources$path[11]))

########## Manual Entry Data ####

# see when data was last updated
# max(as.Date(as.character(x.data$Date), format = '%Y-%m-%d'))
max(as.Date(as.character(x.data$Date), format = '%m/%d/%y'))

# manually enter updated data
x.data.update.10yr <-
  tribble(
    ~Date, ~HomeTeam, ~AwayTeam, ~FTHG, ~FTAG,
    '2018-12-21', 'Wolves', 'Liverpool', 0, 2,
    '2018-12-26', 'Liverpool', 'Newcastle', 4, 0,
    '2018-12-29', 'Liverpool', 'Arsenal', 5, 1,
    '2019-01-03', 'Man City', 'Liverpool', 2, 1
  )

x.data.update.10yr %<>%
  mutate(
    Date = as.Date(as.character(Date), format = '%Y-%m-%d'))

# add the updated data
x.1819 %<>%
  bind_rows(x.data.update.10yr)

# manually enter updated data
x.data.update <-
  tribble(
    ~Date, ~HomeTeam, ~AwayTeam, ~FTHG, ~FTAG,
    '2018-12-21', 'Wolves', 'Liverpool', 0, 2,
    '2018-12-22', 'Arsenal', 'Burnley', 3, 1,
    '2018-12-22', 'Huddersfield', 'Southampton', 1, 3,
    '2018-12-22', 'Bournemouth', 'Brighton', 2, 0,
    '2018-12-22', 'Man City', 'Crystal Palace', 2, 3,
    '2018-12-22', 'Newcastle', 'Fulham', 0, 0,
    '2018-12-22', 'Chelsea', 'Leicester', 0, 1,
    '2018-12-22', 'West Ham', 'Watford', 0, 2,
    '2018-12-22', 'Cardiff', 'Man United', 1, 5,
    '2018-12-23', 'Everton', 'Tottenham', 2, 6,
    '2018-12-26', 'Fulham', 'Wolves', 1, 1,
    '2018-12-26', 'Burnley', 'Everton', 1, 5,
    '2018-12-26', 'Liverpool', 'Newcastle', 4, 0,
    '2018-12-26', 'Crystal Palace', 'Cardiff', 0, 0,
    '2018-12-26', 'Leicester', 'Man City', 2, 1,
    '2018-12-26', 'Tottenham', 'Bournemouth', 5, 0,
    '2018-12-26', 'Man United', 'Huddersfield', 3, 1,
    '2018-12-26', 'Brighton', 'Arsenal', 1, 1,
    '2018-12-26', 'Watford', 'Chelsea', 1, 2,
    '2018-12-27', 'Southampton', 'West Ham', 1, 2,
    '2018-12-29', 'Watford', 'Newcastle', 1, 1,
    '2018-12-29', 'Brighton', 'Everton', 1, 0,
    '2018-12-29', 'Tottenham', 'Wolves', 1, 3,
    '2018-12-29', 'Fulham', 'Huddersfield', 1, 0, 
    '2018-12-29', 'Leicester', 'Cardiff', 0, 1,
    '2018-12-29', 'Liverpool', 'Arsenal', 5, 1,
    '2018-12-30', 'Crystal Palace', 'Chelsea', 0, 1,
    '2018-12-30', 'Southampton', 'Man City', 1, 3,
    '2018-12-30', 'Burnley', 'West Ham', 2, 0,
    '2018-12-30', 'Man United', 'Bournemouth', 4, 1,
    '2019-01-01', 'Everton', 'Leicester', 0, 1,
    '2019-01-01', 'Arsenal', 'Fulham', 4, 1,
    '2019-01-01', 'Cardiff', 'Tottenham', 0, 3,
    '2019-01-02', 'Wolves', 'Crystal Palace', 0, 2,
    '2019-01-02', 'Chelsea', 'Southampton', 0, 0,
    '2019-01-02', 'West Ham', 'Brighton', 2, 2,
    '2019-01-02', 'Huddersfield', 'Burnley', 1, 2,
    '2019-01-02', 'Newcastle', 'Man United', 0, 2,
    '2019-01-02', 'Bournemouth', 'Watford', 3, 3,
    '2019-01-03', 'Man City', 'Liverpool', 2, 1
  )

x.data.update %<>%
  mutate(
    Date = as.Date(as.character(Date), format = '%Y-%m-%d'))

# add the updated data
x.data %<>%
  bind_rows(x.data.update) 

# data for Liverpool league position by year
liverpool.league.history <-
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
    2019, NA, 1, 20, 22
  )

########## Data Transformation ####

# logic for identifyign champions and actual position
liverpool.league.history %<>%
  mutate(ActualPosition = if_else(League == 1, Position,
                                  ifelse(League == 2, Position + NumTeamsFirstDiv,
                                         Position + NumTeamsFirstDiv + NumTeamsSecondDiv))) %>%
  mutate(Champions = if_else(Position == 1, ActualPosition, NA_real_))

# format variables and create GameID
x.data %<>%
  mutate(
    # Date = as.Date(as.character(Date), format = '%Y-%m-%d'),
    # Date = as.Date(as.character(Date), format = '%m/%d/%y'),
    GameID = paste0(HomeTeam, AwayTeam),
    HomeTeam = as.character(HomeTeam),
    AwayTeam = as.character(AwayTeam)) 
x.1819 %<>%
  filter(HomeTeam == 'Liverpool' | AwayTeam == 'Liverpool') %>%
  mutate(
    # Date = as.Date(as.character(Date), format = '%Y-%m-%d'),
    # Date = as.Date(as.character(Date), format = '%m/%d/%y'),
    HomeTeam = paste0(as.character(HomeTeam), '1819'),
    AwayTeam = paste0(as.character(AwayTeam), '1819'),
    GameID = paste0(HomeTeam, AwayTeam),
    Season = '1819') 
x.1718 %<>%
  filter(HomeTeam == 'Man City' | AwayTeam == 'Man City') %>%
  mutate(
    Date = as.Date(as.character(Date), format = '%Y-%m-%d'),
    GameID = paste0(HomeTeam, AwayTeam),
    HomeTeam = paste0(as.character(HomeTeam), '1718'),
    AwayTeam = paste0(as.character(AwayTeam), '1718'),
    Season = '1718') 
x.1617 %<>%
  filter(HomeTeam == 'Chelsea' | AwayTeam == 'Chelsea') %>%
  mutate(
    Date = as.Date(as.character(Date), format = '%Y-%m-%d'),
    GameID = paste0(HomeTeam, AwayTeam),
    HomeTeam = paste0(as.character(HomeTeam), '1617'),
    AwayTeam = paste0(as.character(AwayTeam), '1617'),
    Season = '1617') 
x.1516 %<>%
  filter(HomeTeam == 'Leicester' | AwayTeam == 'Leicester') %>%
  mutate(
    Date = as.Date(as.character(Date), format = '%Y-%m-%d'),
    GameID = paste0(HomeTeam, AwayTeam),
    HomeTeam = paste0(as.character(HomeTeam), '1516'),
    AwayTeam = paste0(as.character(AwayTeam), '1516'),
    Season = '1516') 
x.1415 %<>%
  filter(HomeTeam == 'Chelsea' | AwayTeam == 'Chelsea') %>%
  mutate(
    Date = as.Date(as.character(Date), format = '%Y-%m-%d'),
    GameID = paste0(HomeTeam, AwayTeam),
    HomeTeam = paste0(as.character(HomeTeam), '1415'),
    AwayTeam = paste0(as.character(AwayTeam), '1415'),
    Season = '1415') 
x.1314 %<>%
  filter(HomeTeam == 'Man City' | AwayTeam == 'Man City') %>%
  mutate(
    Date = as.Date(as.character(Date), format = '%Y-%m-%d'),
    GameID = paste0(HomeTeam, AwayTeam),
    HomeTeam = paste0(as.character(HomeTeam), '1314'),
    AwayTeam = paste0(as.character(AwayTeam), '1314'),
    Season = '1314') 
x.1213 %<>%
  filter(HomeTeam == 'Man United' | AwayTeam == 'Man United') %>%
  mutate(
    Date = as.Date(as.character(Date), format = '%Y-%m-%d'),
    GameID = paste0(HomeTeam, AwayTeam),
    HomeTeam = paste0(as.character(HomeTeam), '1213'),
    AwayTeam = paste0(as.character(AwayTeam), '1213'),
    Season = '1213') 
x.1112 %<>%
  filter(HomeTeam == 'Man City' | AwayTeam == 'Man City') %>%
  mutate(
    Date = as.Date(as.character(Date), format = '%Y-%m-%d'),
    GameID = paste0(HomeTeam, AwayTeam),
    HomeTeam = paste0(as.character(HomeTeam), '1112'),
    AwayTeam = paste0(as.character(AwayTeam), '1112'),
    Season = '1112') 
x.1011 %<>%
  filter(HomeTeam == 'Man United' | AwayTeam == 'Man United') %>%
  mutate(
    Date = as.Date(as.character(Date), format = '%Y-%m-%d'),
    GameID = paste0(HomeTeam, AwayTeam),
    HomeTeam = paste0(as.character(HomeTeam), '1011'),
    AwayTeam = paste0(as.character(AwayTeam), '1011'),
    Season = '1011') 
x.0910 %<>%
  filter(HomeTeam == 'Chelsea' | AwayTeam == 'Chelsea') %>%
  mutate(
    Date = as.Date(as.character(Date), format = '%Y-%m-%d'),
    GameID = paste0(HomeTeam, AwayTeam),
    HomeTeam = paste0(as.character(HomeTeam), '0910'),
    AwayTeam = paste0(as.character(AwayTeam), '0910'),
    Season = '0910') 

# Combine 10 years of data
x.data.10yr <-
  rbind(x.1819, x.1718, x.1617, x.1516, x.1415, x.1314, x.1213, x.1112, x.1011, x.0910)

# create df of home team results
x.home <-
  x.data %>%
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
  x.data %>%
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
data <- rbind(x.home, x.away) %>%
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

# combine home and away dfs for 10 year data
data.10yr <- rbind(x.home.10yr, x.away.10yr) %>%
  # filter to only champions
  filter(Team %in% c('Liverpool1819',
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
week.zero <-
  data %>%
  select(Team) %>%
  distinct() %>%
  mutate(Week = 0,
         PointsTally = 0) %>%
  spread(Team, PointsTally)
week.zero.10yr <-
  data.10yr %>%
  select(Team) %>%
  distinct() %>%
  mutate(Week = 0,
         PointsTally = 0) %>%
  spread(Team, PointsTally)

# data for points by week graph
pbw.data <-
  data %>%
  select(Week, Team, PointsTally) %>%
  spread(Team, PointsTally) %>%
  bind_rows(week.zero) %>%
  arrange(Week)

# data for points by week graph (10 years)
pbw.data.10yr <-
  data.10yr %>%
  select(Week, Team, PointsTally) %>%
  spread(Team, PointsTally) %>%
  bind_rows(week.zero) %>%
  arrange(Week)

# data for rank by week graph
rbw.data <-
  data %>%
  select(Week, Team, Position) %>%
  spread(Team, Position) %>%
  arrange(Week)
