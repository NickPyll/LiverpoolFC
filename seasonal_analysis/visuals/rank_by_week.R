# Teams with game in hand not rendering correctly...need to address

# create graph showing league position by week
rank.by.week <- 
  plot_ly(rbw.data, x = ~Week) |>
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
  }, x = rbw.order, init = _) |> 
  layout(
    # title = paste("Premier League Position by Week <br>", max(rby.data$Year), "-", max(rby.data$Year)+1),
    legend = list(font = list(size = 16)),
    xaxis = list(title = "Week", rangemode = 'tozero', showline = FALSE, zeroline = FALSE,
                 titlefont = list(size = 18),
                 tickfont = list(size = 16)),
    yaxis = list (title = "", rangemode = 'nonnegative', autorange = "reversed", 
                  showgrid = FALSE, showline = FALSE, showticklabels = FALSE, zeroline = FALSE),
    margin = list(l = 50,r = 50, b = 100, t = 100, pad = 4)
    # ,
    # annotations = list(text = footnote,
    #                    showarrow = F, 
    #                    xref = 'paper', x = 0,
    #                    yref = 'paper', y = -.2,
    #                    xanchor = 'left', yanchor = 'auto',
    #                    font = list(size = 9, color = 'grey'))
  )

rank.by.week

# api_create(rank.by.week, filename = "Premier-League-RBW-2019")
