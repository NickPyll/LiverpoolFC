# create animated graph showing point tally by week

animated.points.by.week <- apbw.data %>%
  plot_ly(
    x = ~Week, 
    y = ~Points,
    frame = ~frame, 
    type = 'scatter',
    mode = 'lines',
    text = ~Team,
    color = ~Team,
    colors = teamcolors
  ) %>% 
  layout(
    xaxis = list(
      title = "Week",
      zeroline = F
    ),
    yaxis = list(
      title = "Points",
      zeroline = F
    )
  ) %>% 
  animation_opts(
    frame = 300, 
    transition = 0, 
    redraw = FALSE,
    easing = 'elastic'
  ) %>%
  animation_slider(
    currentvalue = list(prefix = "week ", font = list(color="red"))    
  ) %>%
  animation_button(
    x = 1, xanchor = "right", y = 0, yanchor = "bottom"
  ) %>%
  add_annotations(x = 0, y = 100, text = 'Manchester City 2017/2018 = 100 points', xref = 'x', yref = 'y', showarrow = F, xanchor = 'left') %>%
  add_annotations(x = 0, y = 87, text = 'Average points by champion = 87 points', xref = 'x', yref = 'y', showarrow = F, xanchor = 'left') %>%
  add_annotations(x = 0, y = 75, text = 'Manchester United 1996/1997 = 75 points', xref = 'x', yref = 'y', showarrow = F, xanchor = 'left') %>%
  add_annotations(x = 0, y = 34, text = 'West Bromwich 2005/2006 = 34 points', xref = 'x', yref = 'y', showarrow = F, xanchor = 'left') %>%
  add_annotations(x = 0, y = 42, text = 'West Ham 2002/2003 = 42 points', xref = 'x', yref = 'y', showarrow = F, xanchor = 'left') %>%

  layout(title = paste("Premier League Position by Week <br>", max(rby.data$Year), "-", max(rby.data$Year)+1),
         xaxis = list(title = "Week", 
                      range = c(0, 40),
                      showline = FALSE, zeroline = FALSE),
         yaxis = list (title = "", 
                       range = c(0, 110),
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
                y0 = 0, y1 = 38*max(pbw.data$Liverpool, na.rm = TRUE)/(sum(!is.na(pbw.data$Liverpool))-1), yref = 'y')
           )
)

animated.points.by.week

# api_create(animated.points.by.week, filename = "Animated-Premier-League-PBW-2019-2020")
