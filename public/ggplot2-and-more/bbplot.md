

# (PART) Themems and Layouts {-} 


# bbplot

参考 [bbc cookbook](https://bbc.github.io/rcookbook/)  


```r
# devtools::install_github('bbc/bbplot')
library(tidyverse)
library(bbplot)
knitr::opts_chunk$set(message=F,cache=T)
```


## 简介：`bbc_style()` 和 `finalize_plot()`

`bbplot` 包中有两个函数：`bbc_style()` 和 `finalise_plot()`

`bbc_style()` 封装了一些 ggplot2 中的主题设置，创建 BBC 风格的字号、字体、颜色、标度、边距等组件，不需要传入任何参数，这里列出几项它的重要设定：  

* 设置了图形标题、副标题、坐标轴刻度的字体、字号（调大）和风格（粗体），取消了坐标轴标题  
* 将图例移到上方，取消图例的标题和背景  
* 取消 y 方向的刻度线(`panel.grid.major.x = element_blank()`), 修改 x 方向的刻度线颜色(`panel.grid.major.y = element_line(color="#cbcbcb")`) 
* 取消绘图区背景 (`panel.background = element_blank()`)，将分面系统中的背景填充为白色   


```r
## 查看 bbc_style() 源码
xfun::file_string("R/bbc_style.R")
#> 
#> 
#> bbc_style <- function() {
#>   font <- "Helvetica"
#> 
#>   ggplot2::theme(
#> 
#>     #Text format:
#>     #This sets the font, size, type and colour of text for the chart's title
#>     plot.title = ggplot2::element_text(family=font,
#>                                        size=28,
#>                                        face="bold",
#>                                        color="#222222"),
#>     #This sets the font, size, type and colour of text for the chart's subtitle, as well as setting a margin between the title and the subtitle
#>     plot.subtitle = ggplot2::element_text(family=font,
#>                                           size=22,
#>                                           margin=ggplot2::margin(9,0,9,0)),
#>     plot.caption = ggplot2::element_blank(),
#>     #This leaves the caption text element empty, because it is set elsewhere in the finalise plot function
#> 
#>     #Legend format
#>     #This sets the position and alignment of the legend, removes a title and backround for it and sets the requirements for any text within the legend. The legend may often need some more manual tweaking when it comes to its exact position based on the plot coordinates.
#>     legend.position = "top",
#>     legend.text.align = 0,
#>     legend.background = ggplot2::element_blank(),
#>     legend.title = ggplot2::element_blank(),
#>     legend.key = ggplot2::element_blank(),
#>     legend.text = ggplot2::element_text(family=font,
#>                                         size=18,
#>                                         color="#222222"),
#> 
#>     #Axis format
#>     #This sets the text font, size and colour for the axis test, as well as setting the margins and removes lines and ticks. In some cases, axis lines and axis ticks are things we would want to have in the chart - the cookbook shows examples of how to do so.
#>     axis.title = ggplot2::element_blank(),
#>     axis.text = ggplot2::element_text(family=font,
#>                                       size=18,
#>                                       color="#222222"),
#>     axis.text.x = ggplot2::element_text(margin=ggplot2::margin(5, b = 10)),
#>     axis.ticks = ggplot2::element_blank(),
#>     axis.line = ggplot2::element_blank(),
#> 
#>     #Grid lines
#>     #This removes all minor gridlines and adds major y gridlines. In many cases you will want to change this to remove y gridlines and add x gridlines. The cookbook shows you examples for doing so
#>     panel.grid.minor = ggplot2::element_blank(),
#>     panel.grid.major.y = ggplot2::element_line(color="#cbcbcb"),
#>     panel.grid.major.x = ggplot2::element_blank(),
#> 
#>     #Blank background
#>     #This sets the panel background as blank, removing the standard grey ggplot background colour from the plot
#>     panel.background = ggplot2::element_blank(),
#> 
#>     #Strip background (#This sets the panel background for facet-wrapped plots to white, removing the standard grey ggplot background colour and sets the title size of the facet-wrap title to font size 22)
#>     strip.background = ggplot2::element_rect(fill="white"),
#>     strip.text = ggplot2::element_text(size  = 22,  hjust = 0)
#>   )
#> }
```


> 由于 Windows 系统没有 Helvetica 字体，使用 bbc_sytle() 时会触发警告 “	
font family not found in Windows font database”。可以用 windowsFonts(Helvetica = "TT Arial") 使 R 用 Arial 字体代替 Helvetica

需要注意的是折线图中的线条或者条形图中条形的颜色不由 `bbc_style()` 函数定制，需要使用标准的 ggplot 绘图函数指定。


 `finalise_plot()` 是在图表发布前进行最后加工的函数，能够使图表的标题和副标题左对齐、添加信息来源、在图表右下脚添加照片。它还能将图表保存至指定的位置。这个函数有5个参数：  
 
* `plot_name`: 变量名，如我们经常用变量 `p` 来存储 ggplot 图形  
* `source`:需要在图表左下角暂时的来源文字，需要在文字前先打上 "Source:",比如 `source = "Source: ONS"。  
* `svae_filepath`:图表的保存路径，需要包括.png 后缀。  
* `width_pixels`:默认 640 px。hieght_pixels:，默认 450 px。  
* `logo_image_path`:指定在图表右下角需要展示的 logo 保存的位置。默认是一个 png 格式的占位文件，颜色和图表的背景色一样。如果你不需要展示 logo， 则无需调整此参数。当你想给图表增加 logo 时，通过此参数指定 logo 的位置即可。

## 折线图  

使用 gapminder 数据集作一些试验：  


```r
library(gapminder)
gapminder
#> # A tibble: 1,704 x 6
#>   country     continent  year lifeExp      pop gdpPercap
#>   <fct>       <fct>     <int>   <dbl>    <int>     <dbl>
#> 1 Afghanistan Asia       1952    28.8  8425333      779.
#> 2 Afghanistan Asia       1957    30.3  9240934      821.
#> 3 Afghanistan Asia       1962    32.0 10267083      853.
#> 4 Afghanistan Asia       1967    34.0 11537966      836.
#> 5 Afghanistan Asia       1972    36.1 13079460      740.
#> 6 Afghanistan Asia       1977    38.4 14880372      786.
#> # ... with 1,698 more rows
```



```r
#Prepare data
windowsFonts(Helvetica = "TT Arial")
line_df <- gapminder %>%
  filter(country == "China") 

#Make plot
line <- ggplot(line_df, aes(x = year, y = lifeExp)) +
  geom_line(colour = "#1380A1", size = 1) +
  geom_hline(yintercept = 0, size = 1, colour="#333333")  ## 在 y = 0 处做一个标记是好习惯
line
```

<img src="bbplot_files/figure-html/unnamed-chunk-5-1.svg" width="90%" />

```r


## 添加 bbc_style()
line + bbc_style()
```

<img src="bbplot_files/figure-html/unnamed-chunk-5-2.svg" width="90%" />

```r
## 
line + 
  bbc_style() +
  labs(title="Living longer",
       subtitle = "Life expectancy in China 1952-2007") 
```

<img src="bbplot_files/figure-html/unnamed-chunk-5-3.svg" width="90%" />


下面绘制一个多重折线图： 

```r
multiple_line_df <- gapminder %>%
  filter(country == "China" | country == "United States")
```


```r
multiple_line <- ggplot(multiple_line_df) +
  geom_line(aes(year, lifeExp, color = country)) +
  geom_hline(yintercept = 0, size = 1, colour="#333333") +
  scale_colour_manual(values = c("#FAAB18", "#1380A1")) 

multiple_line
```

<img src="bbplot_files/figure-html/unnamed-chunk-7-1.svg" width="90%" />

添加 `bbc_style()` 和标题文字：  


```r
multiple_line + 
  bbc_style() + 
  labs(title="Living longer",
       subtitle = "Life expectancy in China and the US")
```

<img src="bbplot_files/figure-html/unnamed-chunk-8-1.svg" width="90%" />


假使这是我们最终想要发布的版本，可以用 `finalise_plot()` 加工并保存：  


```r
multiple_line <- multiple_line + 
  bbc_style() + 
  labs(title="Living longer",
       subtitle = "Life expectancy in China and the US")

finalise_plot(plot_name = multiple_line, source_name = "Source: Gapminder",
              save_filepath = "images\\line chart.png",
              logo_image_path = "images\\caution.png")
```

<img src="bbplot_files/figure-html/unnamed-chunk-9-1.svg" width="90%" />


随后我们可以在 images 文件夹中找到这个 png 文件：

<img src="images/finalise_plot.png" width="90%" />



## 条形图  

依旧使用 gapminder 数据： 


```r
bar_df <- gapminder %>%
  filter(year == 2007 & continent == "Africa") %>%
  arrange(desc(lifeExp)) %>%
  head(5)

bar_df
#> # A tibble: 5 x 6
#>   country   continent  year lifeExp      pop gdpPercap
#>   <fct>     <fct>     <int>   <dbl>    <int>     <dbl>
#> 1 Reunion   Africa     2007    76.4   798094     7670.
#> 2 Libya     Africa     2007    74.0  6036914    12057.
#> 3 Tunisia   Africa     2007    73.9 10276158     7093.
#> 4 Mauritius Africa     2007    72.8  1250882    10957.
#> 5 Algeria   Africa     2007    72.3 33333216     6223.
```



```r
## 绘制条形图 
bars <- ggplot(bar_df, aes(x = country, y = lifeExp)) +
  geom_bar(stat="identity", 
           position="identity", 
           fill="#1380A1") +
  geom_hline(yintercept = 0, size = 1, colour="#333333") 

bars
```

<img src="bbplot_files/figure-html/unnamed-chunk-12-1.svg" width="90%" />

```r

## 添加 bbc_style() 并添加标题
bars + 
  bbc_style() +
  labs(title = "Reunion is the highest",
       subtitle = "Highest African life expectancy, 2007")
```

<img src="bbplot_files/figure-html/unnamed-chunk-12-2.svg" width="90%" />

### 堆积条形图  



```r
#prepare data
stacked_df <- gapminder %>% 
  filter(year == 2007) %>%
  mutate(lifeExpGrouped = cut(lifeExp, 
                    breaks = c(0, 50, 65, 80, 90),
                    labels = c("Under 50", "50-65", "65-80", "80+"))) %>%
  group_by(continent, lifeExpGrouped) %>%
  summarise(continentPop = sum(as.numeric(pop)))

stacked_df
#> # A tibble: 13 x 3
#> # Groups:   continent [5]
#>   continent lifeExpGrouped continentPop
#>   <fct>     <fct>                 <dbl>
#> 1 Africa    Under 50          376100713
#> 2 Africa    50-65             386811458
#> 3 Africa    65-80             166627521
#> 4 Americas  50-65               8502814
#> 5 Americas  65-80             856978229
#> 6 Americas  80+                33390141
#> # ... with 7 more rows

#set order of stacks by changing factor levels
stacked_df$lifeExpGrouped = factor(stacked_df$lifeExpGrouped, 
                                   levels = rev(levels(stacked_df$lifeExpGrouped)))

## create plot
stacked_bars <- ggplot(data = stacked_df, aes(x = continent,
                           y = continentPop,
                           fill = lifeExpGrouped)) +
                  geom_bar(stat = "identity", 
                          position = "fill")

stacked_bars
```

<img src="bbplot_files/figure-html/unnamed-chunk-13-1.svg" width="90%" />


```r
## 添加 bbc_style()
stacked_bars + bbc_style()
```

<img src="bbplot_files/figure-html/unnamed-chunk-14-1.svg" width="90%" />

```r

## 完善  

stacked_bars +
  bbc_style() +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_viridis_d(direction = -1) +
  geom_hline(yintercept = 0, size = 1, colour = "#333333") +
  labs(title = "How life expectancy varies",
       subtitle = "% of population by life expectancy band, 2007") +
  theme(legend.justification = "left") + 
  guides(fill = guide_legend(reverse = TRUE))
```

<img src="bbplot_files/figure-html/unnamed-chunk-14-2.svg" width="90%" />


### 簇状条形图  


```r
## prepare data
grouped_bar_df <- gapminder %>%
    filter(year == 1967 | year == 2007) %>%
    head(10)
grouped_bar_df
#> # A tibble: 10 x 6
#>   country     continent  year lifeExp      pop gdpPercap
#>   <fct>       <fct>     <int>   <dbl>    <int>     <dbl>
#> 1 Afghanistan Asia       1967    34.0 11537966      836.
#> 2 Afghanistan Asia       2007    43.8 31889923      975.
#> 3 Albania     Europe     1967    66.2  1984060     2760.
#> 4 Albania     Europe     2007    76.4  3600523     5937.
#> 5 Algeria     Africa     1967    51.4 12760499     3247.
#> 6 Algeria     Africa     2007    72.3 33333216     6223.
#> # ... with 4 more rows
```


```r
grouped_bars <- ggplot(grouped_bar_df) +
  geom_bar(aes(country, lifeExp, fill = factor(year)),
           position = "dodge", stat = "identity") +
  geom_hline(yintercept = 0, size = 1, colour="#333333")

grouped_bars 
```

<img src="bbplot_files/figure-html/unnamed-chunk-16-1.svg" width="90%" />


```r
## 添加 bbc_style()
grouped_bars + 
  bbc_style() + 
  scale_fill_manual(values = c("#1380A1", "#FAAB18")) +
  labs(title="We're living longer",
       subtitle = "Biggest life expectancy rise, 1967-2007") +
  theme(axis.text.x = element_text(size = 14))  ## bbc_style() 默认设置字号为 18
```

<img src="bbplot_files/figure-html/unnamed-chunk-17-1.svg" width="90%" />

## 哑铃图  

这里哑铃图的作法用到了 ggalt 包中便捷的 `geom_dumbbell()` 函数：


```r
## prepare data
library(ggalt)
dumbbell_df <- gapminder %>%
  filter(year == 1967 | year == 2007) %>% 
  .[c("country", "year", "continent", "lifeExp")] %>%
  pivot_wider(names_from = year, values_from = lifeExp) %>%
  mutate(gap = `2007` - `1967`) %>%
  arrange(desc(gap)) %>%
  head(10)   ## 这里为了使用 geom_dumbbell() 没有再使用聚合函数

dumbbell_df
#> # A tibble: 10 x 5
#>   country     continent `1967` `2007`   gap
#>   <fct>       <fct>      <dbl>  <dbl> <dbl>
#> 1 Oman        Asia        47.0   75.6  28.7
#> 2 Vietnam     Asia        47.8   74.2  26.4
#> 3 Yemen, Rep. Asia        37.0   62.7  25.7
#> 4 Indonesia   Asia        46.0   70.6  24.7
#> 5 Libya       Africa      50.2   74.0  23.7
#> 6 Gambia      Africa      35.9   59.4  23.6
#> # ... with 4 more rows
```


```r

## create plot
dumbbell <- ggplot(dumbbell_df, 
                   aes(x = `1967`, xend = `2007`, y = country)) +
  geom_dumbbell(colour = "#dddddd",
                size = 3,
                colour_x = "#FAAB18",
                colour_xend = "#1380A1" )

dumbbell
```

<img src="bbplot_files/figure-html/unnamed-chunk-19-1.svg" width="90%" />


```r

## 添加 bbc_style()

dumbbell + bbc_style()
```

<img src="bbplot_files/figure-html/unnamed-chunk-20-1.svg" width="90%" />

```r

## 成图 
dumbbell + 
  bbc_style() +
  labs(title = "we're living longer",
       subtitle = "Biggest life expectancy rise, 1967-2007")
```

<img src="bbplot_files/figure-html/unnamed-chunk-20-2.svg" width="90%" />


## 直方图  


```r
## prepare data
hist_df <- gapminder %>%
  filter(year == 2007)


## create plot
hist_chart <- ggplot(hist_df) +
  geom_histogram(aes(lifeExp), binwidth = 5, 
                 colour = "white", fill = "#1380A1") +
  geom_hline(yintercept = 0, size = 1, colour = "#333333") + 
  scale_x_continuous(limits = c(35, 95),
                     breaks = seq(40, 90, by = 10),
                     labels = c("40", "50", "60", "70", "80", "90 years")) +
  labs(title = "How life expectancy varies",
       subtitle = "Distribution of life expectancy in 2007")

hist_chart
```

<img src="bbplot_files/figure-html/unnamed-chunk-21-1.svg" width="90%" />

```r
## 添加 bbc_style()
hist_chart + bbc_style()
```

<img src="bbplot_files/figure-html/unnamed-chunk-21-2.svg" width="90%" />

