pointspergame.by.week.l5 <-
  plot_ly(ppgbwl5.data, x = ~week) |>
  Reduce(\(x, y) {
    premier.league.clubs <- premier.league.clubs |> filter(team == y)
    add_trace(
      x,
      y = reformulate(y), name = premier.league.clubs$team_name, type = "scatter", mode = "lines",
      line = list(
        shape = "line", color = premier.league.clubs$team_color,
        width = premier.league.clubs$team_linewidth,
        dash = premier.league.clubs$team_linetype
      )
    )
  }, x = ppgbwl5.order, init = _) |>
  layout(
    title = list(
      text = paste("<br>Premier League Form by Week", max(rby.data$year), "-", max(rby.data$year) + 1),
      font = list(size = 24)
    ),
    legend = list(font = list(size = 14)),
    xaxis = list(
      title = "Week", rangemode = "tozero", showline = FALSE, zeroline = FALSE,
      titlefont = list(size = 16),
      tickfont = list(size = 14)
    ),
    yaxis = list(
      title = "Points per Game (last 5 Fixtures)",
      title = "", rangemode = "nonnegative",
      showline = FALSE, zeroline = FALSE,
      titlefont = list(size = 16),
      tickfont = list(size = 14)
    )
  )

pointspergame.by.week.l5

# api_create(points.by.week, filename = "Premier-League-PBW-2019")
