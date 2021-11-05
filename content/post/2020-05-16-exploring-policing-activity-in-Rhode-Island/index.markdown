---
title: Exploring policing activity in Rhode Island
author: Qiushi Yan
date: '2020-05-17'
lastmod: '2020-05-18'
slug: rhode-policing-activity
categories:
  - Python
  - Data Analysis
summary: 'Use pandas to answer data questions about traffic stops in Rhode Island.'
image:
  caption: ''
  focal_point: ''
  preview_only: yes
---

This post is about completing an exploratory data analysis project using the `pandas` library in Python. The data comes from the [Stanford Open Policing Project](https://openpolicing.stanford.edu), which releases cleaned data about vehicle and pedestrian stops from the police across over 30 states in the USA. I focus only on traffic stops by police officers in the state of Rhode Island here. 

Some questions include:

- The relationship between search rate, types of search, types of violation, gender and race.
- How do the number of drug related stops and search rate change during the past few years?
- Is there a pattern in violations across different zones of Rhode Island?
- Does weather affect arrest rate?





# Data preprocessing




Let's begin by loading the library and data


```python
import pandas as pd 
```


```python
ri = pd.read_csv("https://media.githubusercontent.com/media/qiushiyan/blog-data/master/rhode_traffic_stops.csv")
print(ri.head())
#>   state   stop_date stop_time  ...  stop_duration drugs_related_stop district
#> 0    RI  2005-01-04     12:55  ...       0-15 Min              False  Zone X4
#> 1    RI  2005-01-23     23:15  ...       0-15 Min              False  Zone K3
#> 2    RI  2005-02-17     04:15  ...       0-15 Min              False  Zone X4
#> 3    RI  2005-02-20     17:15  ...      16-30 Min              False  Zone X1
#> 4    RI  2005-02-24     01:20  ...       0-15 Min              False  Zone X3
#> 
#> [5 rows x 15 columns]
print(ri.columns)
#> Index(['state', 'stop_date', 'stop_time', 'county_name', 'driver_gender',
#>        'driver_race', 'violation_raw', 'violation', 'search_conducted',
#>        'search_type', 'stop_outcome', 'is_arrested', 'stop_duration',
#>        'drugs_related_stop', 'district'],
#>       dtype='object')
```


To save future efforts, we have some preprocessing jobs to do:

- drop columns and rows
- make sure that relevant columnns are in the right data type.
- make use of pandas's datetime index


A glance at missing values will show that `county_name` are all missing. Also, those observations with missing `driver_gender` and `driver_race` is of little value for our purposes. And the `state` column is redundant.


```python
ri.isnull().mean()
#> state                 0.000000
#> stop_date             0.000000
#> stop_time             0.000000
#> county_name           1.000000
#> driver_gender         0.056736
#> driver_race           0.056703
#> violation_raw         0.056703
#> violation             0.056703
#> search_conducted      0.000000
#> search_type           0.963953
#> stop_outcome          0.056703
#> is_arrested           0.056703
#> stop_duration         0.056703
#> drugs_related_stop    0.000000
#> district              0.000000
#> dtype: float64
```

As to data types, `is_arrested` is now recognized as objects, but should be boolean values instead. 


```python
ri.dtypes
#> state                  object
#> stop_date              object
#> stop_time              object
#> county_name           float64
#> driver_gender          object
#> driver_race            object
#> violation_raw          object
#> violation              object
#> search_conducted         bool
#> search_type            object
#> stop_outcome           object
#> is_arrested            object
#> stop_duration          object
#> drugs_related_stop       bool
#> district               object
#> dtype: object
```



```python
ri["is_arrested"].head()
#> 0    False
#> 1    False
#> 2    False
#> 3     True
#> 4    False
#> Name: is_arrested, dtype: object
```

Lastly, `stop_date` and `stop_time` will be turned into best advantage as a datetime index.


```python
ri[["stop_date", "stop_time"]].head()
#>     stop_date stop_time
#> 0  2005-01-04     12:55
#> 1  2005-01-23     23:15
#> 2  2005-02-17     04:15
#> 3  2005-02-20     17:15
#> 4  2005-02-24     01:20
```

Combine these steps yields a relatively clean version of this dataset.


```python
ri["is_arrested"] = ri.is_arrested.astype("bool")
dt_index = ri.stop_date.str.cat(ri.stop_time, sep = " ")
ri["stop_datetime"] = pd.to_datetime(dt_index)

ri_clean = (ri.
  drop(["county_name", "state"], axis = "columns").
  dropna(subset = ["driver_gender", "driver_race"]).
  set_index("stop_datetime")
)
```



```python
ri_clean.head()
#>                       stop_date stop_time  ... drugs_related_stop district
#> stop_datetime                              ...                            
#> 2005-01-04 12:55:00  2005-01-04     12:55  ...              False  Zone X4
#> 2005-01-23 23:15:00  2005-01-23     23:15  ...              False  Zone K3
#> 2005-02-17 04:15:00  2005-02-17     04:15  ...              False  Zone X4
#> 2005-02-20 17:15:00  2005-02-20     17:15  ...              False  Zone X1
#> 2005-02-24 01:20:00  2005-02-24     01:20  ...              False  Zone X3
#> 
#> [5 rows x 13 columns]
```


# Exploring the relationship between gender, race and policing 

The `search_conducted` column indicates whether or not a vehicle were searched by an officer


```python
ri_clean.search_conducted.head()
#> stop_datetime
#> 2005-01-04 12:55:00    False
#> 2005-01-23 23:15:00    False
#> 2005-02-17 04:15:00    False
#> 2005-02-20 17:15:00    False
#> 2005-02-24 01:20:00    False
#> Name: search_conducted, dtype: bool
```

We can break the average search rate by gender 


```python
# search rate for men and women
ri_clean.groupby("driver_gender").search_conducted.mean()
#> driver_gender
#> F    0.019181
#> M    0.045426
#> Name: search_conducted, dtype: float64
```

This is a marked difference considering the base volume. This could be misleading due to the existance of some confounding variables. For exmaple, the difference in search rate between males and females could be explained by the fact that they tend to commit different violations. For this reason I'll divide the result by types of violation to see if there is a universal rise in the possibility of being searched from women to men. 


```python
ri_clean.groupby(["violation", "driver_gender"]).search_conducted.mean()
#> violation            driver_gender
#> Equipment            F                0.039984
#>                      M                0.071496
#> Moving violation     F                0.039257
#>                      M                0.061524
#> Other                F                0.041018
#>                      M                0.046191
#> Registration/plates  F                0.054924
#>                      M                0.108802
#> Seat belt            F                0.017301
#>                      M                0.035119
#> Speeding             F                0.008309
#>                      M                0.027885
#> Name: search_conducted, dtype: float64
```

For all types of violation, the search rate is higher for males than for females, disproving our hypothesis related to confounding variables, by and large.  

The `search_type` column contains information about categories of searching on the part of the police. I investigate the relative proportion of the most common search types for 4 races. 


```python
condition = ri_clean.driver_race.isin(["White", "Black", "Hispanic", "Asian"]) & ri_clean.search_type.isin(["Incident to Arrest", 'Probable Cause', 'Inventory'])

search_type_by_race = (ri_clean[condition].
  groupby("driver_race").
  search_type.
  value_counts(normalize = True).
  unstack()
)
```





```python
import matplotlib.pyplot as plt
search_type_by_race.plot(kind = "bar")
plt.title("Proportion of common search types across 4 races")
plt.show()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-15-1.png" width="768" style="display: block; margin: auto;" />


Now we come to the question that if race played a role in whether or not someone is frisked during a search (coded in `search_type` by "Protective Frisk"). Since a search instance can be of multiple types, such as "Protective Frisk and Reasonable Suspicion", I create a new column indicating if `search_type` contains protective frisk, and calculate its rate across races. 


```python
ri_clean["frisk"] = ri_clean.search_type.str.contains("Protective Frisk").astype("bool")

(ri_clean[ri_clean.search_conducted == True].
  groupby("driver_race").
  frisk.
  mean())
#> driver_race
#> Asian       0.081633
#> Black       0.080194
#> Hispanic    0.063545
#> Other       0.000000
#> White       0.106325
#> Name: frisk, dtype: float64
```

It looks like white people has a slightly higher frisk rate. But there is no conclusion to be made without more detailed background information.



# Temporal pattern of drug related stops and search rates

The `drugs_related_stop` shows if a traffic stop eneded in the spotting of drugs in the vehicle. Resampling the column annually gives the drug rate over years, and annual search rate is calculated as a reference. 


```python
annual_drug_rate = ri_clean.drugs_related_stop.resample("A").mean()
annual_search_rate = ri_clean.search_conducted.resample("A").mean()
annual = pd.concat([annual_drug_rate, annual_search_rate], axis="columns")
annual.plot(subplots = True)
#> array([<AxesSubplot:xlabel='stop_datetime'>,
#>        <AxesSubplot:xlabel='stop_datetime'>], dtype=object)
plt.show()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-17-3.png" width="768" style="display: block; margin: auto;" />

The rate of drug-related stops increased even though the search rate decreased. 


# Distribution of violation across zones 

Speeding is the most common violation in all districts. 


```python
all_zones = pd.crosstab(ri_clean.district, ri_clean.violation)
all_zones.plot(kind = 'bar')
plt.show()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-18-5.png" width="768" style="display: block; margin: auto;" />

# Weather Impact on policing behaviour 

This section uses a second dataset to explore the impact of weather conditions on police behavior during traffic stops.  


```python
weather = pd.read_csv("https://media.githubusercontent.com/media/qiushiyan/blog-data/master/rhode_weather.csv")
weather.head()
#>        STATION        DATE  TAVG  TMIN  TMAX  ...  WT17  WT18  WT19  WT21  WT22
#> 0  USW00014765  2005-01-01  44.0    35    53  ...   NaN   NaN   NaN   NaN   NaN
#> 1  USW00014765  2005-01-02  36.0    28    44  ...   NaN   1.0   NaN   NaN   NaN
#> 2  USW00014765  2005-01-03  49.0    44    53  ...   NaN   NaN   NaN   NaN   NaN
#> 3  USW00014765  2005-01-04  42.0    39    45  ...   NaN   NaN   NaN   NaN   NaN
#> 4  USW00014765  2005-01-05  36.0    28    43  ...   NaN   1.0   NaN   NaN   NaN
#> 
#> [5 rows x 27 columns]
```


The `weather` data is collected by the national centers for environmental information. Because `ri` lacks spatial information like latitude / longitutde, we use only the data observed by a weather station in the center of Rhode Island. Columns in `weather` that starts with `WT` represents a bad weather condition, and take value at either 1 (present) or 0 (present).  

To measure overall weather conditions on a single day, I tally all the `WT` columns. 


```python
weather["bad_conditions"] = (weather.loc[:,'WT01':'WT22'].
  fillna(0).
  sum(axis = "columns").
  astype("int"))
  
weather.bad_conditions.plot(kind = "hist", bins = 10)
plt.show()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-20-7.png" width="768" style="display: block; margin: auto;" />


Next, I split the daily weather into a categorical variable with 3 categories based on `bad_conditions`.



```python
from pandas.api.types import CategoricalDtype
mapping = {0:'good', 1:'bad', 2:'bad', 3: "bad", 4: "bad",
    5: "worse", 6: "worse", 7: "worse", 8: "worse", 9: "worse"
}

weather['rating'] = (weather.bad_conditions.
  map(mapping).
  astype(CategoricalDtype(categories = ['good', 'bad', "worse"], ordered = True)))

# Count the unique values in 'rating'
print(weather.rating.value_counts())
#> bad      1836
#> good     1749
#> worse     432
#> Name: rating, dtype: int64
```



```python
weather.head()
#>        STATION        DATE  TAVG  TMIN  ...  WT21  WT22  bad_conditions  rating
#> 0  USW00014765  2005-01-01  44.0    35  ...   NaN   NaN               2     bad
#> 1  USW00014765  2005-01-02  36.0    28  ...   NaN   NaN               2     bad
#> 2  USW00014765  2005-01-03  49.0    44  ...   NaN   NaN               3     bad
#> 3  USW00014765  2005-01-04  42.0    39  ...   NaN   NaN               4     bad
#> 4  USW00014765  2005-01-05  36.0    28  ...   NaN   NaN               4     bad
#> 
#> [5 rows x 29 columns]
```


Now `rating` turn to be a easy indicator of weather condition, I'll join two dataframes, `ri_clean` and `weather`, to finalize the analysis. 


```python
ri_clean = ri_clean.reset_index()

weather_rating = weather[["DATE", "rating"]].rename(columns = {"DATE": "stop_date"})
ri_weather = pd.merge(ri_clean, weather_rating, how = "left").set_index("stop_datetime")
ri_weather.head()
#>                       stop_date stop_time driver_gender  ... district frisk rating
#> stop_datetime                                            ...                      
#> 2005-01-04 12:55:00  2005-01-04     12:55             M  ...  Zone X4  True    bad
#> 2005-01-23 23:15:00  2005-01-23     23:15             M  ...  Zone K3  True  worse
#> 2005-02-17 04:15:00  2005-02-17     04:15             M  ...  Zone X4  True   good
#> 2005-02-20 17:15:00  2005-02-20     17:15             M  ...  Zone X1  True    bad
#> 2005-02-24 01:20:00  2005-02-24     01:20             F  ...  Zone X3  True    bad
#> 
#> [5 rows x 15 columns]
```


Let's compare the arrest rate, divided by weather condition and types of violation.


```python
arrest_rate = ri_weather.groupby(["violation", "rating"]).is_arrested.mean()
arrest_rate
#> violation            rating
#> Equipment            good      0.059007
#>                      bad       0.066311
#>                      worse     0.097357
#> Moving violation     good      0.056227
#>                      bad       0.058050
#>                      worse     0.065860
#> Other                good      0.076966
#>                      bad       0.087443
#>                      worse     0.062893
#> Registration/plates  good      0.081574
#>                      bad       0.098160
#>                      worse     0.115625
#> Seat belt            good      0.028587
#>                      bad       0.022493
#>                      worse     0.000000
#> Speeding             good      0.013405
#>                      bad       0.013314
#>                      worse     0.016886
#> Name: is_arrested, dtype: float64
arrest_rate.unstack().plot(kind = "bar")
plt.show()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-24-9.png" width="768" style="display: block; margin: auto;" />



Generally, arrest rate is higher when weather condition gets worse. This doesn't prove a causal link, but it's quite an interesting result! Also, this plot can be illustrated via a pivot table. 


```python
ri_weather.pivot_table(index = "violation", columns = "rating", values = "is_arrested")
#> rating                   good       bad     worse
#> violation                                        
#> Equipment            0.059007  0.066311  0.097357
#> Moving violation     0.056227  0.058050  0.065860
#> Other                0.076966  0.087443  0.062893
#> Registration/plates  0.081574  0.098160  0.115625
#> Seat belt            0.028587  0.022493  0.000000
#> Speeding             0.013405  0.013314  0.016886
```

