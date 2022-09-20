# create graph showing point tally by week

predicted.points.by.week <- 
  plot_ly(ppbw.data, x = ~Week) %>%
  add_trace(y = ~Arsenal, name = 'Arsenal', type = 'scatter', mode = 'lines', 
            line = list(shape = 'spline', color = 'rgb(239, 1, 7)', width = 1)) %>%
  add_trace(y = ~AstonVilla, name = 'Aston Villa', type = 'scatter', mode = 'lines', 
            line = list(shape = 'spline', color = 'rgb(149,191,229)', width = 1)) %>%
  add_trace(y = ~Bournemouth, name = 'Bournemouth', type = 'scatter', mode = 'lines',
            line = list(shape = 'spline', color = 'rgb(181, 14, 18)', width = 1)) %>%
  add_trace(y = ~Brentford, name = 'Brentford', type = 'scatter', mode = 'lines', 
            line = list(shape = 'spline', color = 'rgb(227, 6, 19)', width = 1)) %>%
  add_trace(y = ~Brighton, name = 'Brighton', type = 'scatter', mode = 'lines', 
            line = list(shape = 'spline', color = 'rgb(0, 87, 184)', width = 1)) %>%
  # add_trace(y = ~Burnley, name = 'Burnley', type = 'scatter', mode = 'lines', 
  #           line = list(shape = 'spline', color = 'rgb(108, 29, 69)', width = 1)) %>%
  # add_trace(y = ~Cardiff, name = 'Cardiff City', type = 'scatter', mode = 'lines', 
  #           line = list(shape = 'spline', color = 'rgb(0, 112, 181)', width = 1)) %>%
  add_trace(y = ~Chelsea, name = 'Chelsea', type = 'scatter', mode = 'lines', 
            line = list(shape = 'spline', color = 'rgb(3, 70, 148)', width = 1)) %>%
  add_trace(y = ~CrystalPalace, name = 'Crystal Palace', type = 'scatter', mode = 'lines', 
            line = list(shape = 'spline', color = 'rgb(27, 69, 143)', width = 1)) %>%
  add_trace(y = ~Everton, name = 'Everton', type = 'scatter', mode = 'lines', 
            line = list(shape = 'spline', color = 'rgb(39, 68, 136)', width = 1, dash = 'dot')) %>%
  add_trace(y = ~Fulham, name = 'Fulham', type = 'scatter', mode = 'lines',
            line = list(shape = 'spline', color = 'rgb(0, 0, 0)', width = 1)) %>%
  # add_trace(y = ~Huddersfield, name = 'Huddersfield', type = 'scatter', mode = 'lines', 
  #           line = list(shape = 'spline', color = 'rgb(14, 99, 173)', width = 1)) %>%
  add_trace(y = ~Leeds, name = 'Leeds United', type = 'scatter', mode = 'lines', 
            line = list(shape = 'spline', color = 'rgb(255, 205, 0)', width = 1)) %>%
  add_trace(y = ~Leicester, name = 'Leicester City', type = 'scatter', mode = 'lines', 
            line = list(shape = 'spline', color = 'rgb(0, 83, 160)', width = 1)) %>%
  add_trace(y = ~Liverpool, name = 'Liverpool', type = 'scatter', mode = 'lines', 
            line = list(shape = 'spline', color = 'rgb(200, 12, 46)', width = 4)) %>%
  add_trace(y = ~ManCity, name = 'Manchester City', type = 'scatter', mode = 'lines', 
            line = list(shape = 'spline', color = 'rgb(108, 171, 221)', width = 1)) %>%
  add_trace(y = ~ManUnited, name = 'Manchester United', type = 'scatter', mode = 'lines', 
            line = list(shape = 'spline', color = 'rgb(218, 41, 28)', width = 1)) %>%
  add_trace(y = ~Newcastle, name = 'Newcastle', type = 'scatter', mode = 'lines', 
            line = list(shape = 'spline', color = 'rgb(45, 41, 38)', width = 1, dash = 'dash')) %>%
  # add_trace(y = ~Norwich, name = 'Norwich City', type = 'scatter', mode = 'lines',
  #           line = list(shape = 'spline', color = 'rgb(0, 166, 80)', width = 1, dash = 'dash')) %>%
  add_trace(y = ~NottmForest, name = 'Nottingham Forest', type = 'scatter', mode = 'lines', 
            line = list(shape = 'spline', color = 'rgb(229, 50, 51)', width = 1, dash = 'dot')) %>%
  # add_trace(y = ~SheffieldUnited, name = 'Sheffield United', type = 'scatter', mode = 'lines', 
  #           line = list(shape = 'spline', color = 'rgb(238,39,55)', width = 1, dash = 'dash')) %>%
  add_trace(y = ~Southampton, name = 'Southampton', type = 'scatter', mode = 'lines', 
            line = list(shape = 'spline', color = 'rgb(215, 25, 32)', width = 1, dash = 'dash')) %>%
  add_trace(y = ~Tottenham, name = 'Tottenham', type = 'scatter', mode = 'lines', 
            line = list(shape = 'spline', color = 'rgb(19, 34, 87)', width = 1)) %>%
  # add_trace(y = ~Watford, name = 'Watford', type = 'scatter', mode = 'lines',
  #           line = list(shape = 'spline', color = 'rgb(251, 238, 35)', width = 1)) %>%
  # add_trace(y = ~WestBrom, name = 'West Bromwich Albion', type = 'scatter', mode = 'lines', 
  #           line = list(shape = 'spline', color = 'rgb(18, 47, 103)', width = 1)) %>%
  add_trace(y = ~WestHam, name = 'West Ham United', type = 'scatter', mode = 'lines', 
            line = list(shape = 'spline', color = 'rgb(122, 38, 58)', width = 1)) %>%
  add_trace(y = ~Wolves, name = 'Wolverhampton', type = 'scatter', mode = 'lines', 
            line = list(shape = 'spline', color = 'rgb(253, 185, 19)', width = 1)) %>%
  
  layout(
    title = paste("Premier League Position by Week <br>", max(rby.data$Year), "-", max(rby.data$Year)+1, '<br>', 'Projected as of Week ', max(pbw.data$Week)),
         legend = list(font = list(size = 14)),
         xaxis = list(title = "Week", rangemode = 'tozero', showline = FALSE, zeroline = FALSE,
                      titlefont = list(size = 18),
                      tickfont = list(size = 16)),
         yaxis = list (title = "", rangemode = 'nonnegative',
                       showgrid = FALSE, showline = FALSE, showticklabels = FALSE, zeroline = FALSE),
         margin = list(l = 50,r = 50, b = 100, t = 100, pad = 4),
         shapes = list(
           list(type = 'line', line = list(color = 'rgba(220, 220, 220, 1)', dash = 'dot'),
                x0 = 0, x1 = 38, xref = 'x',
                y0 = 40, y1 = 40, yref = 'y'),
           list(type = 'rect', fillcolor = 'rgba(220, 220, 220, .2)', line = list(color = "rgba(220, 220, 220, .2)"),
                x0 = 0, x1 = 38, xref = 'x',
                y0 = 34, y1 = 42, yref = 'y'),
           list(type = 'line', line = list(color = 'rgba(220, 220, 220, 1)', dash = 'dot'),
                x0 = 0, x1 = 38, xref = 'x',
                y0 = 87, y1 = 87, yref = 'y'),
           list(type = 'rect', fillcolor = 'rgba(220, 220, 220, .2)', line = list(color = "rgba(220, 220, 220, .2)"),
                x0 = 0, x1 = 38, xref = 'x',
                y0 = 75, y1 = 100, yref = 'y'),
           list(type = 'line', line = list(color = 'rgba(200, 12, 46, .2)', dash = 'dot'),
                x0 = 0, x1 = 38, xref = 'x',
                y0 = 0, y1 = 38*max(pbw.data$Liverpool, na.rm = TRUE)/(sum(!is.na(pbw.data$Liverpool))-1), yref = 'y'),
           list(type = 'line', line = list(color = 'black', dash = 'dot'),
                x0 = max(pbw.data$Week), x1 = max(pbw.data$Week), xref = 'x',
                y0 = 0, y1 = 114, yref = 'y')
           
           # list(type = 'rect', fillcolor = 'rgba(220, 220, 220, .2)', line = list(color = "rgba(220, 220, 220, .2)"),
           #      x0 = max(pbw.data$Week), x1 = 38, xref = 'x',
           #      y0 = 0, y1 = 114, yref = 'y')
           )
)

predicted.points.by.week

# api_create(points.by.week, filename = "Premier-League-PBW-2019")
