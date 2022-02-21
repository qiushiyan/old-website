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
link-citations: yes
draft: yes
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

Common options for `pandas.read_csv` and other data-importing functions:

-   `header` row number of header

-   `names`: specify column names

-   `usecols`: which columns to keep

-   `dtype`: specify data types

-   `nrows`: \# of rows to read

-   `skiprows`: index of rows to skip

-   `na_values`: strings to recognize as NaN

### Select columns

### Select rows

`nrows` specifies the (continuous) number of lines file to read. `skiprows` can be used to skip multiple rows while reading (don't have to be contiguous), from the beginning of the file. This might be useful for some malformed files exported from excel, e.g., the second row might be units.


```python
# make the 3rd row header, skip 4nd and 5th row, ignore comment that starts with # 
import io 
csv_string = io.StringIO(
""",,
,,
col1,col2,col3
# all number in mm
,,
,,
1,2,3
4,5,6
"""
)
pd.read_csv(csv_string, header = 2, skiprows = [4, 5], comment = "#")
#>    col1  col2  col3
#> 0     1     2     3
#> 1     4     5     6
```

`skiprows` also accepts a lambda function that returns a boolean indicating if a row should be skipped, this can be useful when sampling large datasets

```python
# skipping negative rows and 99% of the rest 
pd.read_csv(file, skiprows = lambda x: x > 0 
                  and np.random.rand() > 0.01)
```


### Specifying data types

There is a [table](https://pandas.pydata.org/docs/user_guide/basics.html#basics-dtypes) from the pandas documentation listing all available data types. Some common data types including

-   nullable integer: `'int8'`, `'int16'`, `'int32'`, `'int64'`, for unsigned integers use the `u` prefix, e.g., `'uint16'`

-   floats: replace `int` above with `float` (there is no unsigned version for float and it starts with `float16`)

-   strings: `'string'` (after pandas 1.0). Before `object` is the only option. Memory-wise string took up exactly the **same** space as object type [^1], and the performance is similar too. But it's still recommended to use string whenever possible because of clearer code. A [category](#use-category-data-type) data type is also available

-   booleans: `'bool'`

-   datetime: `"datetime"` or `'datetime64[ns, <tz>]'` (time-zone aware)

-   `object`: the catch-all data type, should be avoided for performance reasons

[^1]: pandas 1.3 introduced a new data type `'string[pyarrow]'` that promises more efficient storage, see <https://pythonspeed.com/articles/pandas-string-dtype-memory/>

I'm using the string version here but there is always a class constructor in pandas or numpy, e.g. `np.int8` or `pd.Int32Dtype`.

Data types can either be specified during creation or after it:

-   during creation: `pd.read_csv(dtypes = {"col": "type"})`

-   after creation: `df.astype({"col": "type"})`


```python
df = df.astype({
  "species": "category", 
  "island": "category", 
  "bill_length_mm": "float16", 
  "bill_depth_mm": "float16", 
  "flipper_length_mm": "float16",
  "body_mass_g": "float16",
  "sex": "category"
})
df.info()
#> <class 'pandas.core.frame.DataFrame'>
#> RangeIndex: 344 entries, 0 to 343
#> Data columns (total 7 columns):
#>  #   Column             Non-Null Count  Dtype   
#> ---  ------             --------------  -----   
#>  0   species            344 non-null    category
#>  1   island             344 non-null    category
#>  2   bill_length_mm     342 non-null    float16 
#>  3   bill_depth_mm      342 non-null    float16 
#>  4   flipper_length_mm  342 non-null    float16 
#>  5   body_mass_g        342 non-null    float16 
#>  6   sex                333 non-null    category
#> dtypes: category(3), float16(4)
#> memory usage: 4.2 KB
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

### Reading from a directory 

```python
from glob import glob
pd.concat([pd.read_csv(f).assign(file=f) 
           for f in glob("*.csv")])
```

### Reading from other sources 

- json: `pd.read_json``

- html table: `pd.read_html`

- pdf: `tabula.read_pdf`




## Filtering rows

### `.loc` and `iloc`


Chain loc and iloc


```python
df.iloc[10:15, :].loc[:, ["island", "body_mass_g"]]
#>        island  body_mass_g
#> 10  Torgersen       3300.0
#> 11  Torgersen       3700.0
#> 12  Torgersen       3200.0
#> 13  Torgersen       3800.0
#> 14  Torgersen       4400.0
```


Use a mix of label-based and integer-based selection 

```python
df.iloc[df.index.get_loc("a"), 1]
```

use lambda function 

```python
df.loc[lambda d: d.sex == "Male"]
```


### Related functions 

Filter by `IN` conditions 

```python
df.loc[df.island.apply(lambda x: x in ["Dream", "Biscoe"]), :]
```






## Working with columns


In general, when working with columns pandas is more similar to base R rather than dplyr, in the sense that it encourages me to directly access the column `df[col]` and operate on it. The `assign` method is a helper function that's similar to dplyr's `mutate`, but I figured the python community gravitates more towards the general approach.  This also makes pandas more procedural and non-functional to me. Anyway this is a helpful mental model where there is not a convenient helper function in pandas, for example, change all string column's value to lower case: 


```python
for col in df.columns:
    if str(df[col].dtype) == "string":
        df[col] = df[col].str.lower()
```

### Creating and modifying columns 

The `assign` method creates multiple columns with quotes: 


```python
df.assign(
  sex2 = np.where(df.sex == "Male", 0, 1),
  length_double = 
    lambda df: df.bill_length_mm * 2
).head()
#>   species     island  bill_length_mm  ...     sex  sex2  length_double
#> 0  Adelie  Torgersen        39.09375  ...    Male     0        78.1875
#> 1  Adelie  Torgersen        39.50000  ...  Female     1        79.0000
#> 2  Adelie  Torgersen        40.31250  ...  Female     1        80.6250
#> 3  Adelie  Torgersen             NaN  ...     NaN     1            NaN
#> 4  Adelie  Torgersen        36.68750  ...  Female     1        73.3750
#> 
#> [5 rows x 9 columns]
```

`assign` insert columns at the end, the `insert` method create columns in the specified location **inplace**


```python
# insert column at the top 
df.insert(0, "bill_double", df.bill_length_mm * 2)
df.info()
#> <class 'pandas.core.frame.DataFrame'>
#> RangeIndex: 344 entries, 0 to 343
#> Data columns (total 8 columns):
#>  #   Column             Non-Null Count  Dtype   
#> ---  ------             --------------  -----   
#>  0   bill_double        342 non-null    float16 
#>  1   species            344 non-null    category
#>  2   island             344 non-null    category
#>  3   bill_length_mm     342 non-null    float16 
#>  4   bill_depth_mm      342 non-null    float16 
#>  5   flipper_length_mm  342 non-null    float16 
#>  6   body_mass_g        342 non-null    float16 
#>  7   sex                333 non-null    category
#> dtypes: category(3), float16(5)
#> memory usage: 4.9 KB
```

`rename` accepts a dict of {oldname: newname} pair to rename the columns 


```python
df.rename({"body_mass_g": "mass"}, axis = "columns")
#>      bill_double species     island  ...  flipper_length_mm    mass     sex
#> 0        78.1875  Adelie  Torgersen  ...              181.0  3750.0    Male
#> 1        79.0000  Adelie  Torgersen  ...              186.0  3800.0  Female
#> 2        80.6250  Adelie  Torgersen  ...              195.0  3250.0  Female
#> 3            NaN  Adelie  Torgersen  ...                NaN     NaN     NaN
#> 4        73.3750  Adelie  Torgersen  ...              193.0  3450.0  Female
#> ..           ...     ...        ...  ...                ...     ...     ...
#> 339          NaN  Gentoo     Biscoe  ...                NaN     NaN     NaN
#> 340      93.6250  Gentoo     Biscoe  ...              215.0  4848.0  Female
#> 341     100.8125  Gentoo     Biscoe  ...              222.0  5752.0    Male
#> 342      90.3750  Gentoo     Biscoe  ...              212.0  5200.0  Female
#> 343      99.8125  Gentoo     Biscoe  ...              213.0  5400.0    Male
#> 
#> [344 rows x 8 columns]
```


### Selecting columns 

`loc` and `iloc` are two general options

```python
df[list(df.columns[0:3]) + list(df.columns[5:6])]
```


### Removing columns 

The `pop` method removes a column **inplace** and returns the removed column as a series. This comes in handy in machine learning when creating input matrix and the response out of training set

```python
# create input X and response y
y = df_training.pop("label")
X = df_training
```

### Related functions

Common operations and related functions 

- if else: `np.where` or `apply` in general

- case when: nested `np.where` or `np.select`, or multiple `.loc` statements

```python
pd_df['difficulty'] = np.select(
    [
        pd_df['Time'].between(0, 30, inclusive=False), 
        pd_df['Time'].between(30, 60, inclusive=True)
    ], 
    [
        'Easy', 
        'Medium'
    ], 
    default='Unknown'
)

pd_df['difficulty'] = 'Unknown'
pd_df.loc[pd_df['Time'].between(0, 30, inclusive=False), 'difficulty'] = 'Easy'
pd_df.loc[pd_df['Time'].between(30, 60, inclusive=True), 'difficulty'] = 'Medium'
```



## Group by operations

## Selecting columns

### By name and regex

select all columns that starts with "bill"


```python
df.iloc[:, df.columns.map(lambda x: x.startswith("bill"))]
#>      bill_double  bill_length_mm  bill_depth_mm
#> 0        78.1875        39.09375      18.703125
#> 1        79.0000        39.50000      17.406250
#> 2        80.6250        40.31250      18.000000
#> 3            NaN             NaN            NaN
#> 4        73.3750        36.68750      19.296875
#> ..           ...             ...            ...
#> 339          NaN             NaN            NaN
#> 340      93.6250        46.81250      14.296875
#> 341     100.8125        50.40625      15.703125
#> 342      90.3750        45.18750      14.796875
#> 343      99.8125        49.90625      16.093750
#> 
#> [344 rows x 3 columns]
```

### By data types

`DataFrame.select_dtypes(include = None, exclude = None)` returns a subset of the DataFrame's columns based on the column dtypes.

``` python
# select all numerical columns regardless of digits 
df.select_dtypes(include = 'number')

# select all columns that are not boolean 
df.select_dtypes(exclude = "bool")
```

More generally, use the `apply + iloc` flow:


```python
# check each column's type 
df.apply(lambda x: x.dtype == "category", axis = 0).values

# select columns that pass the check 
#> array([False,  True,  True, False, False, False, False,  True])
df.iloc[:, df.apply(lambda x: x.dtype == "category", axis = 0).values]
#>     species     island     sex
#> 0    Adelie  Torgersen    Male
#> 1    Adelie  Torgersen  Female
#> 2    Adelie  Torgersen  Female
#> 3    Adelie  Torgersen     NaN
#> 4    Adelie  Torgersen  Female
#> ..      ...        ...     ...
#> 339  Gentoo     Biscoe     NaN
#> 340  Gentoo     Biscoe  Female
#> 341  Gentoo     Biscoe    Male
#> 342  Gentoo     Biscoe  Female
#> 343  Gentoo     Biscoe    Male
#> 
#> [344 rows x 3 columns]
```

## Text data

### Use category data type

In addition to `'string'`, pandas has a `'category'` data type that are designed for strings fixed in a small set of values. It's similar to R's `factor` data type and can be more memory friendly in some cases. A rule-of-thumb is to only use category when it's really "categorical" column, make a column with high cardinality a category column can cost even more space than string or object.

<div class = "note">
The memory usage of a category column is proportional to the number of categories plus the length of the data. In contrast, an object dtype is a constant times the length of the data.
</div>


```python
s = pd.Series(["foo", "bar"] * 1000)
# object
s.nbytes
# string
#> 16000
s.astype("string").nbytes
# category
#> 16000
s.astype("category").nbytes
#> 2016
```

All string methods accessed by `.str` are available to category.

Internally, category data type are represented using integers (like in R), and `apply` functions does not preserve this data type.

## Plotting



## Miscellaneous tips 

### Chaining operations 

A generic approach is chaining operations enclosed in a set of parenthesis: 

```python
(df
  .method1()
  .method2()
  .method3)
```

Since pandas 0.16.2 the `pipe` method was introduced, it accepts a function, which takes in the current dataframe and return a new dataframe. 


```python
def double_length(df: pd.DataFrame) -> pd.DataFrame: 
    return df.assign(double_length = df.flipper_length_mm * 2)
    
def filter_island(df: pd.DataFrame, islands: [] = ["Biscoe", "Dream"]) -> pd.DataFrame: 
    return df[df.island.isin(islands)]
  
(df
    .pipe(double_length)
    .pipe(filter_island))
#>      bill_double species  island  ...  body_mass_g     sex  double_length
#> 20       75.6250  Adelie  Biscoe  ...       3400.0  Female          348.0
#> 21       75.3750  Adelie  Biscoe  ...       3600.0    Male          360.0
#> 22       71.8125  Adelie  Biscoe  ...       3800.0  Female          378.0
#> 23       76.3750  Adelie  Biscoe  ...       3950.0    Male          370.0
#> 24       77.6250  Adelie  Biscoe  ...       3800.0    Male          360.0
#> ..           ...     ...     ...  ...          ...     ...            ...
#> 339          NaN  Gentoo  Biscoe  ...          NaN     NaN            NaN
#> 340      93.6250  Gentoo  Biscoe  ...       4848.0  Female          430.0
#> 341     100.8125  Gentoo  Biscoe  ...       5752.0    Male          444.0
#> 342      90.3750  Gentoo  Biscoe  ...       5200.0  Female          424.0
#> 343      99.8125  Gentoo  Biscoe  ...       5400.0    Male          426.0
#> 
#> [292 rows x 9 columns]
```




