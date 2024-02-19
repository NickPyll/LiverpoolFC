# add promoted teams and colors, comment out relegated teams update_me
premier.league.clubs <-
  tribble(
    ~Team, ~TeamName, ~TeamColor, ~TeamLineType,
    'Arsenal', 'Arsenal', rgb(239, 1, 7, maxColorValue = 255), 'solid',
    'Aston Villa', 'Aston Villa', rgb(149,191,229, maxColorValue = 255), 'solid',
    # 'Birmingham', 'Birmingham',
    # 'Blackburn', 'Blackburn',
    # 'Blackpool', 'Blackpool',
    # 'Bolton', 'Bolton',
    'Bournemouth', 'AFC Bournemouth', rgb(181, 14, 18, maxColorValue = 255), 'solid',
    # 'Bradford'
    'Brentford', 'Brentford', rgb(227, 6, 19, maxColorValue = 255), 'solid',
    'Brighton', 'Brighton and Hove Albion', rgb(0, 87, 184, maxColorValue = 255), 'solid',
    'Burnley', 'Burnley', rgb(108, 29, 69, maxColorValue = 255), 'solid',
    # 'Cardiff', 'Cardiff City', rgb(0, 112, 181, maxColorValue = 255), 'solid',
    # 'Charlton', 'Charlton',
    'Chelsea', 'Chelsea', rgb(3, 70, 148, maxColorValue = 255), 'solid',
    # 'Coventry'
    'Crystal Palace', 'Crystal Palace', rgb(27, 69, 143, maxColorValue = 255), 'solid',
    # 'Derby'
    'Everton', 'Everton', rgb(39, 68, 136, maxColorValue = 255), 'dot',
    'Fulham', 'Fulham', rgb(0, 0, 0, maxColorValue = 255), 'solid',
    # 'Huddersfield', 'Huddersfield', rgb(14, 99, 173, maxColorValue = 255), 'solid',
    # 'Hull'
    # 'Ipswich'
    # 'Leeds', 'Leeds United', rgb(255, 205, 0, maxColorValue = 255), 'solid',
    # 'Leicester', 'Leicester City', rgb(0, 83, 160, maxColorValue = 255), 'solid',
    'Liverpool', 'Liverpool', rgb(200, 12, 46, maxColorValue = 255), 'solid',
    'Luton', 'Luton Town', rgb(247, 143, 30, maxColorValue = 255), 'solid',
    'Man City', 'Manchester City', rgb(108, 171, 221, maxColorValue = 255), 'solid',
    'Man United', 'Manchester United', rgb(218, 41, 28, maxColorValue = 255), 'solid',
    # 'Middlesbrough'
    'Newcastle', 'Newcastle', rgb(45, 41, 38, maxColorValue = 255), 'dash',
    # 'Norwich', 'Norwich City', rgb(0, 166, 80, maxColorValue = 255), 'dash',
    'Nottm Forest', 'Nottingham Forest', rgb(229, 50, 51, maxColorValue = 255), 'dot',
    # 'Portsmouth'
    # 'QPR'
    # 'Reading'
    'Sheffield United', 'Sheffield United', rgb(238,39,55, maxColorValue = 255), 'dash',
    # 'Southampton', 'Southampton', rgb(215, 25, 32, maxColorValue = 255), 'dash', 
    # 'Stoke'
    'Tottenham', 'Tottenham Hotspur', rgb(19, 34, 87, maxColorValue = 255), 'solid',
    # 'Watford', 'Watford', rgb(251, 238, 35, maxColorValue = 255), 'solid',
    # 'West Brom', 'West Bromwich Albion', rgb(18, 47, 103, maxColorValue = 255), 'solid',
    'West Ham', 'West Ham United', rgb(122, 38, 58, maxColorValue = 255), 'solid',
    # 'Wigan'
    'Wolves', 'Wolverhampton', rgb(253, 185, 19, maxColorValue = 255), 'solid'
    ) |> 
  mutate(Team = str_trim(gsub(" ", "", Team))) |> 
  mutate(TeamLineWidth = if_else(Team == 'Liverpool', 4, 1))
    
premier.league.champions <-
  tribble(
    ~Season, ~Champion,
    '0001', 'ManUnited',
    '0102', 'Arsenal',
    '0203', 'ManUnited',
    '0304', 'Arsenal',
    '0405', 'Chelsea',
    '0506', 'Chelsea',
    '0607', 'ManUnited',
    '0708', 'ManUnited',
    '0809', 'ManUnited',
    '0910', 'Chelsea',
    '1011', 'ManUnited',
    '1112', 'ManCity', 
    '1213', 'ManUnited',
    '1314', 'ManCity',
    '1415', 'Chelsea',
    '1516', 'Leicester',
    '1617', 'Chelsea',
    '1718', 'ManCity',
    '1819', 'ManCity',
    '1920', 'Liverpool',
    '2021', 'ManCity',
    '2122', 'ManCity',
    '2223', 'ManCity'
  )
