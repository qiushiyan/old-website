---
title: Working with JSON Columns in R
author: Qiushi Yan
date: '2020-05-15'
slug: json-column-r
categories:
  - R
subtitle: 'data cleaning tips in R when your df contains a json column'
summary: 'data cleaning tips in R when your df contains a json column'
authors: []
lastmod: '2020-05-15T17:40:47+08:00'
---

# JSON data in R





JSON, as a lightweight and flexible data format originating in JavaScript, has been widely used in web APIs, NoSQL databases and relational databases. There is a natural mapping from js datatypes to that in R. Arrays containing primitives in js are seen as an analogy for atomic vectors in R, as js objects are for R's named lists. The [`jsonlite`](https://github.com/jeroen/jsonlite) package is a famous converter of this sort for R users. For example:  


```r
library(jsonlite)
library(dplyr)
library(tidyr)
library(purrr)
library(stringr)
library(readr)

# a json-like string
my_json <- '{"firt_name": "Qiushi", "last_name": "Yan"}'
fromJSON(my_json)
#> $firt_name
#> [1] "Qiushi"
#> 
#> $last_name
#> [1] "Yan"
```

Note that for `fromJSON` to work properly, one has to use double quotes for or JS keys and strings. 

Further, if we wrap the string in brackets, which makes it a array in js, `fromJSON` will convert it into a data frame. Or you could use `fromJSON + as_tibble` without brackets.


```r
str_c("[", my_json, "]") %>%
  fromJSON()
#>   firt_name last_name
#> 1    Qiushi       Yan

my_json %>% 
  fromJSON() %>% 
  as_tibble()
#> # A tibble: 1 × 2
#>   firt_name last_name
#>   <chr>     <chr>    
#> 1 Qiushi    Yan
```

However, `fromJSON` is more tailored to the need for converting a single long json string, not a character vector. Yet it is often the case that we find a column containing series of json strings in our data frame. I'll start with a character vector:


```r
# a character vector containing json-like strings
friends <- c('{"name": "Monica", "detail": {"job": ["chef"], "hobby": "cleaning"}}',
            '{"name": "Ross", "detail": {"job": ["paleontologist", "professor"], "hobby": "dinosaurs"}}',
            '{"name": "Chandler", "detail": {"job": ["IT procurement", "copywriter"], "hobby": "bubble bath"}}',
            '{"name": "Joey", "detail": {"job": ["actor"], "hobby": "sandwich"}}',
            '{"name": "Rachel", "detail": {"job": ["waitress", "fashion exec"], "hobby": "shopping"}}',
            '{"name": "Pheobe", "detail": {"job": ["masseuse", "musician"],   "hobby": "guitar"}}')
```




```r
# this will work
fromJSON(friends[[2]]) 
#> $name
#> [1] "Ross"
#> 
#> $detail
#> $detail$job
#> [1] "paleontologist" "professor"     
#> 
#> $detail$hobby
#> [1] "dinosaurs"

# this won't
fromJSON(friends)
#> Error: parse error: trailing garbage
#>           hef"], "hobby": "cleaning"}} {"name": "Ross", "detail": {"jo
#>                      (right here) ------^
```


**Solution A**: Collapse the character vector into a single string.


```r
friends_df <- str_c(friends, collapse = ", ") %>% 
  str_c("[", ., "]") %>% 
  fromJSON() %>% 
  as_tibble()

friends_df
#> # A tibble: 6 × 2
#>   name     detail$job $hobby     
#>   <chr>    <list>     <chr>      
#> 1 Monica   <chr [1]>  cleaning   
#> 2 Ross     <chr [2]>  dinosaurs  
#> 3 Chandler <chr [2]>  bubble bath
#> 4 Joey     <chr [1]>  sandwich   
#> 5 Rachel   <chr [2]>  shopping   
#> 6 Pheobe   <chr [2]>  guitar
```

`fromJSON` makes a successful parsing, though the results are a bit strange. `detail` is a data frame column inside the top resulting data frame `friends_df`. This is because `friends` has a hierarchical structure, with `name` and `detail` on the top, and `job`, `hobby` below the `detail` branch. 


```r
friends_df$detail
#>                          job       hobby
#> 1                       chef    cleaning
#> 2  paleontologist, professor   dinosaurs
#> 3 IT procurement, copywriter bubble bath
#> 4                      actor    sandwich
#> 5     waitress, fashion exec    shopping
#> 6         masseuse, musician      guitar
```

`tidyr::unpack()` makes data wider by expanding thsi df-column back out into individual columns.  


```r
friends_df %>% 
  unpack(detail)
#> # A tibble: 6 × 3
#>   name     job       hobby      
#>   <chr>    <list>    <chr>      
#> 1 Monica   <chr [1]> cleaning   
#> 2 Ross     <chr [2]> dinosaurs  
#> 3 Chandler <chr [2]> bubble bath
#> 4 Joey     <chr [1]> sandwich   
#> 5 Rachel   <chr [2]> shopping   
#> 6 Pheobe   <chr [2]> guitar
```

Now, we have a much simplified data frame at hand. `job` is still a list-column, but we could unnest it easily or leave it be anyway.


**Solution B**: Use `map` family functions or `for` loop. Both ways tidy this vector with the same strategy, which is to split it, apply `fromJSON` to each element, and combine the results.   


```r
friends %>% 
  map_dfr(~ fromJSON(.x) %>% 
        as.data.frame)
#>        name     detail.job detail.hobby
#> 1    Monica           chef     cleaning
#> 2      Ross paleontologist    dinosaurs
#> 3      Ross      professor    dinosaurs
#> 4  Chandler IT procurement  bubble bath
#> 5  Chandler     copywriter  bubble bath
#> 6      Joey          actor     sandwich
#> 7    Rachel       waitress     shopping
#> 8    Rachel   fashion exec     shopping
#> 9    Pheobe       masseuse       guitar
#> 10   Pheobe       musician       guitar
```



For real data frames containing json columns, we could simply pull that column out, apply the strategies above, and combine the results back to the original df,  as shown below: 

```r
parser <- function(df, col) {
  json_df <- df %>% 
    pull({{ col }}) %>% 
    str_c(collapse = ",") %>% 
    str_c("[", ., "]") %>% 
    fromJSON() %>% 
    unpack(detail)
  
  bind_cols(df %>% select(-{{ col }}), json_df)
} 

tibble(index = 1:6, friends = friends) %>% 
  parser(friends)
#> # A tibble: 6 × 4
#>   index name     job       hobby      
#>   <int> <chr>    <list>    <chr>      
#> 1     1 Monica   <chr [1]> cleaning   
#> 2     2 Ross     <chr [2]> dinosaurs  
#> 3     3 Chandler <chr [2]> bubble bath
#> 4     4 Joey     <chr [1]> sandwich   
#> 5     5 Rachel   <chr [2]> shopping   
#> 6     6 Pheobe   <chr [2]> guitar
```

But this works only when there is only one json column, namely `col`. A general approach is to use `map` family functions again, this time looping through multiple json columns.


```r
json_col_1 <-  c('{"name": "A", "salary": 1000}',
                '{"name": "B", "salary": 5000}',
                '{"name": "C", "salary": 2000}')
json_col_2 <- c('{"ratings": 10}',
                '{"ratings": 9}',
                '{"ratings": 9.5}')

parser_multiple <- function(x) {
  str_c(x, collapse = ",") %>% 
    str_c("[", ., "]") %>% 
    fromJSON()
} 


tibble(index = 1:3, json_col_1, json_col_2) %>% 
  select(json_col_1, json_col_2) %>% 
  map_dfc(parser_multiple)
#>   name salary ratings
#> 1    A   1000    10.0
#> 2    B   5000     9.0
#> 3    C   2000     9.5
```



# The tidyjson package

The [`tidyjson`](https://github.com/colearendt/tidyjson) package provides many untility functions for working with in json data in R, extending `formJSON`. `spread_all` is the core function:


```r
library(tidyjson)
```



```r
# Define a simple people JSON collection
people <- c('{"age": 32, "name": {"first": "Bob",   "last": "Smith"}}',
            '{"age": 54, "name": {"first": "Susan", "last": "Doe"}}',
            '{"age": 18, "name": {"first": "Ann",   "last": "Jones"}}')

# Tidy the JSON data
people %>% spread_all()
#> # A tbl_json: 3 x 5 tibble with a "JSON" attribute
#>   ..JSON                  document.id   age name.first name.last
#>   <chr>                         <int> <dbl> <chr>      <chr>    
#> 1 "{\"age\":32,\"name..."           1    32 Bob        Smith    
#> 2 "{\"age\":54,\"name..."           2    54 Susan      Doe      
#> 3 "{\"age\":18,\"name..."           3    18 Ann        Jones
```
This produces a `tbl_json` object, where each row corresponds to an element of the people vector (a “document” in tidyjson). The JSON attribute of the `tbl_json` object is shown first, then the columns of the tibble are shown: a `document.id` indicating document in which the row originated.  

On the other hand, `spread_all` cannot spread arrays, this is when `gather_array` come into use. Consider the `worldbank` data built in the package, it is a 500 length character vector of projects funded by the world bank



```r
worldbank %>%
  spread_all()
#> # A tbl_json: 500 x 9 tibble with a "JSON" attribute
#>    ..JSON document.id boardapprovalda… closingdate countryshortname project_name
#>    <chr>        <int> <chr>            <chr>       <chr>            <chr>       
#>  1 "{\"_…           1 2013-11-12T00:0… 2018-07-07… Ethiopia         Ethiopia Ge…
#>  2 "{\"_…           2 2013-11-04T00:0… <NA>        Tunisia          TN: DTF Soc…
#>  3 "{\"_…           3 2013-11-01T00:0… <NA>        Tuvalu           Tuvalu Avia…
#>  4 "{\"_…           4 2013-10-31T00:0… <NA>        Yemen, Republic… Gov't and C…
#>  5 "{\"_…           5 2013-10-31T00:0… 2019-04-30… Lesotho          Second Priv…
#>  6 "{\"_…           6 2013-10-31T00:0… <NA>        Kenya            Additional …
#>  7 "{\"_…           7 2013-10-29T00:0… 2019-06-30… India            National Hi…
#>  8 "{\"_…           8 2013-10-29T00:0… <NA>        China            China Renew…
#>  9 "{\"_…           9 2013-10-29T00:0… 2018-12-31… India            Rajasthan R…
#> 10 "{\"_…          10 2013-10-29T00:0… 2014-12-31… Morocco          MA Accounta…
#> # … with 490 more rows, and 3 more variables: regionname <chr>, totalamt <dbl>,
#> #   _id.$oid <chr>
```

If you take a careful look at the actual object in js, you'll notice that one key is missing in the 9 columns printed above, namely `majorsector_percent`, because its paired value is an array. 


```r
worldbank[1]
#> [1] "{\"_id\":{\"$oid\":\"52b213b38594d8a2be17c780\"},\"boardapprovaldate\":\"2013-11-12T00:00:00Z\",\"closingdate\":\"2018-07-07T00:00:00Z\",\"countryshortname\":\"Ethiopia\",\"majorsector_percent\":[{\"Name\":\"Education\",\"Percent\":46},{\"Name\":\"Education\",\"Percent\":26},{\"Name\":\"Public Administration, Law, and Justice\",\"Percent\":16},{\"Name\":\"Education\",\"Percent\":12}],\"project_name\":\"Ethiopia General Education Quality Improvement Project II\",\"regionname\":\"Africa\",\"totalamt\":130000000}"
```


We can validate this first using `gather_object` (separates a JSON object into multiple rows of name-value pairs), and then look at each value's data type in JS with `json_types`  (inspects the json associated with each row) 


```r
worldbank %>% 
  gather_object() %>% 
  json_types() %>% 
  count(name, type)
#> # A tibble: 8 × 3
#>   name                type       n
#>   <chr>               <fct>  <int>
#> 1 _id                 object   500
#> 2 boardapprovaldate   string   500
#> 3 closingdate         string   370
#> 4 countryshortname    string   500
#> 5 majorsector_percent array    500
#> 6 project_name        string   500
#> 7 regionname          string   500
#> 8 totalamt            number   500
```

We can use `enter_object` to extract any name-value pair from the entire json string, then use `gather_array` and `spread_all`:


```r
worldbank %>% 
  enter_object(majorsector_percent) %>%
  gather_array() %>%
  spread_all()
#> # A tbl_json: 1,405 x 5 tibble with a "JSON" attribute
#>    ..JSON                  document.id array.index Name                  Percent
#>    <chr>                         <int>       <int> <chr>                   <dbl>
#>  1 "{\"Name\":\"Educat..."           1           1 Education                  46
#>  2 "{\"Name\":\"Educat..."           1           2 Education                  26
#>  3 "{\"Name\":\"Public..."           1           3 Public Administratio…      16
#>  4 "{\"Name\":\"Educat..."           1           4 Education                  12
#>  5 "{\"Name\":\"Public..."           2           1 Public Administratio…      70
#>  6 "{\"Name\":\"Public..."           2           2 Public Administratio…      30
#>  7 "{\"Name\":\"Transp..."           3           1 Transportation            100
#>  8 "{\"Name\":\"Health..."           4           1 Health and other soc…     100
#>  9 "{\"Name\":\"Indust..."           5           1 Industry and trade         50
#> 10 "{\"Name\":\"Indust..."           5           2 Industry and trade         40
#> # … with 1,395 more rows
```

These steps can be readily combined with the initial spread, just enter into the unsolved `majorsector_percent` after the first `spread_all`


```r
worldbank %>%
  spread_all() %>% 
  enter_object(majorsector_percent) %>% 
  gather_array() %>% 
  spread_all()
#> # A tbl_json: 1,405 x 12 tibble with a "JSON" attribute
#>    ..JSON document.id boardapprovalda… closingdate countryshortname project_name
#>    <chr>        <int> <chr>            <chr>       <chr>            <chr>       
#>  1 "{\"N…           1 2013-11-12T00:0… 2018-07-07… Ethiopia         Ethiopia Ge…
#>  2 "{\"N…           1 2013-11-12T00:0… 2018-07-07… Ethiopia         Ethiopia Ge…
#>  3 "{\"N…           1 2013-11-12T00:0… 2018-07-07… Ethiopia         Ethiopia Ge…
#>  4 "{\"N…           1 2013-11-12T00:0… 2018-07-07… Ethiopia         Ethiopia Ge…
#>  5 "{\"N…           2 2013-11-04T00:0… <NA>        Tunisia          TN: DTF Soc…
#>  6 "{\"N…           2 2013-11-04T00:0… <NA>        Tunisia          TN: DTF Soc…
#>  7 "{\"N…           3 2013-11-01T00:0… <NA>        Tuvalu           Tuvalu Avia…
#>  8 "{\"N…           4 2013-10-31T00:0… <NA>        Yemen, Republic… Gov't and C…
#>  9 "{\"N…           5 2013-10-31T00:0… 2019-04-30… Lesotho          Second Priv…
#> 10 "{\"N…           5 2013-10-31T00:0… 2019-04-30… Lesotho          Second Priv…
#> # … with 1,395 more rows, and 6 more variables: regionname <chr>,
#> #   totalamt <dbl>, _id.$oid <chr>, array.index <int>, Name <chr>,
#> #   Percent <dbl>
```

Sometimes the array contains just numbers or strings, where `spread_all` again fails to extract. But in such simple cases one can use regular expressions anyway. And I find this trick that if you enter into an array, you can copy the `..JSON` column with `mutate`, and the result is a lovely list column. 


```r
people_array <- c('{"age": 32, "name": {"first": "Bob",   "last": "Smith"}, 
                  "workday": ["Monday", "Tuesday"]}',
                  '{"age": 54, "name": {"first": "Susan", "last": "Doe"}, 
                  "workday":["Monday", "Wednesday", "Sunday"]}',
                  '{"age": 18, "name": {"first": "Ann",   "last": "Jones"}, 
                  "workday": ["Tuesday"]}')


# enter into array and copy the ..JSON column
people_array %>% 
  spread_all %>% 
  enter_object(workday) %>% 
  mutate(workday = ..JSON)
#> # A tbl_json: 3 x 6 tibble with a "JSON" attribute
#>   ..JSON                  document.id   age name.first name.last workday   
#>   <chr>                         <int> <dbl> <chr>      <chr>     <list>    
#> 1 "[\"Monday\",\"Tues..."           1    32 Bob        Smith     <list [2]>
#> 2 "[\"Monday\",\"Wedn..."           2    54 Susan      Doe       <list [3]>
#> 3 "[\"Tuesday\"]"                   3    18 Ann        Jones     <list [1]>
```



```r
# this doesn't work
people_array %>% 
  spread_all %>% 
  enter_object(workday) %>% 
  spread_all()
#> # A tbl_json: 3 x 5 tibble with a "JSON" attribute
#>   ..JSON                  document.id   age name.first name.last
#>   <chr>                         <int> <dbl> <chr>      <chr>    
#> 1 "[\"Monday\",\"Tues..."           1    32 Bob        Smith    
#> 2 "[\"Monday\",\"Wedn..."           2    54 Susan      Doe      
#> 3 "[\"Tuesday\"]"                   3    18 Ann        Jones
```


The `spread_values` function gives even more fine-tuend control on extract specific values from json objects, much similiar to `tidyr::hoist`. See its [documentation](https://cran.r-project.org/web/packages/tidyjson/) for more details. 


Here is an example of `spread_values` on `friends`

```r
friends %>% 
  spread_values(
    name = jstring("name"),
    hobby = jstring("detail", "hobby")
  ) %>% 
  enter_object(detail, job) %>% 
  mutate(job = ..JSON) %>% 
  unnest_longer(job)
#> # A tibble: 10 × 5
#>    document.id name     hobby       job            ..JSON    
#>          <int> <chr>    <chr>       <chr>          <list>    
#>  1           1 Monica   cleaning    chef           <list [1]>
#>  2           2 Ross     dinosaurs   paleontologist <list [2]>
#>  3           2 Ross     dinosaurs   professor      <list [2]>
#>  4           3 Chandler bubble bath IT procurement <list [2]>
#>  5           3 Chandler bubble bath copywriter     <list [2]>
#>  6           4 Joey     sandwich    actor          <list [1]>
#>  7           5 Rachel   shopping    waitress       <list [2]>
#>  8           5 Rachel   shopping    fashion exec   <list [2]>
#>  9           6 Pheobe   guitar      masseuse       <list [2]>
#> 10           6 Pheobe   guitar      musician       <list [2]>
```


The potential disadvantage of using `tidyjson` is that it's built on the `tbl_json` object, which is often automatically created from a single character vector when using `spread_` functions. Yet `tbl_json` assumes only one special column storing json format data. So when faced with data frame with multiple json columns, we may have to take a little detour to clean them separately and combine the results manually. For another, there are problems with parsing arrays. 

# Case study: clean google analytics customer data

This data comes from [Kaggle](https://www.kaggle.com/c/ga-customer-revenue-prediction/data?select=test.csv). I read in only the top 100 rows and relevant json columns.


```r
ga <- vroom::vroom("https://media.githubusercontent.com/media/qiushiyan/blog-data/master/ga-customer-revenue-prediction.csv",
         n_max = 100,
         col_types = cols_only(
           device = col_character(),
           geoNetwork = col_character(),
           totals = col_character(),
           trafficSource = col_character()
         )) 

glimpse(ga)
#> Rows: 100
#> Columns: 4
#> $ device        <chr> "{\"browser\": \"Chrome\", \"browserVersion\": \"not ava…
#> $ geoNetwork    <chr> "{\"continent\": \"Asia\", \"subContinent\": \"Southeast…
#> $ totals        <chr> "{\"visits\": \"1\", \"hits\": \"4\", \"pageviews\": \"4…
#> $ trafficSource <chr> "{\"campaign\": \"(not set)\", \"source\": \"google\", \…
```

All four columns are json columns. First let's define function that is used to parse a single json character vector:


```r
parse_json_col <- function(col) {
  map_dfr(col, ~ fromJSON(.) %>% as_tibble)
} 
```

The `traffixSource` column need some special treatments, otherwise row length would not match. But the other three can be parsed at the same time. 


```r
ga[1:3] %>% 
  map_dfc(parse_json_col) %>% 
  bind_cols(ga$trafficSource %>% 
              map_dfr(~ fromJSON(.) %>% 
                        as_tibble %>% 
                        nest(data = c(adwordsClickInfo))))
#> # A tibble: 100 × 38
#>    browser browserVersion  browserSize operatingSystem operatingSystem… isMobile
#>    <chr>   <chr>           <chr>       <chr>           <chr>            <lgl>   
#>  1 Chrome  not available … not availa… Macintosh       not available i… FALSE   
#>  2 Chrome  not available … not availa… Windows         not available i… FALSE   
#>  3 Chrome  not available … not availa… Macintosh       not available i… FALSE   
#>  4 Safari  not available … not availa… iOS             not available i… TRUE    
#>  5 Safari  not available … not availa… Macintosh       not available i… FALSE   
#>  6 Chrome  not available … not availa… Linux           not available i… FALSE   
#>  7 Chrome  not available … not availa… Macintosh       not available i… FALSE   
#>  8 Chrome  not available … not availa… Windows         not available i… FALSE   
#>  9 Chrome  not available … not availa… Macintosh       not available i… FALSE   
#> 10 Chrome  not available … not availa… Windows         not available i… FALSE   
#> # … with 90 more rows, and 32 more variables: mobileDeviceBranding <chr>,
#> #   mobileDeviceModel <chr>, mobileInputSelector <chr>, mobileDeviceInfo <chr>,
#> #   mobileDeviceMarketingName <chr>, flashVersion <chr>, language <chr>,
#> #   screenColors <chr>, screenResolution <chr>, deviceCategory <chr>,
#> #   continent <chr>, subContinent <chr>, country <chr>, region <chr>,
#> #   metro <chr>, city <chr>, cityId <chr>, networkDomain <chr>, latitude <chr>,
#> #   longitude <chr>, networkLocation <chr>, visits <chr>, hits <chr>, …
```

There are 38 columns in total, we can verify this by applying `spread_all` to each columns: (the following tally exludes `..JSON` and `document.id`)  

```r
# 16 columns
spread_all(ga$device)
#> # A tbl_json: 100 x 18 tibble with a "JSON" attribute
#>    ..JSON    document.id browser browserVersion    browserSize   operatingSystem
#>    <chr>           <int> <chr>   <chr>             <chr>         <chr>          
#>  1 "{\"brow…           1 Chrome  not available in… not availabl… Macintosh      
#>  2 "{\"brow…           2 Chrome  not available in… not availabl… Windows        
#>  3 "{\"brow…           3 Chrome  not available in… not availabl… Macintosh      
#>  4 "{\"brow…           4 Safari  not available in… not availabl… iOS            
#>  5 "{\"brow…           5 Safari  not available in… not availabl… Macintosh      
#>  6 "{\"brow…           6 Chrome  not available in… not availabl… Linux          
#>  7 "{\"brow…           7 Chrome  not available in… not availabl… Macintosh      
#>  8 "{\"brow…           8 Chrome  not available in… not availabl… Windows        
#>  9 "{\"brow…           9 Chrome  not available in… not availabl… Macintosh      
#> 10 "{\"brow…          10 Chrome  not available in… not availabl… Windows        
#> # … with 90 more rows, and 12 more variables: operatingSystemVersion <chr>,
#> #   isMobile <lgl>, mobileDeviceBranding <chr>, mobileDeviceModel <chr>,
#> #   mobileInputSelector <chr>, mobileDeviceInfo <chr>,
#> #   mobileDeviceMarketingName <chr>, flashVersion <chr>, language <chr>,
#> #   screenColors <chr>, screenResolution <chr>, deviceCategory <chr>

# 11 columns
spread_all(ga$geoNetwork)
#> # A tbl_json: 100 x 13 tibble with a "JSON" attribute
#>    ..JSON  document.id continent subContinent  country region metro city  cityId
#>    <chr>         <int> <chr>     <chr>         <chr>   <chr>  <chr> <chr> <chr> 
#>  1 "{\"co…           1 Asia      Southeast As… Singap… (not … (not… (not… not a…
#>  2 "{\"co…           2 Europe    Southern Eur… Spain   Aragon (not… Zara… not a…
#>  3 "{\"co…           3 Europe    Western Euro… France  not a… not … not … not a…
#>  4 "{\"co…           4 Americas  Northern Ame… United… Calif… San … Moun… not a…
#>  5 "{\"co…           5 Americas  Northern Ame… United… Calif… San … San … not a…
#>  6 "{\"co…           6 Americas  Northern Ame… United… not a… not … not … not a…
#>  7 "{\"co…           7 Americas  Northern Ame… United… not a… not … not … not a…
#>  8 "{\"co…           8 Americas  Northern Ame… United… not a… not … not … not a…
#>  9 "{\"co…           9 Europe    Southern Eur… Portug… Lisbon (not… Lisb… not a…
#> 10 "{\"co…          10 Europe    Southern Eur… Spain   Aragon (not… Zara… not a…
#> # … with 90 more rows, and 4 more variables: networkDomain <chr>,
#> #   latitude <chr>, longitude <chr>, networkLocation <chr>

# 4 columns
spread_all(ga$totals)
#> # A tbl_json: 100 x 6 tibble with a "JSON" attribute
#>    ..JSON                    document.id visits hits  pageviews newVisits
#>    <chr>                           <int> <chr>  <chr> <chr>     <chr>    
#>  1 "{\"visits\":\"1\",\"..."           1 1      4     4         <NA>     
#>  2 "{\"visits\":\"1\",\"..."           2 1      5     5         1        
#>  3 "{\"visits\":\"1\",\"..."           3 1      7     7         1        
#>  4 "{\"visits\":\"1\",\"..."           4 1      8     4         1        
#>  5 "{\"visits\":\"1\",\"..."           5 1      9     4         1        
#>  6 "{\"visits\":\"1\",\"..."           6 1      11    5         1        
#>  7 "{\"visits\":\"1\",\"..."           7 1      37    15        1        
#>  8 "{\"visits\":\"1\",\"..."           8 1      52    22        1        
#>  9 "{\"visits\":\"1\",\"..."           9 1      5     5         <NA>     
#> 10 "{\"visits\":\"1\",\"..."          10 1      6     6         1        
#> # … with 90 more rows

# 7 columns, all adwordsClickInfo columns are seen as one column
spread_all(ga$trafficSource)
#> # A tbl_json: 100 x 14 tibble with a "JSON" attribute
#>    ..JSON   document.id campaign source medium keyword isTrueDirect referralPath
#>    <chr>          <int> <chr>    <chr>  <chr>  <chr>   <lgl>        <chr>       
#>  1 "{\"cam…           1 (not se… google organ… (not p… TRUE         <NA>        
#>  2 "{\"cam…           2 (not se… google organ… (not p… NA           <NA>        
#>  3 "{\"cam…           3 (not se… google organ… (not p… NA           <NA>        
#>  4 "{\"cam…           4 (not se… google organ… (not p… NA           <NA>        
#>  5 "{\"cam…           5 (not se… google organ… (not p… NA           <NA>        
#>  6 "{\"cam…           6 (not se… google organ… (not p… NA           <NA>        
#>  7 "{\"cam…           7 (not se… google organ… (not p… NA           <NA>        
#>  8 "{\"cam…           8 (not se… google organ… (not p… NA           <NA>        
#>  9 "{\"cam…           9 (not se… google organ… (not p… TRUE         <NA>        
#> 10 "{\"cam…          10 (not se… google organ… (not p… NA           <NA>        
#> # … with 90 more rows, and 6 more variables:
#> #   adwordsClickInfo.criteriaParameters <chr>, adwordsClickInfo.page <chr>,
#> #   adwordsClickInfo.slot <chr>, adwordsClickInfo.gclId <chr>,
#> #   adwordsClickInfo.adNetworkType <chr>, adwordsClickInfo.isVideoAd <lgl>
```

And this may reminds you of a even simpler solution with the `tidyjson` package. 


```r
ga %>% 
  map_dfc(spread_all)
#> # A tibble: 100 × 51
#>    document.id...1 browser browserVersion      browserSize       operatingSystem
#>              <int> <chr>   <chr>               <chr>             <chr>          
#>  1               1 Chrome  not available in d… not available in… Macintosh      
#>  2               2 Chrome  not available in d… not available in… Windows        
#>  3               3 Chrome  not available in d… not available in… Macintosh      
#>  4               4 Safari  not available in d… not available in… iOS            
#>  5               5 Safari  not available in d… not available in… Macintosh      
#>  6               6 Chrome  not available in d… not available in… Linux          
#>  7               7 Chrome  not available in d… not available in… Macintosh      
#>  8               8 Chrome  not available in d… not available in… Windows        
#>  9               9 Chrome  not available in d… not available in… Macintosh      
#> 10              10 Chrome  not available in d… not available in… Windows        
#> # … with 90 more rows, and 46 more variables: operatingSystemVersion <chr>,
#> #   isMobile <lgl>, mobileDeviceBranding <chr>, mobileDeviceModel <chr>,
#> #   mobileInputSelector <chr>, mobileDeviceInfo <chr>,
#> #   mobileDeviceMarketingName <chr>, flashVersion <chr>, language <chr>,
#> #   screenColors <chr>, screenResolution <chr>, deviceCategory <chr>,
#> #   ..JSON...18 <list>, document.id...19 <int>, continent <chr>,
#> #   subContinent <chr>, country <chr>, region <chr>, metro <chr>, city <chr>, …
```



