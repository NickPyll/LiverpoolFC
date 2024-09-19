library(tidyverse)
library(cowplot)

players <-
  tribble(
    ~Team, ~Name, ~Age, ~SeniorCaps, ~NationalCaps,
    'Chelsea', 'Petrovic', 24, 150, 2,
    'Chelsea', 'Gusto', 20, 93, 1,
    'Chelsea', 'Disasi', 25, 273, 5, 
    'Chelsea', 'Colwill', 20, 89, 1,
    'Chelsea', 'Chilwell', 27, 175, 19,
    'Chelsea', 'Caicedo', 22, 129, 38,
    'Chelsea', 'Fernandez', 23, 166, 19,
    'Chelsea', 'Palmer', 21, 73, 2,
    'Chelsea', 'Gallagher', 24, 201, 11,
    'Chelsea', 'Sterling', 29, 537, 82,
    'Chelsea', 'Jackson', 22, 118, 11,
    'Chelsea', 'Mudryk', 23, 107, 16,
    'Chelsea', 'Madueke', 21, 118, 0,
    'Chelsea', 'Chalobah', 24, 184, 0,
    'Chelsea', 'Nkunku', 26, 286, 10,
    'Liverpool', 'Kelleher', 25, 38, 11,
    'Liverpool', 'Bradley', 20, 72, 13,
    'Liverpool', 'Konate', 24, 199, 13,
    'Liverpool', 'Van Dijk', 32, 518, 64,
    'Liverpool', 'Robertson', 29, 484, 67,
    'Liverpool', 'MacAllister', 25, 242, 23,
    'Liverpool', 'Endo', 31, 469, 60,
    'Liverpool', 'Gravenberch', 21, 213, 11,
    'Liverpool', 'Diaz', 27, 357, 45,
    'Liverpool', 'Gakpo', 24, 247, 21,
    'Liverpool', 'Elliott', 20, 148, 0,
    'Liverpool', 'Gomez', 26, 232, 11,
    'Liverpool', 'Tsimikas', 26, 216, 32,
    'Liverpool', 'Clark', 19, 9, 0,
    'Liverpool', 'McConnell', 19, 9, 0,
    'Liverpool', 'Danns', 18, 3, 0,
    'Liverpool', 'Quansah', 21, 40, 0,
    'Liverpool Full Strength', 'Bradley', 20, 72, 13,
    'Liverpool Full Strength', 'Konate', 24, 199, 13,
    'Liverpool Full Strength', 'Van Dijk', 32, 518, 64,
    'Liverpool Full Strength', 'Robertson', 29, 484, 67,
    'Liverpool Full Strength', 'MacAllister', 25, 242, 23,
    'Liverpool Full Strength', 'Endo', 31, 469, 60,
    'Liverpool Full Strength', 'Diaz', 27, 357, 45,
    'Liverpool Full Strength', 'Gakpo', 24, 247, 21,
    'Liverpool Full Strength', 'Elliott', 20, 148, 0,
    'Liverpool Full Strength', 'Gomez', 26, 232, 11,
    'Liverpool Full Strength', 'Salah', 31, 575, 98,
    'Liverpool Full Strength', 'Jota', 27, 354, 36,
    'Liverpool Full Strength', 'Szobo', 23, 244, 38,
    'Liverpool Full Strength', 'Trent', 25, 302, 23,
    'Liverpool Full Strength', 'Nunez', 24, 217, 22,
    'Liverpool Full Strength', 'Allison', 31, 420, 63,
    'Liverpool Full Strength', 'Jones', 23, 126, 0
  )
   
source("data/ref_clubs.R")

# create vector for team colors
livchels_colors <-
  premier.league.clubs |>
  filter(Team %in% c('Chelsea', 'Liverpool')) |> 
  select(TeamColor) |>
  bind_rows(premier.league.clubs |> 
              filter(Team == 'Liverpool') |> 
              select(TeamColor)
  ) |>  
  pull()

cap <- 
  players |> 
  ggplot(aes(x = Team, y = SeniorCaps, fill = Team)) +
  geom_boxplot() +
  geom_violin(alpha = .1) +
  geom_point() +
  theme_minimal() +
  theme(
    # axis.text.y = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_blank(),
    legend.position = 'none',
    axis.title.x = element_blank(),
    axis.title.y = element_text(size = 14),
    axis.text.x = element_text(size = 14),
    title = element_text(size = 14)
  ) +
  labs(title = 'Distribution of Player Experience by Team',
       subtitle = 'Players Appearing in 2024 League Cup Final',
       y = 'Total Career Appearances at Senior Level',
       caption = ' '
       # ,
       # caption = 'Source: Wikipedia 2024'
       ) +
  scale_fill_manual(values = livchels_colors)

age <-
  players |> 
  ggplot(aes(x = Team, y = Age, fill = Team)) +
  geom_boxplot() +
  geom_violin(alpha = .1) +
  geom_point() +
  theme_minimal() +
  theme(
    # axis.text.y = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_blank(),
    legend.position = 'none',
    axis.title.x = element_blank(),
    axis.title.y = element_text(size = 14),
    axis.text.x = element_text(size = 14),
    title = element_text(size = 14)
  ) +
  labs(
    title = ' ',
    subtitle = ' ',
  #   title = 'Distribution of Player Age by Team',
  #      subtitle = 'Players Appearing in 2024 League Cup Final',
#        y = 'Player Age'
# ,
       caption = 'Source: Wikipedia 2024'
) +
  scale_fill_manual(values = livchels_colors)

plot_grid(cap, age)
