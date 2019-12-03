# create graph showing point tally by week for last 10 champions
points.by.week.10yr <- 
  plot_ly(pbw.data.10yr, x = ~Week) %>%
  add_trace(y = ~ManCity1819, name = 'Man City 2019', type = 'scatter', mode = 'lines',
            line = list(color = 'rgba(220, 220, 220, 1)', width = 1)) %>%
  add_trace(y = ~ManCity1718, name = 'Man City 2018', type = 'scatter', mode = 'lines',
            line = list(color = 'rgba(220, 220, 220, 1)', width = 1)) %>%
  add_trace(y = ~Chelsea1617, name = 'Chelsea 2017', type = 'scatter', mode = 'lines',
            line = list(color = 'rgba(220, 220, 220, 1)', width = 1)) %>%
  add_trace(y = ~Leicester1516, name = 'Leicester 2016', type = 'scatter', mode = 'lines',
            line = list(color = 'rgba(220, 220, 220, 1)', width = 1)) %>%
  add_trace(y = ~Chelsea1415, name = 'Chelsea 2015', type = 'scatter', mode = 'lines',
            line = list(color = 'rgba(220, 220, 220, 1)', width = 1)) %>%
  add_trace(y = ~ManCity1314, name = 'Man City 2014', type = 'scatter', mode = 'lines',
            line = list(color = 'rgba(220, 220, 220, 1)', width = 1)) %>%
  add_trace(y = ~ManUnited1213, name = 'Man United 2013', type = 'scatter', mode = 'lines',
            line = list(color = 'rgba(220, 220, 220, 1)', width = 1)) %>%
  add_trace(y = ~ManCity1112, name = 'Man City 2012', type = 'scatter', mode = 'lines',
            line = list(color = 'rgba(220, 220, 220, 1)', width = 1)) %>%
  add_trace(y = ~ManUnited1011, name = 'Man United 2011', type = 'scatter', mode = 'lines',
            line = list(color = 'rgba(220, 220, 220, 1)', width = 1)) %>%
  add_trace(y = ~Chelsea0910, name = 'Chelsea 2010', type = 'scatter', mode = 'lines',
            line = list(color = 'rgba(220, 220, 220, 1)', width = 1)) %>%
  add_trace(y = ~Liverpool1920, name = 'Liverpool 2020', type = 'scatter', mode = 'lines', 
            line = list(shape = 'spline', color = 'rgb(200, 12, 46)', width = 4)) %>%

  # move Liverpool to top without being drawn over by other series  
  
    layout(title = paste("Premier League Champions by Week <br> 2010 -", max(rby.data$Year)),
         xaxis = list(title = "Week", rangemode = 'tozero', showline = FALSE, zeroline = FALSE),
         yaxis = list (title = "", rangemode = 'nonnegative',
                       showgrid = FALSE, showline = FALSE, showticklabels = FALSE, zeroline = FALSE),
         margin = list(l = 50,r = 50, b = 100, t = 100, pad = 4), 
         shapes = list(type = 'line', line = list(color = 'rgba(200, 12, 46, .2)', dash = 'dot'),
                x0 = 0, x1 = 38, xref = 'x',
                y0 = 0, y1 = 38*max(pbw.data$Liverpool)/(sum(!is.na(pbw.data$Liverpool))-1), yref = 'y'))

points.by.week.10yr

# api_create(points.by.week.10yr, filename = "Premier-League-PBW10-2019")
