

# Spreadsheets

## Data Organization in Spreadsheets & Nine simple ways to make it easier to (re)use your data



@doi:10.1080/00031305.2017.1375989 and  @white2013nine came up with several recommendations, rules and principles that are believed to facilitate data analysis based on spreadsheets, here is a simple conclusion (yet not complete):  

* **Sharing**  

Data sharing can be beneficial to scientific community as a whole and to individuals alike. 

* **Provide metadata**  

Good metadata should providing the following information(Michener et al. 1997, Zimmerman 2003, Strasser et al. 2012): 

1. The what, when where and how of data collection  
2. How to find and access the data  
3. Suggestions and suitability of the data for answering specific questions  
4. Warning about known problems or inconsistencies in the data  
5. Information to check that the data are properly imported, e.g., the number of rows and columns of a dataset and the total sum of numerical columns    

We can ask someelse to look over our metadata and proveide us with feedback about potential ambiguities.

There are some specific standards relevant to writing formal metadata: Ecological Metadata Language [EML](https://knb.ecoinformatics.org/tools/eml), Directory Interchange Format [DIF](https://gcmd.gsfc.nasa.gov/DocumentBuilder/defaultDif10/guide/index.html). And some tools are mentioned: [KNB Morpho](https://knb.ecoinformatics.org/data), [USGS xtime](geology.usgs.gov/tools/metadata/tools/doc/xtme.html) and [FGDC workbook](www.fgdc.gov/metadata/documents/workbook_0501_bmk.pdf).   
    

* **Consistencies in storing and naming**  

Always try to provide data in csv files. Problems may occur in displaying the data correctly when importing , not to mention proprietary formats like Excel.   

If there are multiple files in a dataset, name those files in a consistent manner, use a same layout for the sake of automation process.  

Choose consistent and good variable names, snake case(`variable_name`) and camel case(`variableName`) are recommended.(I've merged the variable naming section into this general principle).  

An additional insight is that one should **never use font color or highlight** in a spreadsheet, since it's hard to transform these features into meaningful information for most programs when importing, though they may be aesthetically pleasing.   


* **Use good null values**  

Of great concern is that how should we represent missing data in spreadsheets in a proper manner, so that it won't cause any problems when they get imported to data processing tools. The following table is of great help:   

<div class="figure" style="text-align: center">
<img src="images/null.png" alt="Commonly used null values" width="100%" />
<p class="caption">(\#fig:unnamed-chunk-2)Commonly used null values</p>
</div>

Since I spend most time using R and a bit on Python and SQL, **NA** and **blank** seem to be two preferable options to represent missing values.   


* **Use `YYYY--MM--DD` as date format**      

When enter dates, both paper strongly recomment using the global "ISO 8601" standard ---- to input date as `YYYY-MM--DD`.  

While Excel store its date-format data as a number (在 Windows 系统上是从 1900 年 1 月 1 日起算的天数，而 Mac 上是从 1904 年 1 月 1 日起算的天数), it also tend to turn other things into dates. For example, some gene symbols(like "Oct-4") may be interpreted as dates. So it's a positive advantage to us to **store dates as text** in Microsoft Excel.   

However, if a column already contain dates, Excel will convert them to a text value of their underlying numeric representation.The best way to do this is to begin a date with a apostrophe, like this `"2014-06-14"`. Or we can use multiple columns to represent a data, say separate 20140614 into 3 columns, with each containing 2014, 06 and 14.  



* **Provide tidy data**   

Concepts of tidy data are discussed in \@ref(tidy-data).  

 

* **Provide an unprocessed form of the data**   

This means there should be no calculations and converting in the data we share. At lease providing both the raw and processed forms of the data, and explaining the differences.  

* **Make backups and use data validation**   

Keep all versions of the data files, and consider using a formal version control system.  

Data entry is a error-prone task, and the **data validation** feature in Microsoft Excel is recommended, this can be seen as the most basic quality control one can perform in the early stage of data analysis.  

* **Use an explicit license**  

See https://creativecommons.org/licenses/by-nc-sa/2.5/cn/legalcode.  
