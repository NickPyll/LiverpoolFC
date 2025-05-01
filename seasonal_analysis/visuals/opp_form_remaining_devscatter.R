rofbw.long <-
  rofbw.data |>
  select(-week) |>
  pivot_longer(everything(), names_to = "team", values_to = "opp_form") |>
  inner_join(
    premier.league.clubs |>
      select(team, team_name),
    by = "team"
  ) |>
  mutate(
    team = factor(team)
  )

# Add jitter to x values
set.seed(123) # For consistent jitter
rofbw.long$jittered_team <- jitter(as.numeric(rofbw.long$team), amount = 0.2)

plot_ly(rofbw.long,
  x = ~jittered_team, y = ~opp_form, type = "scatter", mode = "markers",
  color = ~team,
  colors = premier.league.clubs$team_color,
  marker = list(size = 8, opacity = 0.8)
) |>
  layout(
    title = "Performance Over Weeks by Team",
    xaxis = list(title = "", categoryorder = "array", categoryarray = unique(rofbw.long$team)),
    yaxis = list(title = "Remaining Opponent Form"),
    showlegend = FALSE
  )
