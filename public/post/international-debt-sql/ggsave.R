
ggsave(here::here("international_debt.png"), width = 6, height = 8)
ggplot(countries) + 
  geom_chicklet(aes(x =  fct_reorder(country_name, total_debt),
                    y = total_debt,
                    fill = indicator_name), 
                color = NA, width = 0.8) + 
  geom_text(aes(country_name, total_debt, label = scales::label_number_si()(total_debt)),
            color = "white", nudge_y = -10000000000, family = "Overpass Mono", size = 8.5) + 
  scale_y_continuous(labels = scales::label_number_si(prefix = "$")) + 
  hrbrthemes::theme_modern_rc() + 
  nord::scale_fill_nord(palette = "afternoon_prarie", name = NA) + 
  theme(legend.position = "none",
        plot.title = element_text(size = 50, family = "Roboto Condensed"),
        plot.title.position = "plot",
        plot.subtitle = element_markdown(size = 35, family = "Roboto Condensed"),
        axis.text.y = element_text(face = "bold", size = 30),
        axis.text.x = element_text(size = 28),
        panel.grid.major.y = element_blank()) + 
  coord_flip(clip = "off") + 
  labs(x = NULL,
       y = NULL,
       title = "Top 20 Countries with Highest Total Debts",
       subtitle = "with highest contributions from long term <span style='color:#F0D8C0'>repayments</span> or <span style='color:#6078A8'>disbursements</span>")


