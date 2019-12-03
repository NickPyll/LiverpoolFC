# create graph showing final position by year
rank.by.year <- 
  plot_ly(rby.data, 
          x = ~Year) %>%
  add_trace(y = ~NumTeamsFirstDiv + 1, name = "First/Second Division", 
          type = 'scatter', mode = 'lines',
          line = list(shape = 'hv', color = 'rgba(220, 220, 220, .4)', width = 1),
          showlegend = FALSE, hoverinfo = 'none') %>%
  add_trace(y = ~NumTeamsFirstDiv + NumTeamsSecondDiv + 1, name = "First/Second Division", 
          type = 'scatter', mode = 'lines',
          fill = 'tonexty', fillcolor = 'rgba(220, 220, 220, .4)',
          line = list(shape = 'hv', color = 'rgba(220, 220, 220, .4)', width = 1),
          showlegend = FALSE, hoverinfo = 'none') %>%
  add_trace(y = 45, name = "First/Second Division", 
          type = 'scatter', mode = 'lines',
          fill = 'tonexty', fillcolor = 'rgba(220, 220, 220, .7)',
          line = list(shape = 'hv', color = 'rgba(220, 220, 220, .7)', width = 1),
          showlegend = FALSE, hoverinfo = 'none') %>%
  add_trace(y = ~Champions, name = 'Champions', type = 'scatter', mode = 'markers',
          marker = list(symbol = 18, color = 'orange', size = 7)) %>%
  add_trace(y = ~ActualPosition, name = 'Liverpool', type = 'scatter', mode = 'lines',
          line = list(shape = 'linear', color = 'rgb(200, 12, 46)', width = 1)) %>%
  add_annotations(x = max(rby.data$Year), y = 44, text = 'Third Division', xref = 'x', yref = 'y', showarrow = F, xanchor = 'right') %>%
  add_annotations(x = max(rby.data$Year), y = 32, text = 'Second Division', xref = 'x', yref = 'y', showarrow = F, xanchor = 'right') %>%
  add_annotations(x = max(rby.data$Year), y = 12, text = 'First Division', xref = 'x', yref = 'y', showarrow = F, xanchor = 'right') %>%
  layout(
    # autosize = FALSE, width = 100, height = 100,
    #      margin = list(l = 50,
    #                    r = 50,
    #                    b = 100,
    #                    t = 100,
    #                    pad = 4), 
         title = paste("Liverpool League Position by Year 1893 -", max(rby.data$Year)),
         xaxis = list(title = "Year", showgrid = TRUE, showline = TRUE),
         yaxis = list (title = "", autorange = "reversed", 
                       zeroline = FALSE, showline = FALSE, showgrid = FALSE, showticklabels = FALSE),
         shapes = list(
           list(type = 'rect', fillcolor = 'white', line = list(color = "white"),
                x0 = 1916, x1 = 1919.6, xref = 'x',
                y0 = 1, y1 = 45, yref = 'y'),
           list(type = 'rect', fillcolor = 'white', line = list(color = "white"),
                x0 = 1940.4, x1 = 1946, xref = 'x',
                y0 = 1, y1 = 45, yref = 'y'),
           list(type = 'line', line = list(color = 'rgba(220, 220, 220, .8)', dash = 'dot'),
                x0 = 1993, x1 = 1993, xref = 'x',
                y0 = 1, y1 = 45, yref = 'y')
         )
         )

rank.by.year

# api_create(rank.by.year, filename = "Premier-League-RBY-2019")
