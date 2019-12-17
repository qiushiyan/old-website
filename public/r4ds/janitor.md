

# (PART) Cleaning and Tidying {-}


# Janitor  

http://sfirke.github.io/janitor/articles/janitor.html  

**Janitor**[@R-janitor] 包提供了一些简单易用的函数方便数据清洗和探索流程。  





```r
library(janitor)
```


## 清洗  {#qingxi}


### `clean_names`  


`clean_names()` 将输入数据框的列名转换为整洁格式，与 `readxl::read_excel()` 和 `readr::read_csv()` 等不会擅自修改原列名的函数搭配使用效果最佳。 `clean_names()` 的 **输入输出** 都是数据框，这使它很适应和管道操作符 `%>%` 和 tidyverse 中的其他函数一同工作。  

列名的转换有以下几种主要情形：  

* 统一字母的大小写，采用一致的命名方式（默认为蛇形命名法 `snake_case`）  

* 自动为重复的列名编号，填充空的列名    

* 删除空格和某些特殊字符，如括号， `œ`、`oe`  

* "%" 转换至 "percent", "#" 转换至 "number"  




```r
# Create a data.frame with dirty names
test_df <- as.data.frame(matrix(ncol = 6))
names(test_df) <- c("firstName", "ábc@!*", "% successful (2009)",
                    "REPEAT VALUE", "REPEAT VALUE", "")
```



```r
# Clean the variable names, returning a data.frame:
test_df %>% 
  clean_names()
#>   first_name abc percent_successful_2009 repeat_value repeat_value_2  x
#> 1         NA  NA                      NA           NA             NA NA
```



与 Base R 中的 `make.names()` 对比 (注意这个函数不是基于数据框的)：  


```r
names(test_df) %>% 
  make.names()
#> [1] "firstName"            "ábc..."               "X..successful..2009."
#> [4] "REPEAT.VALUE"         "REPEAT.VALUE"         "X"
```

改变命名规范：  


```r
## snake_case  
test_df %>% 
  clean_names()
#>   first_name abc percent_successful_2009 repeat_value repeat_value_2  x
#> 1         NA  NA                      NA           NA             NA NA

## lower_camel and upper_camel  
test_df %>% 
  clean_names(case = "lower_camel")
#>   firstName abc percentSuccessful2009 repeatValue repeatValue_2  x
#> 1        NA  NA                    NA          NA            NA NA
test_df %>% 
  clean_names(case = "upper_camel")
#>   FirstName Abc PercentSuccessful2009 RepeatValue RepeatValue_2  X
#> 1        NA  NA                    NA          NA            NA NA
```


`make_clean_names()` 是 `clean_names()` 的向量版本，它还可以传入 `as_tibble()` 中的 `.name_repair` 参数中：  


```r
names(test_df) %>% 
  make_clean_names()
#> [1] "first_name"              "abc"                    
#> [3] "percent_successful_2009" "repeat_value"           
#> [5] "repeat_value_2"          "x"

as_tibble(iris, .name_repair  = janitor::make_clean_names)
#> # A tibble: 150 x 5
#>   sepal_length sepal_width petal_length petal_width species
#>          <dbl>       <dbl>        <dbl>       <dbl> <fct>  
#> 1          5.1         3.5          1.4         0.2 setosa 
#> 2          4.9         3            1.4         0.2 setosa 
#> 3          4.7         3.2          1.3         0.2 setosa 
#> 4          4.6         3.1          1.5         0.2 setosa 
#> 5          5           3.6          1.4         0.2 setosa 
#> 6          5.4         3.9          1.7         0.4 setosa 
#> # … with 144 more rows
```



### `compare_df_cols`  

使用 `dplyr::bind_rows()` 或者 `rbind()，或者存在子集关系。 `compare_df_cols()` 检查多个数据框或者数据框列表，并检查其各个列是否一致：  


```r
df1 <- data.frame(a = 1:2, b = c("big", "small")) # a factor by default
df2 <- data.frame(a = 10:12, b = c("medium", "small", "big"), c = 0, stringsAsFactors = FALSE)
df3 <- df1 %>%
  mutate(b = as.character(b))
```


```r
compare_df_cols(df1, df2, df3)
#>   column_name     df1       df2       df3
#> 1           a integer   integer   integer
#> 2           b  factor character character
#> 3           c    <NA>   numeric      <NA>
```


```r
compare_df_cols(df1, df2, df3, return = "mismatch")
#>   column_name    df1       df2       df3
#> 1           b factor character character
```

`dplyr::bind_rows()` 比 `rbind()` 的合并要宽松，允许某些数据框的列集合是其余数据框的子集：  


```r
compare_df_cols(df1, df2, df3, return = "mismatch", bind_method = "rbind") 
#>   column_name    df1       df2       df3
#> 1           b factor character character
#> 2           c   <NA>   numeric      <NA>
# default is dplyr::bind_rows
```


`compare_df_cols_same` 返回 `TRUE` 或 `FALSE`:  


```r
compare_df_cols_same(df1, df3)
#>   column_name    ..1       ..2
#> 1           b factor character
#> [1] FALSE
compare_df_cols_same(df2, df3)
#> [1] TRUE
```


## 探索 {#tansuo}

  
### `tabyl`  


`tabyl()` 的设计初衷是替代 Base R 中 `table()`，后者有几个缺点：  

* 不接受数据框输入  
* 不返回数据框  
* 返回的结果很难进一步修饰  

`tabyl()` 用于构建 1 ~ 3 个变量的（交叉）频数表，它 建立在 dplyr 和 tidyr 之上，所以以数据框基本输入、输出对象（但也可以接受一维向量），janitor 还提供了 `adorn_*` 函数族对其返回的表格进行修饰。以 `starwars`的一个子集演示 `tabyl()` 的用法：  


```r
humans <- starwars %>% 
  filter(species == "Human")
```


___  

**One-way tabyl**  

一维频数表  


```r
t1 <- humans %>%
  tabyl(eye_color)

t1
#>  eye_color  n percent
#>       blue 12  0.3429
#>  blue-gray  1  0.0286
#>      brown 17  0.4857
#>       dark  1  0.0286
#>      hazel  2  0.0571
#>     yellow  2  0.0571
```

`tably()` 可以聪明地处理数据中包含缺失值的情况：  


```r
x <- c("big", "big", "small", "small", "small", NA)

tabyl(x)
#>      x n percent valid_percent
#>    big 2   0.333           0.4
#>  small 3   0.500           0.6
#>   <NA> 1   0.167            NA
tabyl(x, show_na = F)
#>      x n percent
#>    big 2     0.4
#>  small 3     0.6
```

大部分 `adorn_*` 函数主要用于二维列联表，但也可以适用一维频数表：  


```r
t1 %>% 
  adorn_pct_formatting()
#>  eye_color  n percent
#>       blue 12   34.3%
#>  blue-gray  1    2.9%
#>      brown 17   48.6%
#>       dark  1    2.9%
#>      hazel  2    5.7%
#>     yellow  2    5.7%
```


___


**Two-way tabyl**  

`df %>% tabyl(var_1, var_2)` 等同于 `df %>% count(var_1, var_2)` 后 `pivot_wider()` 展开其中的某一列，生成列联表：  


```r
t2 <- humans %>%
  tabyl(gender, eye_color)

t2
#>  gender blue blue-gray brown dark hazel yellow
#>  female    3         0     5    0     1      0
#>    male    9         1    12    1     1      2
```


```r
# count() + pivot_wider()
humans %>% 
  count(gender, eye_color) %>% 
  pivot_wider(names_from = eye_color, values_from = n)
#> # A tibble: 2 x 7
#>   gender  blue brown hazel `blue-gray`  dark yellow
#>   <chr>  <int> <int> <int>       <int> <int>  <int>
#> 1 female     3     5     1          NA    NA     NA
#> 2 male       9    12     1           1     1      2
```

用于修饰的 `adorn_*` 函数有：  

* `adorn_totals(c("row", "col"))`: 添加行列汇总  
* `adorn_percentages(c("row", "col"))`： 将交叉表的指替换为行或列百分比  
* `adorn_pct_formatting(digits, rounding)`: 决定百分比的格式  
* `adorn_rounding()`: Round a data.frame of numbers (usually the result of `adorn_percentages`), either using the base R `round()` function or using janitor's `round_half_up()` to round all ties up (thanks, StackOverflow).
    * e.g., round 10.5 up to 11, consistent with Excel's tie-breaking behavior.
    * This contrasts with rounding 10.5 down to 10 as in base R's `round(10.5)`.
    * `adorn_rounding()` returns columns of class numeric, allowing for graphing, sorting, etc. It's a less-aggressive substitute for `adorn_pct_formatting()`; these two functions should not be called together.

* `adorn_ns()`: add `Ns` to a `tabyl`. These can be drawn from the tabyl's underlying counts, which are attached to the tabyl as metadata, or they can be supplied by the user.  

* `adorn_title(placement, row_name, col_name)`: "combined" 或者 "top"，调整行变量名称的位置  


注意在应用这些帮助函数时要遵从一定的逻辑顺序。例如，`adorn_ns()` 和 `adorn_percent_fomatting()` 应该在调用 `adorn_percentages()` 之后。  


对 `t2` 应用 `adorn_*` 函数：  


```r
t2 %>% 
  adorn_totals("col") %>% 
  adorn_percentages("row") %>%
  adorn_pct_formatting(digits = 2) %>% 
  adorn_ns() %>%
  adorn_title("combined")
#>  gender/eye_color       blue blue-gray       brown      dark      hazel
#>            female 33.33% (3) 0.00% (0) 55.56%  (5) 0.00% (0) 11.11% (1)
#>              male 34.62% (9) 3.85% (1) 46.15% (12) 3.85% (1)  3.85% (1)
#>     yellow        Total
#>  0.00% (0) 100.00%  (9)
#>  7.69% (2) 100.00% (26)
```



`tabyl` 对象最终可以传入 `knitr::kabel()` 中呈现


```r
t2 %>% 
  adorn_totals("row") %>% 
  adorn_percentages("col") %>%
  adorn_pct_formatting(digits = 1) %>% 
  adorn_ns() %>%
  adorn_title("top", row_name = "gender", col_name = "color") %>%
  knitr::kable()
```

         color                                                                         
-------  ------------  -----------  ------------  -----------  -----------  -----------
gender   blue          blue-gray    brown         dark         hazel        yellow     
female   25.0%  (3)    0.0% (0)     29.4%  (5)    0.0% (0)     50.0% (1)    0.0% (0)   
male     75.0%  (9)    100.0% (1)   70.6% (12)    100.0% (1)   50.0% (1)    100.0% (2) 
Total    100.0% (12)   100.0% (1)   100.0% (17)   100.0% (1)   100.0% (2)   100.0% (2) 




___

**Three-way tabyl**  

在 `tabyl()` 中传入三个变量时，返回一个二维 `tabyl` 的列表：  


```r
t3 <- humans %>%
  tabyl(eye_color, skin_color, gender)

t3
#> $female
#>  eye_color dark fair light pale tan white
#>       blue    0    2     1    0   0     0
#>  blue-gray    0    0     0    0   0     0
#>      brown    0    1     4    0   0     0
#>       dark    0    0     0    0   0     0
#>      hazel    0    0     1    0   0     0
#>     yellow    0    0     0    0   0     0
#> 
#> $male
#>  eye_color dark fair light pale tan white
#>       blue    0    7     2    0   0     0
#>  blue-gray    0    1     0    0   0     0
#>      brown    3    4     3    0   2     0
#>       dark    1    0     0    0   0     0
#>      hazel    0    1     0    0   0     0
#>     yellow    0    0     0    1   0     1
```

这时的 `adorn_*` 函数将会应用于列表中的每个 `tabyl` 元素：  


```r
t3 %>% 
  adorn_percentages("row") %>%
  adorn_pct_formatting(digits = 0) %>%
  adorn_ns()
#> $female
#>  eye_color   dark    fair    light   pale    tan  white
#>       blue 0% (0) 67% (2)  33% (1) 0% (0) 0% (0) 0% (0)
#>  blue-gray  - (0)   - (0)    - (0)  - (0)  - (0)  - (0)
#>      brown 0% (0) 20% (1)  80% (4) 0% (0) 0% (0) 0% (0)
#>       dark  - (0)   - (0)    - (0)  - (0)  - (0)  - (0)
#>      hazel 0% (0)  0% (0) 100% (1) 0% (0) 0% (0) 0% (0)
#>     yellow  - (0)   - (0)    - (0)  - (0)  - (0)  - (0)
#> 
#> $male
#>  eye_color     dark     fair   light    pale     tan   white
#>       blue   0% (0)  78% (7) 22% (2)  0% (0)  0% (0)  0% (0)
#>  blue-gray   0% (0) 100% (1)  0% (0)  0% (0)  0% (0)  0% (0)
#>      brown  25% (3)  33% (4) 25% (3)  0% (0) 17% (2)  0% (0)
#>       dark 100% (1)   0% (0)  0% (0)  0% (0)  0% (0)  0% (0)
#>      hazel   0% (0) 100% (1)  0% (0)  0% (0)  0% (0)  0% (0)
#>     yellow   0% (0)   0% (0)  0% (0) 50% (1)  0% (0) 50% (1)
```


### `get_dupes`  

`get_dupes(dat, ...)` 返回数据框`dat`中在变量`...`上重复的观测，以及重复的次数：  


```r
mtcars %>% 
  get_dupes(wt, cyl)
#> # A tibble: 4 x 12
#>      wt   cyl dupe_count   mpg  disp    hp  drat  qsec    vs    am  gear  carb
#>   <dbl> <dbl>      <int> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1  3.44     6          2  19.2  168.   123  3.92  18.3     1     0     4     4
#> 2  3.44     6          2  17.8  168.   123  3.92  18.9     1     0     4     4
#> 3  3.57     8          2  14.3  360    245  3.21  15.8     0     0     3     4
#> 4  3.57     8          2  15    301    335  3.54  14.6     0     1     5     8
```

### `remove_`  

#### `remove_empty`  

`remove_empty(c("rows", "cols"))` 移除行或列（或行和列）上全为 `NA` 值的观测：  


```r
q <- data.frame(v1 = c(1, NA, 3),
                v2 = c(NA, NA, NA),
                v3 = c("a", NA, "b"))
q %>%
  remove_empty(c("rows", "cols"))
#>   v1 v3
#> 1  1  a
#> 3  3  b

q %>% 
  remove_empty("rows")
#>   v1 v2 v3
#> 1  1 NA  a
#> 3  3 NA  b

q %>% 
  remove_empty("cols")
#>   v1   v3
#> 1  1    a
#> 2 NA <NA>
#> 3  3    b
```


`remove_empty` 的实现原理很简单，以移除空的行观测为例：如果某行全为 `NA`，则该行对应的 `rowSums(is.na(dat)) = ncol(dat)`:   

```r
function (dat, which = c("rows", "cols")) 
{
    if (missing(which) && !missing(dat)) {
        message("value for \"which\" not specified, defaulting to c(\"rows\", \"cols\")")
        which <- c("rows", "cols")
    }
    if ((sum(which %in% c("rows", "cols")) != length(which)) && 
        !missing(dat)) {
        stop("\"which\" must be one of \"rows\", \"cols\", or c(\"rows\", \"cols\")")
    }
    if ("rows" %in% which) {
        dat <- dat[rowSums(is.na(dat)) != ncol(dat), , drop = FALSE]
    }
    if ("cols" %in% which) {
        dat <- dat[, colSums(!is.na(dat)) > 0, drop = FALSE]
    }
    dat
}
```


#### `remove_constant`

`remove_constant()` 移除数据框中的常数列：  


```r
a <- data.frame(good = 1:3, boring = "the same")
a %>% remove_constant()
#>   good
#> 1    1
#> 2    2
#> 3    3
```


### `round_half_up`  

Base R 中的取整函数 `round()` 采取的规则是 “四舍六入五留双”（Banker's Rounding，当小数位是 .5 时，若前一位是奇数，则进 1 ； 若前一位数偶数，则退一）：  


```r
nums <- c(2.5, 3.5)
round(nums)
#> [1] 2 4
```

`round_half_up` 遵循最简单的四舍五入规则:  


```r
round_half_up(nums)
#> [1] 3 4
```

若希望取整到特定的小数位，例如 0, 0.25, 0.5, 0.75, 1。可以用 `round_half_fraction()` 并指定除数  

### `excel_numeric_to_date`  

`excel_numeric_to_date()` 按照 Excel 编码日期的规则(1989/12/31 = 1) 将整数转换为数字：  


```r
excel_numeric_to_date(41103)
#> [1] "2012-07-13"
excel_numeric_to_date(41103.01) # ignores decimal places, returns Date object
#> [1] "2012-07-13"
```


### `top_levels`  

在李克特量表数据的分析中，常需要知道某个态度变量中占比最高的几个水平，这样的变量在 R 中以有序因子的方式储存，`top_levels()` 将有序因子的所有水平分为三组（左，中间，右），并分别呈现各组的频数：  


```r
f <- factor(c("strongly agree", "agree", "neutral", "neutral", "disagree", "strongly agree"),
            levels = c("strongly agree", "agree", "neutral", "disagree", "strongly disagree"))
top_levels(f)
#>                            f n percent
#>        strongly agree, agree 3   0.500
#>                      neutral 2   0.333
#>  disagree, strongly disagree 1   0.167
```



```r
top_levels(as.factor(mtcars$hp))
#>                  as.factor(mtcars$hp)  n percent
#>                                52, 62  2  0.0625
#>  <<< Middle Group (18 categories) >>> 28  0.8750
#>                              264, 335  2  0.0625
```


改变两侧分组包含水平的个数：  


```r
top_levels(as.factor(mtcars$hp), n = 4)
#>                  as.factor(mtcars$hp)  n percent
#>                        52, 62, 65, 66  5   0.156
#>  <<< Middle Group (14 categories) >>> 22   0.688
#>                    230, 245, 264, 335  5   0.156
```


### `row_to_names`  

`row_to_names()` 将某个观测行提升至列名：  


```r
dirt <- data.frame(X_1 = c(NA, "ID", 1:3),
           X_2 = c(NA, "Value", 4:6))

dirt
#>    X_1   X_2
#> 1 <NA>  <NA>
#> 2   ID Value
#> 3    1     4
#> 4    2     5
#> 5    3     6

dirt %>% 
  row_to_names(row_number = 2, remove_rows_above = F)  
#>     ID Value
#> 1 <NA>  <NA>
#> 3    1     4
#> 4    2     5
#> 5    3     6

dirt %>% 
  row_to_names(row_number = 2, remove_rows_above = T)  
#>   ID Value
#> 3  1     4
#> 4  2     5
#> 5  3     6
```



