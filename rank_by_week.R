# create graph showing league position by week
rank.by.week <- 
  plot_ly(rbw.data,
            x = ~Week, 
            y = ~Arsenal, name = 'Arsenal', type = 'scatter', mode = 'lines', 
          line = list(shape = 'spline', color = 'rgb(239, 1, 7)', width = 1)) %>%
  add_trace(y = ~Bournemouth, name = 'Bournemouth', line = list(color = 'rgb(181, 14, 18)', width = 1)) %>%
  add_trace(y = ~Brighton, name = 'Brighton', line = list(color = 'rgb(0, 87, 184)', width = 1)) %>%
  add_trace(y = ~Burnley, name = 'Burnley', line = list(color = 'rgb(108, 29, 69)', width = 1)) %>%
  add_trace(y = ~Cardiff, name = 'Cardiff City', line = list(color = 'rgb(0, 112, 181)', width = 1)) %>%
  add_trace(y = ~Chelsea, name = 'Chelsea', line = list(color = 'rgb(3, 70, 148)', width = 1)) %>%
  add_trace(y = ~CrystalPalace, name = 'Crystal Palace', line = list(color = 'rgb(27, 69, 143)', width = 1)) %>%
  add_trace(y = ~Everton, name = 'Everton', line = list(color = 'rgb(39, 68, 136)', width = 1, dash = 'dot')) %>%
  add_trace(y = ~Fulham, name = 'Fulham', line = list(color = 'rgb(0, 0, 0)', width = 1)) %>%
  add_trace(y = ~Huddersfield, name = 'Huddersfield', line = list(color = 'rgb(14, 99, 173)', width = 1)) %>%
  add_trace(y = ~Leicester, name = 'Leicester City', line = list(color = 'rgb(0, 83, 160)', width = 1)) %>%
  add_trace(y = ~Liverpool, name = 'Liverpool', line = list(color = 'rgb(200, 12, 46)', width = 4)) %>%
  add_trace(y = ~ManCity, name = 'Manchester City', line = list(color = 'rgb(108, 171, 221)', width = 1)) %>%
  add_trace(y = ~ManUnited, name = 'Manchester United', line = list(color = 'rgb(218, 41, 28)', width = 1)) %>%
  add_trace(y = ~Newcastle, name = 'Newcastle', line = list(color = 'rgb(45, 41, 38)', width = 1, dash = 'dash')) %>%
  add_trace(y = ~Southampton, name = 'Southampton', line = list(color = 'rgb(215, 25, 32)', width = 1, dash = 'dash')) %>%
  add_trace(y = ~Tottenham, name = 'Tottenham', line = list(color = 'rgb(19, 34, 87)', width = 1)) %>%
  add_trace(y = ~Watford, name = 'Watford', line = list(color = 'rgb(251, 238, 35)', width = 1)) %>%
  add_trace(y = ~WestHam, name = 'West Ham United', line = list(color = 'rgb(122, 38, 58)', width = 1)) %>%
  add_trace(y = ~Wolves, name = 'Wolverhampton', line = list(color = 'rgb(253, 185, 19)', width = 1)) %>%
  layout(title = "Premier League Position by Week",
         xaxis = list(title = "Week", rangemode = 'tozero', showline = FALSE, zeroline = FALSE),
         yaxis = list (title = "", rangemode = 'nonnegative', autorange = "reversed", 
                       showgrid = FALSE, showline = FALSE, showticklabels = FALSE, zeroline = FALSE),
         margin = list(l = 50,r = 50, b = 100, t = 100, pad = 4))

