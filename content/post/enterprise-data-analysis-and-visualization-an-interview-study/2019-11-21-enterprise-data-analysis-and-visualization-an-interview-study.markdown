---
title: 'Enterprise Data Analysis and Visualization: An Interview Study'
author: Qiushi Yan
date: '2019-11-21'
slug: enterprise-data-analysis-and-visualization-an-interview-study
categories:
  - Readings
summary: 'Reading notes on "Enterprise Data Analysis and Visualization: An Interview Study" by Sean Kandel, Andreas Paepcke, Joseph M. Hellerstein, and Jeffrey Heer'
lastmod: '2019-11-21T18:42:03+08:00'
bibliography: ../bib/enterprise-data-analysis-and-visualization-an-interview-study.bib
biblio-style: "apalike"
link-citations: true
---

*Enterprise Data Analysis and Visualization: An Interview Study* is an effort to penetrate into enterprises and glean real-world data science experience from analysts directly. By conducting semi-structured interviews with 35 data analysts, [Heer](#ref-2012-enterprise-analysis-interviews) ([2012](#ref-2012-enterprise-analysis-interviews)) provides insight on 3 archetypes describing different workflows and tasks given, common pain points analysts may encounter, future trends, etc.

# 3 Archetypes

According to the responses, we can see analysts generally fall into 3 archetypes: *hacker*, *scripter* and *application user*.

![](/img/archetypes.png)

**Hackers** are faced with the most diverse and complex tasks. They are most literate in terms of programming and thus rarely ask IT staffs fro help. More oftern than not, hackers master more than three languages, R / Matlab for analysis, Python, Perl as an scripting language, and SQL for queries.

{{% alert note %}}
I guess for now Python has gained ground also as a data analysis language, and Matlab is less popular among business analysts, but more frquently used in labs of nature science.
{{% /alert %}}

Also note that with their ability to collect, manipulate data, some hackers could be in charge of managing the data warehouse of the company, and dealing with large datasets. In constrast, they perform less statistical models, and spend more time in early-stage analytic activities prior to modeling, if any.

**Scripters** take care of advanced modeling and use a software package such as R or Matlab extensively. They are less proficient when parsing log files or scraping data off the web, and the data susceptible for modeling are often prepared by IT staff.

**Application user** prefer operations done in a spreadsheet( Mostly in Excel ), or other analysis application (e.g., SAS / JMP, SPSS, etc.). Data are also pulled out from several relationald databases prior to their work. They typically worked on smaller datasets than other gorups, advanced application users may wrote scripts using an embedded language such as Visual Basic.

{{% alert note %}}
To my mind, application users dipicted here seem to be titled “data analysts” for historical reasons, and there is little case for keeping such a position when there are already hackers and scripters. Perhaps they were traditional bussiness people in charge of analysis or accountants, so they are most comforatble with Microsoft Excel or SPSS. As the “big data” meme started to present itself, all of a sudden their enterprise felr it imperative to set up a “data scientist / analyst” position to keep up with this new trend. Yet I doubt if this archetype could still survive when graduates from data.
{{% /alert %}}

# Analysts within organization

Analysts interact closely with IT staff to complete aspects of theire job. For IT staff, his relationship includes data ingesting and acquiring, operationalizing recurring workflows, and serve as a source of documentation when analysts, say, con’t figure out how to wirte a complex SQL statement.

This reliance on IT staff was particularly true in organizations where data was distributed across many different data sources. Hackers were most likely to use the IT team explicitly for this function, as they were more likely to access data directly from the warehouse. Scripters and application users relied on this function implicitly when receiving data from members of IT.

Another thread of this topic is distributed data, which are generated from multiple departments of the enterprise. They are often stored in various databases and formats. adding to the diffculty of intergrating them.

When analysis is finished, analysts typically shared static reports in the form of template documents. In some cases, reports could be interactive dashboards that enabled end users to filter or modify statistics computed. It’s not hard to imagine consumers of the report often give a blurred image of what they want, and hardly could analysts translate them into practical data problems.

When it comes to collaboration, it is an exception rather than the rule for analysts. They do share some central repository data processing scriptes are kept to oneself as a rule. Ont the other hand, final reports in the form of charts or model summary are commonly shared among analytsts in planning meeting or presentations. These reports, however, are rarely parametrizable or interactive.

The author identifies three impediemnts to collaboration:

-   the diversity of tools and programming languages  
-   finding a script or inter-
    mediate data product someone else produced was often more time-
    consumingthanwritingthescriptfromscratch  
-   many analysis process are “ad hoc,” “experimental”

# Challenges

Five high-level tasks in the workflow are proposed and and challenges within each of them elaborated.

**Discovering**[^1]: Since data are often distributed across multiple databases and sources, finding the exact data sheet or file needed can be time-consuming, not to mention that some analysts only have restricted access to the data warehhouse. Another problem is field definitions, these definitions were
often missing in relational databases and non-existent in other types of data stores.

**Wranling**: Many analysts reported parsing, ingesting semi-structured data(i.e., log files, block data[^2]). Another difficulty is integrating the data, after analysts manage to find them in databases. Sometimes identifiers are missing or encoded inconsistantly in some databases, and sometimes there is no column than could be an identifier.

**Profiling**[^3]: Many analysts (22 / 35) reports issues dealing with missing data and heterogeneous data in a column. When detecting outliers, there is no general agreement between visualization and traditional staistical methods.

**Modeling**: The biggest challenge in constructing an model according to respondents are feature selection, whether to choose a set of variables, which to transfrom and how to transform.

{{% alert note %}}
There is a great book on feature engineering and selectin by Max Kuhn and Kjell Johnson: [Feature Engineering and Selection: A Practical Approach for Predictive Models](http://www.feat.engineering/index.html)
{{% /alert %}}

Most repondents also pointed to the scalibility of existing analysis and visualization tools. Hackers are less limited by large amounts of data, obviously, but hackers were often limited by the types of analysis they could run because useful models or algorithms did not have available parallelized implementations. Visualizing model results is another pain point, analysts using more advanced machine learning methods (14/35) expressed a desire for visualization tools to help explore these models and visualize their output.

{{% alert note %}}
R’s package **broom** ([Robinson and Hayes 2019](#ref-R-broom)) are desgined to facilitate modeling diagnosis, visualization, etc. **tidymodels** ([Kuhn and Wickham 2019](#ref-R-tidymodels)) contains a burgeoning list of such packages.
{{% /alert %}}

**Reporing**: The two most-cited challenges in reporoting were communicating assumptions and building interactive reports. Documentation that should have been provided alongside the report are often missing or poorly written. Even when assumptions were tracked, they were often treated as footnotes instead of first-class results. Moreover, analysts complained that reports were too
inflexible and did not allow interactive verification or sensitivity analysis.

# Future trends

The article then prophesy future trends in technology and the analytic workforce:

Public data become more accessible and add to the diffculty of data discovery and intergration.

The market of Hadoop-like software will continue to increase, allowing analysts to operate on less structured data formats.

“Hacker-level” analysts will be in demand, analysts therefore need to be adept at both statistical reasoning and writing complex SQL or Map-Reduce code. Those who are comfortable in multiple data processing / analysis frameworks will be competent.

The size of analytic teams should grow, efficient collaboration will become both increasingly important and difficult.[^4]

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-R-rmarkdown" class="csl-entry">

Allaire, JJ, Yihui Xie, Jonathan McPherson, Javier Luraschi, Kevin Ushey, Aron Atkins, Hadley Wickham, Joe Cheng, Winston Chang, and Richard Iannone. 2019. *Rmarkdown: Dynamic Documents for r*. <https://CRAN.R-project.org/package=rmarkdown>.

</div>

<div id="ref-R-shiny" class="csl-entry">

Chang, Winston, Joe Cheng, JJ Allaire, Yihui Xie, and Jonathan McPherson. 2019. *Shiny: Web Application Framework for r*. <https://CRAN.R-project.org/package=shiny>.

</div>

<div id="ref-2012-enterprise-analysis-interviews" class="csl-entry">

Heer, Sean Kandel AND Andreas Paepcke AND Joseph Hellerstein AND Jeffrey. 2012. “Enterprise Data Analysis and Visualization: An Interview Study.” In *IEEE Visual Analytics Science & Technology (VAST)*. <http://idl.cs.washington.edu/papers/enterprise-analysis-interviews>.

</div>

<div id="ref-R-tidymodels" class="csl-entry">

Kuhn, Max, and Hadley Wickham. 2019. *Tidymodels: Easily Install and Load the ’Tidymodels’ Packages*. <https://CRAN.R-project.org/package=tidymodels>.

</div>

<div id="ref-R-sparklyr" class="csl-entry">

Luraschi, Javier, Kevin Kuo, Kevin Ushey, JJ Allaire, and The Apache Software Foundation. 2019. *Sparklyr: R Interface to Apache Spark*. <https://CRAN.R-project.org/package=sparklyr>.

</div>

<div id="ref-R-broom" class="csl-entry">

Robinson, David, and Alex Hayes. 2019. *Broom: Convert Statistical Analysis Objects into Tidy Tibbles*. <https://CRAN.R-project.org/package=broom>.

</div>

<div id="ref-R-tidyverse" class="csl-entry">

Wickham, Hadley. 2017. *Tidyverse: Easily Install and Load the ’Tidyverse’*. <https://CRAN.R-project.org/package=tidyverse>.

</div>

<div id="ref-R-knitr" class="csl-entry">

Xie, Yihui. 2019. *Knitr: A General-Purpose Package for Dynamic Report Generation in r*. <https://CRAN.R-project.org/package=knitr>.

</div>

</div>

[^1]: Here discovering means acquire data necessary to complete analysis tasks

[^2]: In a block format, logical records of data are spread
    across multiple lines of a file. Typically one line (the “header”) con-
    tains metadata about the record, such as how many of the subsequent
    lines (the “payload”) belong to the record

[^3]: To verify data qualityand its suitability for the analysis tasks. Example tasks include inspecting outliers, examining distributions

[^4]: In the last section, the author move on to discuss improvements that can be made to analytic tools. I figure these suggestions are somehow outdated by today’s standard, and `tidyverse`([Wickham 2017](#ref-R-tidyverse))、`knitr`([Xie 2019](#ref-R-knitr))、`rmarkdown`([Allaire et al. 2019](#ref-R-rmarkdown))、`shiny`([Chang et al. 2019](#ref-R-shiny))、`sparklyr`([Luraschi et al. 2019](#ref-R-sparklyr)) and some other packages in R have already given fine solutions to them, so this section is skipped.
