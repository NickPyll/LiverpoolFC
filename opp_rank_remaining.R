# create graph showing remaining strength of schedule
opp.rank.by.week <- 
  plot_ly(orbw.data, x = ~Week) %>%
  add_trace(y = ~Liverpool.Opponent, name = 'Liverpool Opponent Rank', type = 'scatter', mode = 'lines', 
            line = list(shape = 'spline', color = 'rgb(200, 12, 46)', width = 4)) %>%
  add_trace(y = ~ManCity.Opponent, name = 'Manchester City Opponent Rank', type = 'scatter', mode = 'lines', 
            line = list(shape = 'spline', color = 'rgb(108, 171, 221)', width = 1)) %>%
  add_annotations(x = 35, y = 7, text = paste('Mean Liverpool Opponent = ', 
                                              round(mean(orbw.data$Liverpool.Opponent, na.rm = TRUE), digits = 2)),
                  xref = 'x', yref = 'y', showarrow = F) %>%
  add_annotations(x = 35, y = 5, text = paste('Mean Manchester City Opponent = ', 
                                              round(mean(orbw.data$ManCity.Opponent), digits = 2)),
                  xref = 'x', yref = 'y', showarrow = F) %>%

  layout(title = "Rank of Remaining Opponents",
         xaxis = list(title = "", showgrid = FALSE, showline = FALSE, zeroline = FALSE, showticklabels = FALSE),
         yaxis = list (title = "Opponent Rank", rangemode = 'nonnegative', 
                       showline = FALSE, showticklabels = TRUE, zeroline = FALSE),
         margin = list(l = 50,r = 50, b = 100, t = 100, pad = 4))

opp.rank.by.week

# api_create(points.by.week, filename = "Premier-League-PBW-2019")