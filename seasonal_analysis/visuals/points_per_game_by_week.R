pointspergame.by.week <-
  plot_ly(ppgbw.data, x = ~week) |>
  Reduce(\(x, y) {
    premier.league.clubs <- premier.league.clubs |> filter(team == y)
    add_trace(
      x,
      y = reformulate(y), name = premier.league.clubs$team_name, type = "scatter", mode = "lines",
      line = list(
        shape = "spline", color = premier.league.clubs$team_color,
        width = premier.league.clubs$team_linewidth,
        dash = premier.league.clubs$team_linetype
      )
    )
  }, x = ppgbw.order, init = _) |>
  layout(
    # title = list(text = paste("Premier League Point Totals by Week <br>", max(rby.data$Year), "-", max(rby.data$Year)+1),
    #              font = list(size = 34)),
    legend = list(font = list(size = 14)),
    xaxis = list(
      title = "Week", rangemode = "tozero", showline = FALSE, zeroline = FALSE,
      titlefont = list(size = 18),
      tickfont = list(size = 16)
    ),
    yaxis = list(
      title = "", rangemode = "nonnegative",
      showline = FALSE, zeroline = FALSE
    )
  )

pointspergame.by.week

# api_create(points.by.week, filename = "Premier-League-PBW-2019")
