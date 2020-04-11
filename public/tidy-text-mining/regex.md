


# (APPENDIX) Appendix {-}   

# Reviews on regular expressions


References: [Sams Teach Yourself Regular Expressions in 10 Minutes](https://www.amazon.com/Teach-Yourself-Regular-Expressions-Minutes-ebook/dp/B0027KRPHM/ref=sr_1_2?dchild=1&keywords=Sams+Teach+Yourself+Regular+Expressions+in+10+Minutes&qid=1585917048&sr=8-2)  

## POSIX Character Classes  


|class|description|
|:-:|:-:|
|`[:alnum:]`|characters or numbers, equivalent to `[A-Za-z0-9]`|
|`[:alpha:]`|characters, equivalent to `[A-Za-z]`|
|`[:punct:]`|punctuations|
|`[:blank:]`|space or tab, equivalent to `[\t ]`|  
|`[:space:]`|any whitespace character including space `[\f\n\r\t\v ]`| 
|`[:print:]`|any printable character, a similar expression is `[:graph:]` which excludes space  
|`[:xdigit:]`|any hexadecimal digit, equivalent to  `[F-Aa-f0-9]`|  



## Greedy and lazy quantifiers 

|Greedy|Lazy|
|:-:|:-:|
|`*`|`*?`|
|`+`|`+?`|
|`{n, }`|`{n, }?`|  

A common use case of lazy quantifiers is when we need to strip from html form text all its tags: 


```r
text <- "This offer is not available to customers living in <B>AK</B> and <B>HI</B>"

# lazy 
str_extract_all(text, "<[Bb]>.+?</[Bb]>")
#> [[1]]
#> [1] "<B>AK</B>" "<B>HI</B>"
# greedy
str_extract_all(text, "<[Bb]>.+</[Bb]>")
#> [[1]]
#> [1] "<B>AK</B> and <B>HI</B>"
```





## Looking ahead and back  

Lookahead specifies a pattern to be matched but not returned. A *lookahead* is actually a subexpression and is formatted as such. The syntax for a lookahead pattern is a **subexpression** preceded by `?=`, and the text to match follows the `=` sign.  Some refer to this behaviour as "match but not consume", in the sense that lookhead and lookahead match a pattern after/before what we actually want to extract, but do not return it.   

In the following example, we only want to matcch "my homepage" that followed by a `</title>`, and we do not want `</title>` in the results  

```r
text <- c("<title>my homepage</title>", "<p>my homepage</p>")
str_extract(text, "my homepage(?=</title>)")
#> [1] "my homepage" NA
# looking ahead (and back) must be used in subexpressions 
str_extract(text, "my homepage?=</title>")
#> [1] NA NA
```


Similarly, `?<=` is interpreted as the *lookback* operator, which specifies a pattern before the text we actually want to extract. Following is an example. A database search lists products, and you need only the prices.  

Following is an example. A database search lists products, and you need only the prices.  


```r
text <- c("ABC01: $23.45", 
          "HGG42: $5.31", 
          "CFMX1: $899.00", 
          "XTC99: $69.96", 
          "Total items found: 4")

str_extract(text, "(?<=\\$)[0-9]+")
#> [1] "23"  "5"   "899" "69"  NA
```

ookahead and lookbehind operations may be combined, as in the following example  


```r
str_extract("<title>my homepage</title>", "(?<=<title>)my homepage(?=</title>)")
#> [1] "my homepage"
```


Additionally, `(?=)` and `(?<=)` are known as **positive** lookahead and lookback. A lesser used version is the **negative** form of those two operators, looking for text that does not match the specified pattern.  

class | description |  
:-:|:-:|
`(?=)` | positive lookahead |
`(?!)`| negative lookahead |
`(?<=)` | positive lookbehind | 
`(?<!)`| negative lookbehind|


Suppose we want to extract just the quantities but not the prices in the followin text: 

```r
text <- c("I paid $30 for 100 apples, 50 oranges, and 60 pears. I saved $5 on this order.")
# without word boundary, 0 after 3 as in $30 will be included
str_view_all(text, "\\b(?<!\\$)\\d+\\b")
```

<!--html_preserve--><div id="htmlwidget-d87e2579ce8ae6f76324" style="width:960px;height:100%;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-d87e2579ce8ae6f76324">{"x":{"html":"<ul>\n  <li>I paid $30 for <span class='match'>100<\/span> apples, <span class='match'>50<\/span> oranges, and <span class='match'>60<\/span> pears. I saved $5 on this order.<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->


## Backreferences 


Backreferences are used to overcome the problem that one match has no knowledge of its previous match, appearing as a pair of a subexpression and a `\number` referencing to that subexpression.  

Find all repeated words (often typos):  


```r
text <- "This is a block of of text, several words here are are repeated, and and they should not be."
str_view_all(text, "(\\w+) \\1")
```

<!--html_preserve--><div id="htmlwidget-8d217188afc5c82e30eb" style="width:960px;height:100%;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-8d217188afc5c82e30eb">{"x":{"html":"<ul>\n  <li>Th<span class='match'>is is<\/span> a block <span class='match'>of of<\/span> text, several words here <span class='match'>are are<\/span> repeated, <span class='match'>and and<\/span> they should not be.<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

Another example with html data where we want to match all normal header tags, note that the last pair `<h2>...<h3>` is invalid:  


```r
text <- "<BODY>
<H1>Welcome to my Homepage</H1>
Content is divided into two sections:<BR>
<H2>ColdFusion</H2>
Information about Macromedia ColdFusion.
<H2>Wireless</H2>
Information about Bluetooth, 802.11, and more.
<H2>This is not valid HTML</H3>
</BODY>"

str_extract_all(text, "<[Hh](\\d)>.+</[Hh]\\1>")
#> [[1]]
#> [1] "<H1>Welcome to my Homepage</H1>" "<H2>ColdFusion</H2>"            
#> [3] "<H2>Wireless</H2>"
```

**Backreferences is particularly useful when performing replace operations**.  


```r
text <- "user@gmail.com is my email address"
str_replace(text, "(.+@.+\\.com)", "<a href: \\1>\\1<a>")
#> [1] "<a href: user@gmail.com>user@gmail.com<a> is my email address"
```




