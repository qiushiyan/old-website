

# (PART) 实例 {-}

# Schizophrenia Births in Australia



```r
library(viridis)
library(season)
library(gridExtra)

pa <- ggplot(schz, aes(year, month, fill = SczBroad)) + 
  geom_tile(color = "gray20", size = 1.5, stat = "identity") + 
  scale_fill_viridis(option = "A") +
  scale_y_continuous(breaks = 1:12, labels = month.abb[1:12])+
  xlab("") + 
  ylab("") +
  ggtitle("Total Australian Schizophrenics Born By Month and Year") +
  theme(
    plot.title = element_text(color="white",hjust=0,vjust=1, size=rel(2)),
    plot.background = element_rect(fill="gray20"),
    panel.background = element_rect(fill="gray20"),
    panel.border = element_rect(fill=NA,color="gray20", size=0.5, linetype="solid"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank(), 
    axis.text = element_text(color="white", size=rel(1.5)),
    axis.text.y  = element_text(hjust=1),
    legend.text = element_text(color="white", size=rel(1.3)),
    legend.background = element_rect(fill="gray20"),
    legend.position = "bottom",
    legend.title=element_blank()
  )
```

