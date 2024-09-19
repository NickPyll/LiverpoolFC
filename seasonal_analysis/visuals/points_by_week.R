points.by.week <- 
  plot_ly(pbw.data, x = ~Week) |>
  Reduce(\(x, y) {
    premier.league.clubs <- premier.league.clubs |> filter(Team == y)
    add_trace(
      x,
      y = reformulate(y), name = premier.league.clubs$TeamName, type = "scatter", mode = "lines",
      line = list(
        shape = "spline", color = premier.league.clubs$TeamColor,
        width = premier.league.clubs$TeamLineWidth,
        dash = premier.league.clubs$TeamLineType
      )
    )
  }, x = pbw.order, init = _) |> 
  add_annotations(x = 0, y = 100, text = 'Manchester City 2017/2018 = 100 points', xref = 'x', yref = 'y', showarrow = F, xanchor = 'left',
                  font = list(size = 16)) %>%
  add_annotations(x = 0, y = 87, text = 'Average points by champion = 87 points', xref = 'x', yref = 'y', showarrow = F, xanchor = 'left',
                  font = list(size = 16)) %>%
  add_annotations(x = 0, y = 75, text = 'Manchester United 1996/1997 = 75 points', xref = 'x', yref = 'y', showarrow = F, xanchor = 'left',
                  font = list(size = 16)) %>%
  add_annotations(x = 0, y = 34, text = 'West Bromwich 2005/2006 = 34 points', xref = 'x', yref = 'y', showarrow = F, xanchor = 'left',
                  font = list(size = 16)) %>%
  add_annotations(x = 0, y = 42, text = 'West Ham 2002/2003 = 42 points', xref = 'x', yref = 'y', showarrow = F, xanchor = 'left',
                  font = list(size = 16)) %>%
  # add_annotations(x = 29, y = 10, text = 'League Suspended due to \n COVID-19 Week 29', xref = 'x', yref = 'y', showarrow = F, xanchor = 'center',
  #                 font = list(size = 12)) %>%
  
  layout(
    # title = list(text = paste("Premier League Point Totals by Week <br>", max(rby.data$Year), "-", max(rby.data$Year)+1),
    #              font = list(size = 34)),
    legend = list(font = list(size = 14)),
    xaxis = list(title = "Week", rangemode = 'tozero', showline = FALSE, zeroline = FALSE,
                 titlefont = list(size = 18),
                 tickfont = list(size = 16)),
    yaxis = list (title = "", rangemode = 'nonnegative',
                  showgrid = FALSE, showline = FALSE, showticklabels = FALSE, zeroline = FALSE),
    margin = list(l = 50,r = 50, b = 100, t = 100, pad = 4),
    shapes = list(
      # list(type = 'line', line = list(color = 'grey69', dash = 'dashed'),
      #      x0 = 29, x1 = 29, xref = 'x',
      #      y0 = 21, y1 = 82, yref = 'y'),
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
           y0 = 75, y1 = 100, yref = 'y')
      # ,
      # list(type = 'line', line = list(color = 'rgba(200, 12, 46, .2)', dash = 'dot'),
      #      x0 = 0, x1 = 38, xref = 'x',
      #      y0 = 0, y1 = 38*max(pbw.data$Liverpool, na.rm = TRUE)/(sum(!is.na(pbw.data$Liverpool))-1), yref = 'y')
    )
  )

points.by.week

# api_create(points.by.week, filename = "Premier-League-PBW-2019")
