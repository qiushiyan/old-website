---
title: 'Pandas Recipes'
author: Qiushi Yan
date: '2022-02-09'
slug: []
categories:
  - Data Analysis
  - Python
tags: []
subtitle: ''
summary: 'bag of tricks in pandas'
authors: []
lastmod: '2022-02-09T10:33:55-06:00'
draft: no
link-citations: yes
image:
  caption: ''
  focal_point: ''
  preview_only: no
---


It's my seventh time trying to learn pandas in the past 3 years. I used to cram the whole pandas documentation into one day to finish all data manipulation parts in a project, and then repeat the process 6 months later. So I decided to make a post collecting common operations for which I have to constantly look through the docs or search on stackoverflow. 





```python
import pandas as pd
import numpy as np 
import seaborn as sns 

df = sns.load_dataset("penguins")

print(pd.__version__)
#> 1.3.4
```


## Reading data

### select columns 

### select rows 

`nrows` specifies the (continuous) number of lines file to read. `skiprows` can be used to skip multiple rows while reading (don't have to be contiguous), from the beginning of the file. This might be useful for some malformed files exported from excel, e.g., the second row might be units. 

```python
# skip 2nd and 4th row 
pd.read_csv(path, skiprows = [1, 3])
```






### Specifying data types 


There is a [table](https://pandas.pydata.org/docs/user_guide/basics.html#basics-dtypes) from the pandas documentation listing all available data types. Some common data types including 

- nullable integer: `'int8'`, `'int16'`, `'int32'`, `'int64'`, for unsigned integers use the `u` prefix, e.g., `'uint16'`

- floats: replace `int` above with `float` (there is no unsigned version for float and it starts with `float16`)

- strings: `'string'` (after pandas 1.0). Before `object` is the only option.

- booleans: `'bool'`

- datetime: `"datetime"` or `'datetime64[ns, <tz>]'` (time-zone aware)

- `object`: the catch-all data type, should be avoided for performance reasons 

I'm using the string version here but there is always a class constructor in pandas or numpy, e.g. `np.int8` or `pd.Int32Dtype`. 

`DataFrame.astype()` convert one all multiple columns using a dict



```python
df = df.astype({
  "species": "string", 
  "island": "string", 
  "bill_length_mm": "float16", 
  "bill_depth_mm": "float16", 
  "flipper_length_mm": "float16",
  "body_mass_g": "float16",
  "sex": "string"
})
df.info()
#> <class 'pandas.core.frame.DataFrame'>
#> RangeIndex: 344 entries, 0 to 343
#> Data columns (total 7 columns):
#>  #   Column             Non-Null Count  Dtype  
#> ---  ------             --------------  -----  
#>  0   species            344 non-null    string 
#>  1   island             344 non-null    string 
#>  2   bill_length_mm     342 non-null    float16
#>  3   bill_depth_mm      342 non-null    float16
#>  4   flipper_length_mm  342 non-null    float16
#>  5   body_mass_g        342 non-null    float16
#>  6   sex                333 non-null    string 
#> dtypes: float16(4), string(3)
#> memory usage: 10.9 KB
```




There also a `infer_objects()` method that attempts to convert object-typed columns automatically: 


```python
sns.load_dataset("penguins").infer_objects().info()
#> <class 'pandas.core.frame.DataFrame'>
#> RangeIndex: 344 entries, 0 to 343
#> Data columns (total 7 columns):
#>  #   Column             Non-Null Count  Dtype  
#> ---  ------             --------------  -----  
#>  0   species            344 non-null    object 
#>  1   island             344 non-null    object 
#>  2   bill_length_mm     342 non-null    float64
#>  3   bill_depth_mm      342 non-null    float64
#>  4   flipper_length_mm  342 non-null    float64
#>  5   body_mass_g        342 non-null    float64
#>  6   sex                333 non-null    object 
#> dtypes: float64(4), object(3)
#> memory usage: 18.9+ KB
```


## Filtering rows 


## Creating columns 


## Group by operations 

## Selecting columns 

### By name and regex
 
select all columns that starts with "bill"


```python
df.iloc[:, df.columns.map(lambda x: x.startswith("bill"))]
#>      bill_length_mm  bill_depth_mm
#> 0          39.09375      18.703125
#> 1          39.50000      17.406250
#> 2          40.31250      18.000000
#> 3               NaN            NaN
#> 4          36.68750      19.296875
#> ..              ...            ...
#> 339             NaN            NaN
#> 340        46.81250      14.296875
#> 341        50.40625      15.703125
#> 342        45.18750      14.796875
#> 343        49.90625      16.093750
#> 
#> [344 rows x 2 columns]
```


### By data types 

`DataFrame.select_dtypes(include = None, exclude = None)` returns a subset of the DataFrame’s columns based on the column dtypes.

```python
# select all numerical columns regardless of digits 
df.select_dtypes(include = 'number')

# select all columns that are not boolean 
df.select_dtypes(exclude = "bool")
```

More generally, use the `apply + iloc` flow: 


```python
# check each column's type 
df.apply(lambda x: x.dtype == "string", axis = 0).values

# select columns that pass the check 
#> array([ True,  True, False, False, False, False,  True])
df.iloc[:, df.apply(lambda x: x.dtype == "string", axis = 0).values]
#>     species     island     sex
#> 0    Adelie  Torgersen    Male
#> 1    Adelie  Torgersen  Female
#> 2    Adelie  Torgersen  Female
#> 3    Adelie  Torgersen    <NA>
#> 4    Adelie  Torgersen  Female
#> ..      ...        ...     ...
#> 339  Gentoo     Biscoe    <NA>
#> 340  Gentoo     Biscoe  Female
#> 341  Gentoo     Biscoe    Male
#> 342  Gentoo     Biscoe  Female
#> 343  Gentoo     Biscoe    Male
#> 
#> [344 rows x 3 columns]
```






## Text data 

## Plotting 

