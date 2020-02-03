# add promoted teams and colors, comment out relegated teams update_me
x.premier.league.clubs <-
  tribble(
    ~Team, ~Team_538, ~TeamColor,
    'Arsenal', 'Arsenal', rgb(239, 1, 7, maxColorValue = 255),
    'Aston Villa', 'Aston Villa', rgb(149,191,229, maxColorValue = 255),
    'Bournemouth', 'AFC Bournemouth', rgb(181, 14, 18, maxColorValue = 255),
    'Brighton', 'Brighton and Hove Albion', rgb(0, 87, 184, maxColorValue = 255),
    'Burnley', 'Burnley', rgb(108, 29, 69, maxColorValue = 255),
    # 'Cardiff', rgb(0, 112, 181, maxColorValue = 255),
    'Chelsea', 'Chelsea', rgb(3, 70, 148, maxColorValue = 255),
    'Crystal Palace', 'Crystal Palace', rgb(27, 69, 143, maxColorValue = 255),
    'Everton', 'Everton', rgb(39, 68, 136, maxColorValue = 255),
    # 'Fulham', rgb(0, 0, 0, maxColorValue = 255),
    # 'Huddersfield', rgb(14, 99, 173, maxColorValue = 255),
    'Leicester', 'Leicester City', rgb(0, 83, 160, maxColorValue = 255),
    'Liverpool', 'Liverpool', rgb(200, 12, 46, maxColorValue = 255),
    'Man City', 'Manchester City', rgb(108, 171, 221, maxColorValue = 255),
    'Man United', 'Manchester United', rgb(218, 41, 28, maxColorValue = 255),
    'Newcastle', 'Newcastle', rgb(45, 41, 38, maxColorValue = 255),
    'Norwich', 'Norwich City', rgb(0, 166, 80, maxColorValue = 255),
    'Sheffield United', 'Sheffield United', rgb(238,39,55, maxColorValue = 255),
    'Southampton', 'Southampton', rgb(215, 25, 32, maxColorValue = 255),
    'Tottenham', 'Tottenham Hotspur', rgb(19, 34, 87, maxColorValue = 255),
    'Watford', 'Watford', rgb(251, 238, 35, maxColorValue = 255),
    'West Ham', 'West Ham United', rgb(122, 38, 58, maxColorValue = 255),
    'Wolves', 'Wolverhampton', rgb(253, 185, 19, maxColorValue = 255)
    )

