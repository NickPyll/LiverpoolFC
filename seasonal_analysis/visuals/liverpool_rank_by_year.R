# create graph showing final position by year update_me
rank.by.year <-
  plot_ly(rby.data,
    x = ~year
  ) %>%
  add_trace(
    y = ~ num_teams_firstdiv + 1,
    type = "scatter", mode = "lines",
    line = list(
      shape = "hv",
      color = "rgba(220, 220, 220, .4)",
      width = 1
    ),
    showlegend = FALSE,
    hoverinfo = "none"
  ) %>%
  add_trace(
    y = ~ num_teams_firstdiv + num_teams_seconddiv + 1,
    type = "scatter", mode = "lines",
    fill = "tonexty",
    fillcolor = "rgba(220, 220, 220, .4)",
    line = list(
      shape = "hv",
      color = "rgba(220, 220, 220, .4)",
      width = 1
    ),
    showlegend = FALSE, hoverinfo = "none"
  ) %>%
  add_trace(
    y = 45,
    type = "scatter", mode = "lines",
    fill = "tonexty", fillcolor = "rgba(220, 220, 220, .7)",
    line = list(
      shape = "hv",
      color = "rgba(220, 220, 220, .7)",
      width = 1
    ),
    showlegend = FALSE, hoverinfo = "none"
  ) %>%
  add_trace(
    y = ~actual_position, name = "League Position", type = "scatter", mode = "lines",
    line = list(shape = "linear", color = "rgb(200, 12, 46)", width = 2.2)
  ) %>%
  add_trace(
    y = ~champions, name = "Champions", type = "scatter", mode = "markers",
    marker = list(symbol = 18, color = "orange", size = 9)
  ) %>%
  add_annotations(
    x = max(rby.data$year), y = 44, text = "Third Division", xref = "x", yref = "y", showarrow = F, xanchor = "right",
    font = list(size = 18)
  ) %>%
  add_annotations(
    x = max(rby.data$year), y = 32, text = "Second Division", xref = "x", yref = "y", showarrow = F, xanchor = "right",
    font = list(size = 18)
  ) %>%
  add_annotations(
    x = max(rby.data$year), y = 12, text = "First Division", xref = "x", yref = "y", showarrow = F, xanchor = "right",
    font = list(size = 18)
  ) %>%
  layout(
    title = paste("Liverpool League Position by year 1893 -", max(rby.data$year)),
    legend = list(font = list(size = 14), x = 2040, y = 20),
    xaxis = list(
      range = c(1890, max(rby.data$year) + 2), title = "", showgrid = TRUE, showline = TRUE,
      titlefont = list(size = 18),
      tickfont = list(size = 16)
    ),
    yaxis = list(
      title = "", autorange = "reversed",
      zeroline = FALSE, showline = FALSE, showgrid = FALSE, showticklabels = FALSE
    ),
    shapes = list(
      list(
        type = "rect", fillcolor = "white", line = list(color = "white"),
        x0 = 1916, x1 = 1919.6, xref = "x",
        y0 = 1, y1 = 45, yref = "y"
      ),
      list(
        type = "rect", fillcolor = "white", line = list(color = "white"),
        x0 = 1940.4, x1 = 1946, xref = "x",
        y0 = 1, y1 = 45, yref = "y"
      ),
      list(
        type = "line", line = list(color = "rgba(220, 220, 220, .8)", dash = "dot"),
        x0 = 1993, x1 = 1993, xref = "x",
        y0 = 1, y1 = 45, yref = "y"
      )
    )
  )

rank.by.year

# api_create(rank.by.year, filename = "Premier-League-RBY-2019")
