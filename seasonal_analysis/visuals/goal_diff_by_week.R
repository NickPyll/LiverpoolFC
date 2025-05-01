# create graph showing goal differential by week
goal.diff.by.week <-
  plot_ly(gdbw.data, x = ~week) |>
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
  }, x = gdbw.order, init = _) %>%
  layout(
    # title = paste("Goal Differential by Week <br>", max(rby.data$Year), "-", max(rby.data$Year)+1),
    legend = list(font = list(size = 14)),
    xaxis = list(
      title = "Week", rangemode = "tozero", showline = FALSE, zeroline = FALSE,
      titlefont = list(size = 18),
      tickfont = list(size = 16)
    ),
    yaxis = list(
      title = "",
      showgrid = FALSE, showline = FALSE, showticklabels = FALSE, zeroline = FALSE
    ),
    margin = list(l = 50, r = 50, b = 100, t = 100, pad = 4),
    shapes =
      list(
        type = "line", line = list(color = "rgba(220, 220, 220, 1)", dash = "dot"),
        x0 = 0, x1 = 38, xref = "x",
        y0 = 0, y1 = 0, yref = "y"
      )
  )

goal.diff.by.week

# api_create(goal.diff.by.week, filename = "Premier-League-GDBW-2019")
