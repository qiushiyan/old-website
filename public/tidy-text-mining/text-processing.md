

# Text processing examples in R 

 A manual of problem-solving techniques in some common use cases dealing with text data, employing tools like [stringr](https://stringr.tidyverse.org/index.html) and [textclean](https://github.com/trinker/textclean)


## Replacing and removing  

## Combining and splitting 

Combine multiple line tokens to one paragraph (with a defined length) and the other way around  


```r
library(ggpage)

tinderbox_line <- head(tinderbox)
tinderbox_paragraph <- head(tinderbox_paragraph) 
  
  
# combine all six rows into a paragraph
tinderbox_line %>% 
  summarize(paragraph = str_c(text, collapse = " "))
#> # A tibble: 1 x 1
#>   paragraph                                                                     
#>   <chr>                                                                         
#> 1 "A soldier came marching along the high road: \"Left, right - left, right.\" ~

# split one paragraph into multiple rows 
# ggpage::nest_paragraphs() extends str_wrap()
tinderbox_paragraph %>% 
  mutate(paragraph_length = str_length(text)) %>% 
  nest_paragraphs(text, width = 50)  # no more than 50 characters per row
#>                                                   text paragraph_length
#> 1         A soldier came marching along the high road:              480
#> 2     "Left, right - left, right." He had his knapsack              480
#> 3    on his back, and a sword at his side; he had been              480
#> 4       to the wars, and was now returning home. As he              480
#> 5       walked on, he met a very frightful-looking old              480
#> 6     witch in the road. Her under-lip hung quite down              480
#> 7       on her breast, and she stopped and said, "Good              480
#> 8    evening, soldier; you have a very fine sword, and              480
#> 9     a large knapsack, and you are a real soldier; so              480
#> 10     you shall have as much money as ever you like."              480
#> 11   "Thank you, old witch," said the soldier. "Do you             2073
#> 12   see that large tree," said the witch, pointing to             2073
#> 13  a tree which stood beside them. "Well, it is quite             2073
#> 14       hollow inside, and you must climb to the top,             2073
#> 15     when you will see a hole, through which you can             2073
#> 16   let yourself down into the tree to a great depth.             2073
#> 17    I will tie a rope round your body, so that I can             2073
#> 18    pull you up again when you call out to me." "But             2073
#> 19     what am I to do, down there in the tree?" asked             2073
#> 20     the soldier. "Get money," she replied; "for you             2073
#> 21      must know that when you reach the ground under             2073
#> 22   the tree, you will find yourself in a large hall,             2073
#> 23    lighted up by three hundred lamps; you will then             2073
#> 24    see three doors, which can be easily opened, for             2073
#> 25      the keys are in all the locks. On entering the             2073
#> 26   first of the chambers, to which these doors lead,             2073
#> 27  you will see a large chest, standing in the middle             2073
#> 28      of the floor, and upon it a dog seated, with a             2073
#> 29      pair of eyes as large as teacups. But you need             2073
#> 30     not be at all afraid of him; I will give you my             2073
#> 31  blue checked apron, which you must spread upon the             2073
#> 32   floor, and then boldly seize hold of the dog, and             2073
#> 33     place him upon it. You can then open the chest,             2073
#> 34  and take from it as many pence as you please, they             2073
#> 35      are only copper pence; but if you would rather             2073
#> 36      have silver money, you must go into the second             2073
#> 37  chamber. Here you will find another dog, with eyes             2073
#> 38  as big as mill-wheels; but do not let that trouble             2073
#> 39    you. Place him upon my apron, and then take what             2073
#> 40  money you please. If, however, you like gold best,             2073
#> 41     enter the third chamber, where there is another             2073
#> 42    chest full of it. The dog who sits on this chest             2073
#> 43   is very dreadful; his eyes are as big as a tower,             2073
#> 44   but do not mind him. If he also is placed upon my             2073
#> 45    apron, he cannot hurt you, and you may take from             2073
#> 46   the chest what gold you will." "This is not a bad             2073
#> 47    story," said the soldier; "but what am I to give             2073
#> 48      you, you old witch? For, of course, you do not             2073
#> 49   mean to tell me all this for nothing." "No," said             2073
#> 50    the witch; "but I do not ask for a single penny.             2073
#> 51   Only promise to bring me an old tinder-box, which             2073
#> 52   my grandmother left behind the last time she went             2073
#> 53                                        down there."             2073
#> 54    "Very well; I promise. Now tie the rope round my              798
#> 55   body." "Here it is," replied the witch; "and here              798
#> 56      is my blue checked apron." As soon as the rope              798
#> 57      was tied, the soldier climbed up the tree, and              798
#> 58   let himself down through the hollow to the ground              798
#> 59   beneath; and here he found, as the witch had told              798
#> 60      him, a large hall, in which many hundred lamps              798
#> 61    were all burning. Then he opened the first door.              798
#> 62  "Ah!" there sat the dog, with the eyes as large as              798
#> 63  teacups, staring at him. "You're a pretty fellow,"              798
#> 64      said the soldier, seizing him, and placing him              798
#> 65   on the witch's apron, while he filled his pockets              798
#> 66    from the chest with as many pieces as they would              798
#> 67   hold. Then he closed the lid, seated the dog upon              798
#> 68     it again, and walked into another chamber, and,              798
#> 69  sure enough, there sat the dog with eyes as big as              798
#> 70                                        mill-wheels.              798
#> 71   "You had better not look at me in that way," said             1797
#> 72   the soldier; "you will make your eyes water;" and             1797
#> 73  then he seated him also upon the apron, and opened             1797
#> 74       the chest. But when he saw what a quantity of             1797
#> 75    silver money it contained, he very quickly threw             1797
#> 76   away all the coppers he had taken, and filled his             1797
#> 77   pockets and his knapsack with nothing but silver.             1797
#> 78     Then he went into the third room, and there the             1797
#> 79    dog was really hideous; his eyes were, truly, as             1797
#> 80      big as towers, and they turned round and round             1797
#> 81       in his head like wheels. "Good morning," said             1797
#> 82     the soldier, touching his cap, for he had never             1797
#> 83      seen such a dog in his life. But after looking             1797
#> 84   at him more closely, he thought he had been civil             1797
#> 85   enough, so he placed him on the floor, and opened             1797
#> 86   the chest. Good gracious, what a quantity of gold             1797
#> 87       there was! enough to buy all the sugar-sticks             1797
#> 88     of the sweet-stuff women; all the tin soldiers,             1797
#> 89     whips, and rocking-horses in the world, or even             1797
#> 90         the whole town itself There was, indeed, an             1797
#> 91     immense quantity. So the soldier now threw away             1797
#> 92   all the silver money he had taken, and filled his             1797
#> 93     pockets and his knapsack with gold instead; and             1797
#> 94     not only his pockets and his knapsack, but even             1797
#> 95  his cap and boots, so that he could scarcely walk.             1797
#> 96   He was really rich now; so he replaced the dog on             1797
#> 97   the chest, closed the door, and called up through             1797
#> 98   the tree: "Now pull me out, you old witch." "Have             1797
#> 99    you got the tinder-box?" asked the witch. "No; I             1797
#> 100    declare I quite forgot it." So he went back and             1797
#> 101 fetched the tinderbox, and then the witch drew him             1797
#> 102 up out of the tree, and he stood again in the high             1797
#> 103 road, with his pockets, his knapsack, his cap, and             1797
#> 104  his boots full of gold. "What are you going to do             1797
#> 105  with the tinder-box?" asked the soldier. "That is             1797
#> 106  nothing to you," replied the witch; "you have the             1797
#> 107                money, now give me the tinder-box."             1797
#> 108 "I tell you what," said the soldier, "if you don't             2188
#> 109   tell me what you are going to do with it, I will             2188
#> 110   draw my sword and cut off your head." "No," said             2188
#> 111     the witch. The soldier immediately cut off her             2188
#> 112     head, and there she lay on the ground. Then he             2188
#> 113   tied up all his money in her apron, and slung it             2188
#> 114    on his back like a bundle, put the tinderbox in             2188
#> 115    his pocket, and walked off to the nearest town.             2188
#> 116 It was a very nice town, and he put up at the best             2188
#> 117     inn, and ordered a dinner of all his favourite             2188
#> 118      dishes, for now he was rich and had plenty of             2188
#> 119 money. The servant, who cleaned his boots, thought             2188
#> 120    they certainly were a shabby pair to be worn by             2188
#> 121   such a rich gentleman, for he had not yet bought             2188
#> 122   any new ones. The next day, however, he procured             2188
#> 123    some good clothes and proper boots, so that our             2188
#> 124     soldier soon became known as a fine gentleman,             2188
#> 125   and the people visited him, and told him all the             2188
#> 126      wonders that were to be seen in the town, and             2188
#> 127    of the king's beautiful daughter, the princess.             2188
#> 128     "Where can I see her?" asked the soldier. "She             2188
#> 129   is not to be seen at all," they said; "she lives             2188
#> 130  in a large copper castle, surrounded by walls and             2188
#> 131    towers. No one but the king himself can pass in             2188
#> 132     or out, for there has been a prophecy that she             2188
#> 133   will marry a common soldier, and the king cannot             2188
#> 134  bear to think of such a marriage." "I should like             2188
#> 135 very much to see her," thought the soldier; but he             2188
#> 136  could not obtain permission to do so. However, he             2188
#> 137  passed a very pleasant time; went to the theatre,             2188
#> 138  drove in the king's garden, and gave a great deal             2188
#> 139  of money to the poor, which was very good of him;             2188
#> 140   he remembered what it had been in olden times to             2188
#> 141   be without a shilling. Now he was rich, had fine             2188
#> 142 clothes, and many friends, who all declared he was             2188
#> 143   a fine fellow and a real gentleman, and all this             2188
#> 144     gratified him exceedingly. But his money would             2188
#> 145    not last forever; and as he spent and gave away             2188
#> 146    a great deal daily, and received none, he found             2188
#> 147   himself at last with only two shillings left. So             2188
#> 148     he was obliged to leave his elegant rooms, and             2188
#> 149   live in a little garret under the roof, where he             2188
#> 150     had to clean his own boots, and even mend them             2188
#> 151   with a large needle. None of his friends came to             2188
#> 152   see him, there were too many stairs to mount up.             2188
#> 153 One dark evening, he had not even a penny to buy a             1191
#> 154  candle; then all at once he remembered that there             1191
#> 155     was a piece of candle stuck in the tinder-box,             1191
#> 156 which he had brought from the old tree, into which             1191
#> 157     the witch had helped him. He found the tinder-             1191
#> 158 box, but no sooner had he struck a few sparks from             1191
#> 159   the flint and steel, than the door flew open and             1191
#> 160   the dog with eyes as big as teacups, whom he had             1191
#> 161     seen while down in the tree, stood before him,             1191
#> 162     and said, "What orders, master?" "Hallo," said             1191
#> 163   the soldier; "well this is a pleasant tinderbox,             1191
#> 164       if it brings me all I wish for." - "Bring me             1191
#> 165  some money," said he to the dog. He was gone in a             1191
#> 166   moment, and presently returned, carrying a large             1191
#> 167 bag of coppers in his month. The soldier very soon             1191
#> 168     discovered after this the value of the tinder-             1191
#> 169  box. If he struck the flint once, the dog who sat             1191
#> 170  on the chest of copper money made his appearance;             1191
#> 171   if twice, the dog came from the chest of silver;             1191
#> 172 and if three times, the dog with eyes like towers,             1191
#> 173     who watched over the gold. The soldier had now             1191
#> 174 plenty of money; he returned to his elegant rooms,             1191
#> 175    and reappeared in his fine clothes, so that his             1191
#> 176  friends knew him again directly, and made as much             1191
#> 177                                  of him as before.             1191
```

## Extracting text from pdf and other files  


```r
library(pdftools)

download.file("http://arxiv.org/pdf/1403.2805.pdf", "data/1403.2805.pdf", mode = "wb")
txt <- pdf_text("data/1403.2805.pdf")

# all 29 pages  
length(txt) 
#> [1] 29

cat(txt[[2]])
#> JSON with R. We refer to Nolan and Temple Lang (2014) for a comprehensive introduction, or one of the
#> many tutorials available on the web. Instead we take a high level view and discuss how R data structures are
#> most naturally represented in JSON. This is not a trivial problem, particulary for complex or relational data
#> as they frequently appear in statistical applications. Several R packages implement toJSON and fromJSON
#> functions which directly convert R objects into JSON and vice versa. However, the exact mapping between
#> the various R data classes JSON structures is not self evident. Currently, there are no formal guidelines,
#> or even consensus between implementations on how R data should be represented in JSON. Furthermore,
#> upon closer inspection, even the most basic data structures in R actually do not perfectly map to their
#> JSON counterparts, and leave some ambiguity for edge cases. These problems have resulted in different
#> behavior between implementations, and can lead to unexpected output for certain special cases. To further
#> complicate things, best practices of representing data in JSON have been established outside the R community.
#> Incorporating these conventions where possible is important to maximize interoperability.
#> 1.1     Parsing and type safety
#> The JSON format specifies 4 primitive types (string, number, boolean, null) and two universal structures:
#>     • A JSON object : an unordered collection of zero or more name/value pairs, where a name is a string and
#>        a value is a string, number, boolean, null, object, or array.
#>     • A JSON array: an ordered sequence of zero or more values.
#> Both these structures are heterogeneous; i.e. they are allowed to contain elements of different types. There-
#> fore, the native R realization of these structures is a named list for JSON objects, and unnamed list for
#> JSON arrays. However, in practice a list is an awkward, inefficient type to store and manipulate data in R.
#> Most statistical applications work with (homogeneous) vectors, matrices or data frames. In order to give
#> these data structures a JSON representation, we can define certain special cases of JSON structures which get
#> parsed into other, more specific R types. For example, one convention which all current implementations
#> have in common is that a homogeneous array of primitives gets parsed into an atomic vector instead of a
#> list. The RJSONIO documentation uses the term “simplify” for this, and we adopt this jargon.
#> txt <- "[12, 3, 7]"
#> x <- fromJSON(txt)
#> is(x)
#> [1] "numeric" "vector"
#> print(x)
#> [1] 12     3   7
#> This seems very reasonable and it is the only practical solution to represent vectors in JSON. However the
#> price we pay is that automatic simplification can compromise type-safety in the context of dynamic data.
#> For example, suppose an R package uses fromJSON to pull data from a JSON API on the web, similar to
#> the example above. However, for some particular combination of parameters, the result includes a null
#> value, e.g: [12, null, 7]. This is actually quite common, many APIs use null for missing values or unset
#> fields. This case makes the behavior of parsers ambiguous, because the JSON array is technically no longer
#>                                                         2

enframe(txt) %>% 
  rename(page = name) %>% 
  nest_paragraphs(input = value, width = 100)
#>                                                                                                     text
#> 1   The jsonlite Package: A Practical and Consistent Mapping Between JSON Data and R Objects Jeroen Ooms
#> 2     arXiv:1403.2805v1 [stat.CO] 12 Mar 2014 UCLA Department of Statistics Abstract A naive realization
#> 3      of JSON data in R maps JSON arrays to an unnamed list, and JSON objects to a named list. However,
#> 4      in practice a list is an awkward, inefficient type to store and manipulate data. Most statistical
#> 5      applications work with (homogeneous) vectors, matrices or data frames. Therefore JSON packages in
#> 6    R typically define certain special cases of JSON structures which map to simpler R types. Currently
#> 7       there exist no formal guidelines, or even consensus between implementations on how R data should
#> 8       be represented in JSON. Furthermore, upon closer inspection, even the most basic data structures
#> 9        in R actually do not perfectly map to their JSON counterparts and leave some ambiguity for edge
#> 10        cases. These problems have resulted in different behavior between implementations and can lead
#> 11      to unexpected output. This paper explicitly describes a mapping between R classes and JSON data,
#> 12      highlights potential problems, and proposes conventions that generalize the mapping to cover all
#> 13        common structures. We emphasize the importance of type consistency when using JSON to exchange
#> 14  dynamic data, and illustrate using examples and anecdotes. The jsonlite R package is used throughout
#> 15   the paper as a reference implementation. 1 Introduction JavaScript Object Notation (JSON) is a text
#> 16     format for the serialization of structured data (Crockford, 2006a). It is derived from the object
#> 17     literals of JavaScript, as defined in the ECMAScript Programming Language Standard, Third Edition
#> 18       (ECMA, 1999). Design of JSON is simple and concise in comparison with other text based formats,
#> 19    and it was originally proposed by Douglas Crockford as a “fat-free alternative to XML” (Crockford,
#> 20      2006b). The syntax is easy for humans to read and write, easy for machines to parse and generate
#> 21      and completely described in a single page at http://www.json.org. The character encoding of JSON
#> 22     text is always Unicode, using UTF-8 by default (Crockford, 2006a), making it naturally compatible
#> 23     with non- latin alphabets. Over the past years, JSON has become hugely popular on the internet as
#> 24    a general purpose data interchange format. High quality parsing libraries are available for almost
#> 25     any programming language, making it easy to implement systems and applications that exchange data
#> 26      over the network using JSON. For R (R Core Team, 2013), several packages that assist the user in
#> 27    generating, parsing and validating JSON are available through CRAN, including rjson (Couture-Beil,
#> 28   2013), RJSONIO (Lang, 2013), and jsonlite (Ooms et al., 2014). The emphasis of this paper is not on
#> 29                               discussing the JSON format or any particular implementation for using 1
#> 30     JSON with R. We refer to Nolan and Temple Lang (2014) for a comprehensive introduction, or one of
#> 31     the many tutorials available on the web. Instead we take a high level view and discuss how R data
#> 32     structures are most naturally represented in JSON. This is not a trivial problem, particulary for
#> 33  complex or relational data as they frequently appear in statistical applications. Several R packages
#> 34    implement toJSON and fromJSON functions which directly convert R objects into JSON and vice versa.
#> 35    However, the exact mapping between the various R data classes JSON structures is not self evident.
#> 36         Currently, there are no formal guidelines, or even consensus between implementations on how R
#> 37     data should be represented in JSON. Furthermore, upon closer inspection, even the most basic data
#> 38    structures in R actually do not perfectly map to their JSON counterparts, and leave some ambiguity
#> 39   for edge cases. These problems have resulted in different behavior between implementations, and can
#> 40     lead to unexpected output for certain special cases. To further complicate things, best practices
#> 41       of representing data in JSON have been established outside the R community. Incorporating these
#> 42     conventions where possible is important to maximize interoperability. 1.1 Parsing and type safety
#> 43         The JSON format specifies 4 primitive types (string, number, boolean, null) and two universal
#> 44         structures: • A JSON object : an unordered collection of zero or more name/value pairs, where
#> 45         a name is a string and a value is a string, number, boolean, null, object, or array. • A JSON
#> 46      array: an ordered sequence of zero or more values. Both these structures are heterogeneous; i.e.
#> 47     they are allowed to contain elements of different types. There- fore, the native R realization of
#> 48      these structures is a named list for JSON objects, and unnamed list for JSON arrays. However, in
#> 49   practice a list is an awkward, inefficient type to store and manipulate data in R. Most statistical
#> 50         applications work with (homogeneous) vectors, matrices or data frames. In order to give these
#> 51         data structures a JSON representation, we can define certain special cases of JSON structures
#> 52     which get parsed into other, more specific R types. For example, one convention which all current
#> 53   implementations have in common is that a homogeneous array of primitives gets parsed into an atomic
#> 54   vector instead of a list. The RJSONIO documentation uses the term “simplify” for this, and we adopt
#> 55      this jargon. txt <- "[12, 3, 7]" x <- fromJSON(txt) is(x) [1] "numeric" "vector" print(x) [1] 12
#> 56    3 7 This seems very reasonable and it is the only practical solution to represent vectors in JSON.
#> 57   However the price we pay is that automatic simplification can compromise type-safety in the context
#> 58      of dynamic data. For example, suppose an R package uses fromJSON to pull data from a JSON API on
#> 59    the web, similar to the example above. However, for some particular combination of parameters, the
#> 60   result includes a null value, e.g: [12, null, 7]. This is actually quite common, many APIs use null
#> 61    for missing values or unset fields. This case makes the behavior of parsers ambiguous, because the
#> 62                                                                 JSON array is technically no longer 2
#> 63       homogenous. And indeed, some implementations will now return a list instead of a vector. If the
#> 64         user had not anticipated this scenario and the script assumes a vector, the code is likely to
#> 65      run into type errors. The lesson here is that we need to be very specific and explicit about the
#> 66     mapping that is implemented to convert between JSON and R objects. When relying on JSON as a data
#> 67    interchange format, the behavior of the parser must be consistent and unambiguous. Clients relying
#> 68  on JSON to get data in and out of R must know exactly what to expect in order to facilitate reliable
#> 69     communication, even if the data themselves are dynamic. Similarly, R code using dynamic JSON data
#> 70   from an external source is only reliable when the conversion from JSON to R is consistent. Moreover
#> 71    a practical mapping must incorporate existing conventions and uses the most natural representation
#> 72       of certain structures in R. For example, we could argue that instead of falling back on a list,
#> 73    the array above is more naturally interpreted as a numeric vector where the null becomes a missing
#> 74     value (NA). These principles will extrapolate as we start discussing more complex JSON structures
#> 75         representing matrices and data frames. 1.2 Reference implementation: the jsonlite package The
#> 76    jsonlite package provides a reference implementation of the conventions proposed in this document.
#> 77    jsonlite is a fork of the RJSONIO package by Duncan Temple Lang, which again builds on libjson C++
#> 78  library from Jonathan Wallace. The jsonlite package uses the parser from RJSONIO, but the R code has
#> 79  been rewritten from scratch. Both packages implement toJSON and fromJSON functions, but their output
#> 80      is quite different. Finally, the jsonlite package contains a large set of unit tests to validate
#> 81     that R objects are correctly converted to JSON and vice versa. These unit tests cover all classes
#> 82     and edge cases mentioned in this document, and could be used to validate if other implementations
#> 83    follow the same conventions. library(testthat) test_package("jsonlite") Note that even though JSON
#> 84    allows for inserting arbitrary white space and indentation, the unit tests assume that white space
#> 85       is trimmed. 1.3 Class-based versus type-based encoding The jsonlite package actually implements
#> 86       two systems for translating between R objects and JSON. This document focuses on the toJSON and
#> 87        fromJSON functions which use R’s class-based method dispatch. For all of the common classes in
#> 88         R, the jsonlite package implements toJSON methods as described in this doc- ument. Users in R
#> 89        can extend this system by implementing additional methods for other classes. However this also
#> 90     means that classes that do not have the toJSON method defined are not supported. Furthermore, the
#> 91  implementation of a specific toJSON method determines which data and metadata in the objects of this
#> 92    class gets encoded in its JSON representation, and how. In this respect, toJSON is similar to e.g.
#> 93  the print function, which also provides a certain representation of an object based on its class and
#> 94  option- ally some print parameters. This representation does not necessarily reflect all information
#> 95      stored in the object, and there is no guaranteed one-to-one correspondence between R objects and
#> 96   JSON. I.e. calling fromJSON(toJSON(object)) will return an object which only contains the data that
#> 97     was encoded by the toJSON method for this particular class, and which might even have a different
#> 98                                                                            class than the original. 3
#> 99          The alternative to class-based method dispatch is to use type-based encoding, which jsonlite
#> 100   implements in the functions serializeJSON and unserializeJSON. All data structures in R get stored
#> 101        in memory using one of the internal SEXP storage types, and serializeJSON defines an encoding
#> 102      schema which captures the type, value, and attributes for each storage type. The result is JSON
#> 103      output which closely resembles the internal structure of the underlying C data types, and which
#> 104  can be perfectly restored to the original R object using unserializeJSON. This system is relatively
#> 105   straightforward to implement, however the disadvantage is that the resulting JSON is very verbose,
#> 106      hard to interpret, and cumbersome to generate in the context of another language or system. For
#> 107 most applications this is actually impractical because it requires the client/consumer to understand
#> 108    and manipulate R data types, which is difficult and reduces interoperability. Instead we can make
#> 109        data in R more accessible to third parties by defining sensible JSON representations that are
#> 110    natural for the class of an object, rather than its internal storage type. This document does not
#> 111     discuss the serializeJSON system in any further detail, and solely treats the class based system
#> 112      implemented in toJSON and fromJSON. However the reader that is interested in full serialization
#> 113    of R objects into JSON is encouraged to have a look at the respective manual pages. 1.4 Scope and
#> 114   limitations Before continuing, we want to stress some limitations of encoding R data structures in
#> 115     JSON. Most impor- tantly, there are the limitations to types of objects that can be represented.
#> 116     In general, temporary in-memory properties such as connections, file descriptors and (recursive)
#> 117      memory references are always difficult if not impossible to store in a sensible way, regardless
#> 118     of the language or serialization method. This document focuses on the common R classes that hold
#> 119      data, such as vectors, factors, lists, matrices and data frames. We do not treat language level
#> 120   constructs such as expressions, functions, promises, which hold little meaning outside the context
#> 121   of R. We also don’t treat special compound classes such as linear models or custom classes defined
#> 122      in contributed packages. When designing systems or protocols that interact with R, it is highly
#> 123    recommended to stick with the standard data structures for the interface input/output. Then there
#> 124    are limitations introduced by the format. Because JSON is a human readable, text-based format, it
#> 125  does not support binary data, and numbers are stored in their decimal notation. The latter leads to
#> 126  loss of precision for real numbers, depending on how many digits the user decides to print. Several
#> 127 dialects of JSON exists such as BSON (Chodorow, 2013) or MSGPACK (Furuhashi, 2014), which extend the
#> 128  format with various binary types. However, these formats are much less popular, less interoperable,
#> 129  and often impractical, precisely because they require binary parsing and abandon human readability.
#> 130 The simplicity of JSON is what makes it an accessible and widely applicable data interchange format.
#> 131   In cases where it is really needed to include some binary data in JSON, one can use something like
#> 132    base64 to encode it as a string. Finally, as mentioned earlier, fromJSON is not a perfect inverse
#> 133   function of toJSON, as would be the case for serialializeJSON and unserializeJSON. The class based
#> 134  mappings are designed for concise and practical encoding of the various common data structures. Our
#> 135 implementation of toJSON and fromJSON approxi- mates a reversible mapping between R objects and JSON
#> 136     for the standard data classes, but there are always limitations and edge cases. For example, the
#> 137 JSON representation of an empty vector, empty list or empty data frame are all the same: "[ ]". Also
#> 138 some special vector types such as factors, dates or timestamps get coerced to strings, as they would
#> 139   in for example CSV. This is a quite typical and expected behavior among text based formats, but it
#> 140                                  does require some additional interpretation on the consumer side. 4
#> 141      2 Converting between JSON and R classes This section lists examples of how the common R classes
#> 142   are represented in JSON. As explained before, the toJSON function relies on method dispatch, which
#> 143   means that objects get encoded according to their class. If an object has multiple class values, R
#> 144    uses the first occurring class which has a toJSON method. If none of the classes of an object has
#> 145  a toJSON method, an error is raised. 2.1 Atomic vectors The most basic data type in R is the atomic
#> 146   vector. The atomic vector holds an ordered set of homogeneous values of type "logical" (booleans),
#> 147    character (strings), "raw" (bytes), numeric (doubles), "complex" (complex numbers with a real and
#> 148       imaginary part), or integer. Because R is fully vectorized, there is no user level notion of a
#> 149     primitive: a scalar value is considered a vector of length 1. Atomic vectors map to JSON arrays:
#> 150      x <- c(1, 2, pi) cat(toJSON(x)) [ 1, 2, 3.14 ] The JSON array is the only appropriate structure
#> 151        to encode a vector, however note that vectors in R are homogeneous, whereas the JSON array is
#> 152      actually heterogeneous, but JSON does not make this distinction. 2.1.1 Missing values A typical
#> 153 domain specific problem when working with statistical data is presented by missing values: a concept
#> 154    foreign to many other languages. Besides regular values, each vector type in R except for raw can
#> 155   hold NA as a value. Vectors of type double and complex define three additional types of non finite
#> 156   values: NaN, Inf and -Inf. The JSON format does not natively support any of these types; therefore
#> 157 such values values need to be encoded in some other way. There are two obvious approaches. The first
#> 158 one is to use the JSON null type. For example: x <- c(TRUE, FALSE, NA) cat(toJSON(x)) [ true, false,
#> 159  null ] The other option is to encode missing values as strings by wrapping them in double quotes: x
#> 160  <- c(1, 2, NA, NaN, Inf, 10) cat(toJSON(x)) [ 1, 2, "NA", "NaN", "Inf", 10 ] Both methods result in
#> 161   valid JSON, but both have a limitation: the problem with the null type is that it is impossible to
#> 162   distinguish between different types of missing data, which could be a problem for numeric vectors.
#> 163    The values Inf, -Inf, NA and NaN carry different meanings, and these should not get lost in the 5
#> 164       encoding. However, the problem with encoding missing values as strings is that this method can
#> 165      not be used for character vectors, because the consumer won’t be able to distinguish the actual
#> 166       string "NA" and the missing value NA. This would create a likely source of bugs, where clients
#> 167      mistakenly interpret "NA" as an actual value, which is a common problem with text-based formats
#> 168         such as CSV. For this reason, jsonlite uses the following defaults: • Missing values in non-
#> 169        numeric vectors (logical, character) are encoded as null. • Missing values in numeric vectors
#> 170         (double, integer, complex) are encoded as strings. We expect that these conventions are most
#> 171  likely to result in the correct interpretation of missing values. Some examples: cat(toJSON(c(TRUE,
#> 172         NA, NA, FALSE))) [ true, null, null, false ] cat(toJSON(c("FOO", "BAR", NA, "NA"))) [ "FOO",
#> 173     "BAR", null, "NA" ] cat(toJSON(c(3.14, NA, NaN, 21, Inf, -Inf))) [ 3.14, "NA", "NaN", 21, "Inf",
#> 174           "-Inf" ] cat(toJSON(c(3.14, NA, NaN, 21, Inf, -Inf), na = "null")) [ 3.14, null, null, 21,
#> 175       null, null ] 2.1.2 Special vector types: dates, times, factor, complex Besides missing values,
#> 176        JSON also lacks native support for some of the basic vector types in R that frequently appear
#> 177          in data sets. These include vectors of class Date, POSIXt (timestamps), factors and complex
#> 178       vectors. By default, the jsonlite package coerces these types to strings (using as.character):
#> 179            cat(toJSON(Sys.time() + 1:3)) [ "2014-03-11 21:16:05", "2014-03-11 21:16:06", "2014-03-11
#> 180      21:16:07" ] cat(toJSON(as.Date(Sys.time()) + 1:3)) [ "2014-03-13", "2014-03-14", "2014-03-15" ]
#> 181        cat(toJSON(factor(c("foo", "bar", "foo")))) [ "foo", "bar", "foo" ] cat(toJSON(complex(real =
#> 182        runif(3), imaginary = rnorm(3)))) [ "0.5+1.7i", "0-2i", "0.37-0.13i" ] When parsing such JSON
#> 183   strings, these values will appear as character vectors. In order to obtain the original types, the
#> 184     user needs to manually coerce them back to the desired type using the corresponding as function,
#> 185    e.g. as.POSIXct, as.Date, as.factor or as.complex. In this respect, JSON is subject to the same 6
#> 186     limitations as text based formats such as CSV. 2.1.3 Special cases: vectors of length 0 or 1 Two
#> 187       edge cases deserve special attention: vectors of length 0 and vectors of length 1. In jsonlite
#> 188      these are encoded respectively as an empty array, and an array of length 1: # vectors of length
#> 189    0 and 1 cat(toJSON(vector())) [ ] cat(toJSON(pi)) [ 3.14 ] # vectors of length 0 and 1 in a named
#> 190         list cat(toJSON(list(foo = vector()))) { "foo" : [ ] } cat(toJSON(list(foo = pi))) { "foo" :
#> 191        [ 3.14 ] } # vectors of length 0 and 1 in an unnamed list cat(toJSON(list(vector()))) [ [ ] ]
#> 192  cat(toJSON(list(pi))) [ [ 3.14 ] ] This might seem obvious but these cases result in very different
#> 193 behavior between different JSON packages. This is probably caused by the fact that R does not have a
#> 194 scalar type, and some package authors decided to treat vectors of length 1 as if they were a scalar.
#> 195        For example, in the current implementations, both RJSONIO and rjson encode a vector of length
#> 196      one as a JSON primitive when it appears within a list: # Other packages make different choices:
#> 197    cat(rjson::toJSON(list(n = c(1)))) {"n":1} cat(rjson::toJSON(list(n = c(1, 2)))) {"n":[1,2]} When
#> 198 encoding a single dataset this seems harmless, but in the context of dynamic data this inconsistency
#> 199    is almost guaranteed to cause bugs. For example, imagine an R web service which lets the user fit
#> 200   a linear model and sends back the fitted parameter estimates as a JSON array. The client code then
#> 201      parses the JSON, and iterates over the array of coefficients to display them in a GUI. All goes
#> 202    well, until the user decides to fit a model with only one predictor. If the JSON encoder suddenly
#> 203                                                         returns a primitive value where the client 7
#> 204     is assuming an array, the application will likely break. Any consumer or client would need to be
#> 205   aware of the special case where the vector becomes a primitive, and explicitly take this exception
#> 206    into account when processing the result. When the client fails to do so and proceeds as usual, it
#> 207 will probably call an iterator or loop method on a primitive value, resulting in the obvious errors.
#> 208     For this reason jsonlite uses consistent encoding schemes which do not depend on variable object
#> 209     properties such as its length. Hence, a vector is always encoded as an array, even when it is of
#> 210     length 0 or 1. 2.2 Matrices Arguably one of the strongest sides of R is its ability to interface
#> 211      libraries for basic linear algebra subpro- grams (Lawson et al., 1979) such as LAPACK (Anderson
#> 212     et al., 1999). These libraries provide well tuned, high performance implementations of important
#> 213     linear algebra operations to calculate anything from inner products and eigen values to singular
#> 214  value decompositions. These are in turn the building blocks of statis- tical methods such as linear
#> 215   regression or principal component analysis. Linear algebra methods operate on matrices, making the
#> 216 matrix one of the most central data classes in R. Conceptually, a matrix consists of a 2 dimensional
#> 217    structure of homogeneous values. It is indexed using 2 numbers (or vectors), representing the row
#> 218    and column number of the matrix respectively. x <- matrix(1:12, nrow = 3, ncol = 4) print(x) [,1]
#> 219    [,2] [,3] [,4] [1,] 1 4 7 10 [2,] 2 5 8 11 [3,] 3 6 9 12 print(x[2, 4]) [1] 11 A matrix is stored
#> 220    in memory as a single atomic vector with an attribute called "dim" defining the dimensions of the
#> 221 matrix. The product of the dimensions is equal to the length of the vector. attributes(volcano) $dim
#> 222   [1] 87 61 length(volcano) [1] 5307 Even though the matrix is stored as a single vector, the way it
#> 223 is printed and indexed makes it conceptually a 2 dimensional structure. In jsonlite a matrix maps to
#> 224   an array of equal-length subarrays: x <- matrix(1:12, nrow = 3, ncol = 4) cat(toJSON(x)) [ [ 1, 4,
#> 225                                                        7, 10 ], [ 2, 5, 8, 11 ], [ 3, 6, 9, 12 ] ] 8
#> 226    We expect this representation will be the most intuitive to interpret, also within languages that
#> 227     do not have a native notion of a matrix. Note that even though R stores matrices in column major
#> 228       order, jsonlite encodes matrices in row major order. This is a more conventional and intuitive
#> 229     way to represent matrices and is consistent with the row-based encoding of data frames discussed
#> 230     in the next section. When the JSON string is properly indented (recall that white space and line
#> 231 breaks are optional in JSON), it looks very similar to the way R prints matrices: [ [ 1, 4, 7, 10 ],
#> 232    [ 2, 5, 8, 11 ], [ 3, 6, 9, 12 ] ] Because the matrix is implemented in R as an atomic vector, it
#> 233      automatically inherits the conventions mentioned earlier with respect to edge cases and missing
#> 234 values: x <- matrix(c(1, 2, 4, NA), nrow = 2) cat(toJSON(x)) [ [ 1, 4 ], [ 2, "NA" ] ] cat(toJSON(x,
#> 235    na = "null")) [ [ 1, 4 ], [ 2, null ] ] cat(toJSON(matrix(pi))) [ [ 3.14 ] ] 2.2.1 Matrix row and
#> 236    column names Besides the "dim" attribute, the matrix class has an additional, optional attribute:
#> 237   "dimnames". This attribute holds names for the rows and columns in the matrix. However, we decided
#> 238  not to include this information in the default JSON mapping for matrices for several reasons. First
#> 239  of all, because this attribute is optional, often either row or column names or both are NULL. This
#> 240    makes it difficult to define a practical encoding that covers all cases with and without row and/
#> 241  or column names. Secondly, the names in matrices are mostly there for annotation only; they are not
#> 242   actually used in calculations. The linear algebra subrou- tines mentioned before completely ignore
#> 243 them, and never include any names in their output. So there is often little purpose of setting names
#> 244      in the first place, other than annotation. When row or column names of a matrix seem to contain
#> 245    vital information, we might want to transform the data into a more appropriate structure. Wickham
#> 246      (2014) calls this “tidying” the data and outlines best practices on storing statistical data in
#> 247  its most appropriate form. He lists the issue where “column headers are values, not variable names”
#> 248     as the most common source of untidy data. This often happens when the structure is optimized for
#> 249  presentation (e.g. printing), rather than computation. In the following example taken from Wickham,
#> 250   the predictor variable (treatment) is stored in the column headers rather than the actual data. As
#> 251    a result, these values are not included in the JSON: x <- matrix(c(NA, 1, 2, 5, NA, 3), nrow = 3)
#> 252                                                           row.names(x) <- c("Joe", "Jane", "Mary") 9
#> 253        colnames(x) <- c("Treatment A", "Treatment B") print(x) Treatment A Treatment B Joe NA 5 Jane
#> 254          1 NA Mary 2 3 cat(toJSON(x)) [ [ "NA", 5 ], [ 1, "NA" ], [ 2, 3 ] ] Wickham recommends that
#> 255       the data be melted into its tidy form. Once the data is tidy, the JSON encoding will naturally
#> 256   contain the treatment values: library(reshape2) y <- melt(x, varnames = c("Subject", "Treatment"))
#> 257        print(y) Subject Treatment value 1 Joe Treatment A NA 2 Jane Treatment A 1 3 Mary Treatment A
#> 258       2 4 Joe Treatment B 5 5 Jane Treatment B NA 6 Mary Treatment B 3 cat(toJSON(y, pretty = TRUE))
#> 259 [ { "Subject" : "Joe", "Treatment" : "Treatment A" }, { "Subject" : "Jane", "Treatment" : "Treatment
#> 260   A", "value" : 1 }, { "Subject" : "Mary", "Treatment" : "Treatment A", "value" : 2 }, { "Subject" :
#> 261                                                               "Joe", "Treatment" : "Treatment B", 10
#> 262            "value" : 5 }, { "Subject" : "Jane", "Treatment" : "Treatment B" }, { "Subject" : "Mary",
#> 263     "Treatment" : "Treatment B", "value" : 3 } ] In some other cases, the column headers actually do
#> 264     contain variable names, and melting is inappropriate. For data sets with records consisting of a
#> 265     set of named columns (fields), R has more natural and flexible class: the data-frame. The toJSON
#> 266    method for data frames (described later) is more suitable when we want to refer to rows or fields
#> 267  by their name. Any matrix can easily be converted to a data-frame using the as.data.frame function:
#> 268     cat(toJSON(as.data.frame(x), pretty = TRUE)) [ { "$row" : "Joe", "Treatment B" : 5 }, { "$row" :
#> 269    "Jane", "Treatment A" : 1 }, { "$row" : "Mary", "Treatment A" : 2, "Treatment B" : 3 } ] For some
#> 270    cases this results in the desired output, but in this example melting seems more appropriate. 2.3
#> 271 Lists The list is the most general purpose data structure in R. It holds an ordered set of elements,
#> 272  including other lists, each of arbitrary type and size. Two types of lists are distinguished: named
#> 273 lists and unnamed lists. A list is considered a named list if it has an attribute called "names". In
#> 274                                                                         practice, a named list is 11
#> 275    any list for which we can access an element by its name, whereas elements of an unnamed lists can
#> 276  only be accessed using their index number: mylist1 <- list(foo = 123, bar = 456) print(mylist1$bar)
#> 277 [1] 456 mylist2 <- list(123, 456) print(mylist2[[2]]) [1] 456 2.3.1 Unnamed lists Just like vectors,
#> 278 an unnamed list maps to a JSON array: cat(toJSON(list(c(1, 2), "test", TRUE, list(c(1, 2))))) [ [ 1,
#> 279   2 ], [ "test" ], [ true ], [ [ 1, 2 ] ] ] Note that even though both vectors and lists are encoded
#> 280      using JSON arrays, they can be distinguished from their contents: an R vector results in a JSON
#> 281     array containing only primitives, whereas a list results in a JSON array containing only objects
#> 282    and arrays. This allows the JSON parser to reconstruct the original type from encoded vectors and
#> 283      arrays: x <- list(c(1, 2, NA), "test", FALSE, list(foo = "bar")) identical(fromJSON(toJSON(x)),
#> 284     x) [1] TRUE The only exception is the empty list and empty vector, which are both encoded as [ ]
#> 285       and therefore indistinguishable, but this is rarely a problem in practice. 2.3.2 Named lists A
#> 286     named list in R maps to a JSON object : cat(toJSON(list(foo = c(1, 2), bar = "test"))) { "foo" :
#> 287       [ 1, 2 ], "bar" : [ "test" ] } Because a list can contain other lists, this works recursively:
#> 288     cat(toJSON(list(foo=list(bar=list(baz=pi))))) { "foo" : { "bar" : { "baz" : [ 3.14 ] } } } Named
#> 289   lists map almost perfectly to JSON objects with one exception: list elements can have empty names:
#> 290                                                                                                   12
#> 291         x <- list(foo = 123, "test", TRUE) attr(x, "names") [1] "foo" "" "" x$foo [1] 123 x[[2]] [1]
#> 292  "test" In a JSON object, each element in an object must have a valid name. To ensure this property,
#> 293   jsonlite uses the same solution as the print method, which is to fall back on indices for elements
#> 294   that do not have a proper name: x <- list(foo = 123, "test", TRUE) print(x) $foo [1] 123 [[2]] [1]
#> 295      "test" [[3]] [1] TRUE cat(toJSON(x)) { "foo" : [ 123 ], "2" : [ "test" ], "3" : [ true ] } This
#> 296       behavior ensures that all generated JSON is valid, however named lists with empty names should
#> 297     be avoided where possible. When actually designing R objects that should be interoperable, it is
#> 298  recommended that each list element is given a proper name. 2.4 Data frame The data frame is perhaps
#> 299   the most central data structure in R from the user point of view. This class holds tabular data in
#> 300  which each column is named and (usually) homogeneous. Conceptually it is very similar to a table in
#> 301   relational data bases such as MySQL, where fields are referred to as column names, and records are
#> 302  called row names. Like a matrix, a data frame can be subsetted with two indices, to extract certain
#> 303    rows and columns of the data: is(iris) [1] "data.frame" "list" "oldClass" "vector" names(iris) 13
#> 304     [1] "Sepal.Length" "Sepal.Width" "Petal.Length" "Petal.Width" [5] "Species" print(iris[1:3, c(1,
#> 305    5)]) Sepal.Length Species 1 5.1 setosa 2 4.9 setosa 3 4.7 setosa print(iris[1:3, c("Sepal.Width",
#> 306 "Species")]) Sepal.Width Species 1 3.5 setosa 2 3.0 setosa 3 3.2 setosa For the previously discussed
#> 307   classes such as vectors and matrices, behavior of jsonlite is quite similar to the other available
#> 308  packages that implement toJSON and toJSON functions, with only minor differences for missing values
#> 309    and edge cases. But when it comes to data frames, jsonlite takes a completely different approach.
#> 310     The behavior of jsonlite is designed for compatibility with conventional ways of encoding table-
#> 311        like structures outside the R community. The implementation is more complex, but results in a
#> 312   powerful and more natural way of interfacing data frames through JSON and vice versa. 2.4.1 Column
#> 313      based versus row based tables Generally speaking, tabular data structures can be implemented in
#> 314  two different ways: in a column based, or row based fashion. A column based structure consists of a
#> 315  named collection of equal-length, homogeneous arrays representing the table columns. In a row-based
#> 316   structure on the other hand, the table is implemented as a set of heterogeneous associative arrays
#> 317     representing table rows with field values for each particular record. Even though most languages
#> 318      provide flexible and abstracted interfaces that hide such implementation details from the user,
#> 319 they can have huge implications for performance. A column based structure is efficient for inserting
#> 320   or extracting certain columns of the data, but it is inefficient for manipulating individual rows.
#> 321     For example to insert a single row somewhere in the middle, each of the columns has to be sliced
#> 322      and stitched back together. For row-based implementations, it is the exact other way around: we
#> 323     can easily manipulate a particular record, but to insert/extract a whole column we would need to
#> 324     iterate over all records in the table and read/modify the appropriate field in each of them. The
#> 325   data frame in R is implemented in a column based fashion: it constitutes of a named list of equal-
#> 326   length vectors. Thereby the columns in the data frame naturally inherit the properties from atomic
#> 327     vectors discussed before, such as homogeneity, missing values, etc. Another argument for column-
#> 328      based implementation is that statistical methods generally operate on columns. For example, the
#> 329     lm function fits a linear regression by extracting the columns from a data frame as specified by
#> 330    the formula argument. R simply binds the specified columns together into a matrix X and calls out
#> 331      to a highly optimized FORTRAN subroutine to calculate the OLS estimates ß^ = (X T X)X T y using
#> 332   the QR factorization of X. Many other statistical modeling functions follow similar steps, and are
#> 333                                computationally efficient because of the column-based data storage 14
#> 334           in R. However, unfortunately R is an exception in its preference for column-based storage:
#> 335        most languages, systems, databases, APIs, etc, are optimized for record based operations. For
#> 336      this reason, the conventional way to store and communicate tabular data in JSON seems to almost
#> 337  exclusively row based. This discrepancy presents various complications when converting between data
#> 338      frames and JSON. The remaining of this section discusses details and challenges of consistently
#> 339   mapping record based JSON data as frequently encountered on the web, into column-based data frames
#> 340     which are convenient for statistical computing. 2.4.2 Row based data frame encoding The encoding
#> 341       of data frames is one of the major differences between jsonlite and implementations from other
#> 342        currently available packages. Instead of using the column-based encoding also used for lists,
#> 343          jsonlite maps data frames by default to an array of records: cat(toJSON(iris[1:2, ], pretty
#> 344        = TRUE)) [ { "Sepal.Length" : 5.1, "Sepal.Width" : 3.5, "Petal.Length" : 1.4, "Petal.Width" :
#> 345        0.2, "Species" : "setosa" }, { "Sepal.Length" : 4.9, "Sepal.Width" : 3, "Petal.Length" : 1.4,
#> 346    "Petal.Width" : 0.2, "Species" : "setosa" } ] This output looks a bit like a list of named lists.
#> 347      However, there is one major difference: the individual records contain JSON primitives, whereas
#> 348     lists always contain JSON objects or arrays: cat(toJSON(list(list(Species = "Foo", Width = 21)),
#> 349                                       pretty = TRUE)) [ { "Species" : [ "Foo" ], "Width" : [ 21 ] 15
#> 350     } ] This leads to the following convention: when encoding R objects, JSON primitives only appear
#> 351     in vectors and data-frame rows. Primitive values within a JSON array indicate a vector, and JSON
#> 352  primitives appearing inside a JSON object indicate a data-frame row. A JSON encoded list, (named or
#> 353    unnamed) will never contain JSON primitives. This is a subtle but important convention that helps
#> 354     to distinguish between R classes from their JSON representation, without explicitly encoding any
#> 355    metadata. 2.4.3 Missing values in data frames The section on atomic vectors discussed two methods
#> 356    of encoding missing data appearing in a vector: either using strings or using the JSON null type.
#> 357 When a missing value appears in a data frame, there is a third option: simply not include this field
#> 358   in JSON record: x <- data.frame(foo = c(FALSE, TRUE, NA, NA), bar = c("Aladdin", NA, NA, "Mario"))
#> 359      print(x) foo bar 1 FALSE Aladdin 2 TRUE <NA> 3 NA <NA> 4 NA Mario cat(toJSON(x, pretty = TRUE))
#> 360      [ { "foo" : false, "bar" : "Aladdin" }, { "foo" : true }, {}, { "bar" : "Mario" } ] The default
#> 361      behavior of jsonlite is to omit missing data from records in a data frame. This seems to be the
#> 362   most conventional method used on the web, and we expect this encoding will most likely lead to the
#> 363           correct interpretation of missingness, even in languages with no explicit notion of NA. 16
#> 364      2.4.4 Relational data: nested records Nested datasets are somewhat unusual in R, but frequently
#> 365         encountered in JSON. Such structures do not really fit the vector based paradigm which makes
#> 366     them harder to manipulate in R. However, nested structures are too common in JSON to ignore, and
#> 367       with a little work most cases still map to a data frame quite nicely. The most common scenario
#> 368        is a dataset in which a certain field within each record contains a subrecord with additional
#> 369        fields. The jsonlite implementation maps these subrecords to a nested data frame. Whereas the
#> 370       data frame class usually consists of vectors, technically a column can also be list or another
#> 371          data frame with matching dimension (this stretches the meaning of the word “column” a bit):
#> 372          options(stringsAsFactors=FALSE) x <- data.frame(driver = c("Bowser", "Peach"), occupation =
#> 373         c("Koopa", "Princess")) x$vehicle <- data.frame(model = c("Piranha Prowler", "Royal Racer"))
#> 374       x$vehicle$stats <- data.frame(speed = c(55, 34), weight = c(67, 24), drift = c(35, 32)) str(x)
#> 375       'data.frame': 2 obs. of 3 variables: $ driver : chr "Bowser" "Peach" $ occupation: chr "Koopa"
#> 376   "Princess" $ vehicle :'data.frame': 2 obs. of 2 variables: ..$ model: chr "Piranha Prowler" "Royal
#> 377    Racer" ..$ stats:'data.frame': 2 obs. of 3 variables: .. ..$ speed : num 55 34 .. ..$ weight: num
#> 378   67 24 .. ..$ drift : num 35 32 cat(toJSON(x, pretty=TRUE)) [ { "driver" : "Bowser", "occupation" :
#> 379         "Koopa", "vehicle" : { "model" : "Piranha Prowler", "stats" : { "speed" : 55, "weight" : 67,
#> 380                "drift" : 35 } } }, { "driver" : "Peach", "occupation" : "Princess", "vehicle" : { 17
#> 381     "model" : "Royal Racer", "stats" : { "speed" : 34, "weight" : 24, "drift" : 32 } } } ] myjson <-
#> 382       toJSON(x) y <- fromJSON(myjson) identical(x,y) [1] TRUE When encountering JSON data containing
#> 383      nested records on the web, chances are that these data were generated from relational database.
#> 384   The JSON field containing a subrecord represents a foreign key pointing to a record in an external
#> 385   table. For the purpose of encoding these into a single JSON structure, the tables were joined into
#> 386    a nested structure. The directly nested subrecord represents a one-to-one or many-to-one relation
#> 387     between the parent and child table, and is most naturally stored in R using a nested data frame.
#> 388      In the example above, the vehicle field points to a table of vehicles, which in turn contains a
#> 389  stats field pointing to a table of stats. When there is no more than one subrecord for each record,
#> 390        we easily flatten the structure into a single non-nested data frame. z <- cbind(x[c("driver",
#> 391   "occupation")], x$vehicle["model"], x$vehicle$stats) str(z) 'data.frame': 2 obs. of 6 variables: $
#> 392   driver : chr "Bowser" "Peach" $ occupation: chr "Koopa" "Princess" $ model : chr "Piranha Prowler"
#> 393    "Royal Racer" $ speed : num 55 34 $ weight : num 67 24 $ drift : num 35 32 2.4.5 Relational data:
#> 394 nested tables The one-to-one relation discussed above is relatively easy to store in R, because each
#> 395   record contains at most one subrecord. Therefore we can use either a nested data frame, or flatten
#> 396   the data frame. However, things get more difficult when JSON records contain a field with a nested
#> 397     array. Such a structure appears in relational data in case of a one-to-many relation. A standard
#> 398   textbook illustration is the relation between authors and titles. For example, a field can contain
#> 399                                                                               an array of values: 18
#> 400      x <- data.frame(author = c("Homer", "Virgil", "Jeroen")) x$poems <- list(c("Iliad", "Odyssey"),
#> 401          c("Eclogues", "Georgics", "Aeneid"), vector()); names(x) [1] "author" "poems" cat(toJSON(x,
#> 402   pretty = TRUE)) [ { "author" : "Homer", "poems" : [ "Iliad", "Odyssey" ] }, { "author" : "Virgil",
#> 403         "poems" : [ "Eclogues", "Georgics", "Aeneid" ] }, { "author" : "Jeroen", "poems" : [] } ] As
#> 404     can be seen from the example, the way to store this in a data frame is using a list of character
#> 405  vectors. This works, and although unconventional, we can still create and read such structures in R
#> 406   relatively easily. However, in practice the one-to-many relation is often more complex. It results
#> 407    in fields containing a set of records. In R, the only way to model this is as a column containing
#> 408     a list of data frames, one separate data frame for each row: x <- data.frame(author = c("Homer",
#> 409  "Virgil", "Jeroen")) x$poems <- list( data.frame(title=c("Iliad", "Odyssey"), year=c(-1194, -800)),
#> 410         data.frame(title=c("Eclogues", "Georgics", "Aeneid"), year=c(-44, -29, -19)), data.frame() )
#> 411                                                                   cat(toJSON(x, pretty=TRUE)) [ { 19
#> 412        "author" : "Homer", "poems" : [ { "title" : "Iliad", "year" : -1194 }, { "title" : "Odyssey",
#> 413      "year" : -800 } ] }, { "author" : "Virgil", "poems" : [ { "title" : "Eclogues", "year" : -44 },
#> 414       { "title" : "Georgics", "year" : -29 }, { "title" : "Aeneid", "year" : -19 } ] }, { "author" :
#> 415    "Jeroen", "poems" : [] } ] Because R doesn’t have native support for relational data, there is no
#> 416     natural class to store such structures. The best we can do is a column containing a list of sub-
#> 417   dataframes. This does the job, and allows the R user to access or generate nested JSON structures.
#> 418      However, a data frame like this cannot be flattened, and the class does not guarantee that each
#> 419      of the individual nested data frames contain the same fields, as would be the case in an actual
#> 420                                                                             relational data base. 20
#> 421         3 Structural consistency and type safety in dynamic data Systems that automatically exchange
#> 422        information over some interface, protocol or API require well defined and unambiguous meaning
#> 423      and arrangement of data. In order to process and interpret input and output, contents must obey
#> 424    a steady structure. Such structures are usually described either informally in documenta- tion or
#> 425    more formally in a schema language. The previous section emphasized the importance of consistency
#> 426  in the mapping between JSON data and R classes. This section takes a higher level view and explains
#> 427     the importance of structure consistency for dynamic data. This topic can be a bit subtle because
#> 428    it refers to consistency among different instantiations of a JSON structure, rather than a single
#> 429        case. We try to clarify by breaking down the concept into two important parts, and illustrate
#> 430   with analogies and examples from R. 3.1 Classes, types and data Most object-oriented languages are
#> 431    designed with the idea that all objects of a certain class implement the same fields and methods.
#> 432 In strong-typed languages such as S4 or Java, names and types of the fields are formally declared in
#> 433  a class definition. In other languages such as S3 or JavaScript, the fields are not enforced by the
#> 434  language but rather at the discretion of the programmer. However one way or another they all assume
#> 435      that members of a certain class agree on field names and types, so that the same methods can be
#> 436 applied to any object of a particular class. This basic principle holds for dynamic data exactly the
#> 437    same way as for objects. Software that process dynamic data can only work reliably if the various
#> 438 elements of the data have consistent names and structure. Consensus must exist between the different
#> 439   parties on data that is exchanged as part an interface or protocol. This requires the structure to
#> 440  follow some sort of template that specifies which attributes can appear in the data, what they mean
#> 441    and how they are composed. Thereby each possible scenario can be accounted for in the software so
#> 442     that data gets interpreted/processed appropriately and no exceptions arise during run-time. Some
#> 443      data interchange formats such as XML or Protocol Buffers take a formal approach to this matter,
#> 444    and have well established schema languages and interface description languages. Using such a meta
#> 445    language it is possible to define the exact structure, properties and actions of data interchange
#> 446   in a formal arrange- ment. However, in JSON, such formal definitions are relatively uncommon. Some
#> 447     initiatives for JSON schema languages exist (Galiegue and Zyp, 2013), but they are not very well
#> 448 established and rarely seen in practice. One reason for this might be that defining and implementing
#> 449    formal schemas is complicated and a lot of work which defeats the purpose of using an lightweight
#> 450  format such as JSON in the first place. But another reason is that it is often simply not necessary
#> 451  to be overly formal. The JSON format is simple and intuitive, and under some general conventions, a
#> 452  well chosen example can suffice to characterize the structure. This section describes two important
#> 453      rules that are required to ensure that data exchange using JSON is type safe. 3.2 Rule 1: Fixed
#> 454  keys When using JSON without a schema, there are no restrictions on the keys (field names) that can
#> 455    appear in a particular object. However, an API that returns a different set of keys every time it
#> 456  is called makes it very difficult to write software to process these data. Hence, the first rule is
#> 457   to limit JSON interfaces to a finite set of keys that are known a priory by all parties. It can be
#> 458                                                   helpful to think about this in analogy with for 21
#> 459     example a relational database. Here, the database model separates the data from metadata. At run
#> 460  time, records can be inserted or deleted, and a certain query might return different data each time
#> 461      it is executed. But for a given query, each execution will return exactly the same field names;
#> 462 hence as long as the table definitions are unchanged, the structure of the output consistent. Client
#> 463      software needs this structure to validate input, optimize implementation, and process each part
#> 464   of the data appropriately. In JSON, data and metadata are not formally separated as in a database,
#> 465       but similar principles that hold for fields in a database, apply to keys in dynamic JSON data.
#> 466     A beautiful example of this in practice was given by Mike Dewar at the New York Open Statistical
#> 467      Program- ming Meetup on Jan. 12, 2012 (Dewar, 2012). In his talk he emphasizes to use JSON keys
#> 468     only for names, and not for data. He refers to this principle as the “golden rule”, and explains
#> 469        how he learned his lesson the hard way. In one of his early applications, timeseries data was
#> 470     encoded by using the epoch timestamp as the JSON key. Therefore the keys are different each time
#> 471   the query is executed: [ { "1325344443" : 124 }, { "1325344456" : 131 }, { "1325344478" : 137 }, ]
#> 472  Even though being valid JSON, dynamic keys as in the example above are likely to introduce trouble.
#> 473   Most software will have great difficulty processing these values if we can not specify the keys in
#> 474  the code. Moreover when documenting the API, either informally or formally using a schema language,
#> 475   we need to describe for each property in the data what the value means and is composed of. Thereby
#> 476      a client or consumer can implement code that interprets and process each element in the data in
#> 477     an appropriate manner. Both the documentation and interpretation of JSON data rely on fixed keys
#> 478     with well defined meaning. Also note that the structure is difficult to extend in the future. If
#> 479     we want to add an additional property to each observation, the entire structure needs to change.
#> 480     In his talk, Dewar explains that life gets much easier when we switch to the following encoding:
#> 481        [ { "time": "1325344443" : "price": 124 }, { "time": "1325344456" : "price": 131 }, { "time":
#> 482      "1325344478" : "price": 137 } ] This structure will play much nicer with existing software that
#> 483    assumes fixed keys. Moreover, the structure can easily be described in documentation, or captured
#> 484       in a schema. Even when we have no intention of writing documentation or a schema for a dynamic
#> 485   JSON source, it is still wise to design the structure in such away that it could be described by a
#> 486  schema. When the keys are fixed, a well chosen example can provide all the information required for
#> 487    the consumer to implement client code. Also note that the new structure is extensible: additional
#> 488  properties can be added to each observation without breaking backward compatibility. In the context
#> 489    of R, consistency of keys is closely related to Wikcham’s concept of tidy data discussed earlier.
#> 490       Wickham states that the most common reason for messy data are column headers containing values
#> 491    instead of variable names. Column headers in tabular datasets become keys when converted to JSON.
#> 492                                                                                        Therefore, 22
#> 493       when headers are actually values, JSON keys contain in fact data and can become unpredictable.
#> 494   The cure to inconsistent keys is almost always to tidy the data according to recommendations given
#> 495     by Wickham (2014). 3.3 Rule 2: Consistent types In a strong typed language, fields declare their
#> 496  class before any values are assigned. Thereby the type of a given field is identical in all objects
#> 497       of a particular class, and arrays only contain objects of a single type. The S3 system in R is
#> 498   weakly typed and puts no formal restrictions on the class of a certain properties, or the types of
#> 499     objects that can be combined into a collection. For example, the list below contains a character
#> 500   vector, a numeric vector and a list: # Heterogeneous lists are bad! x <- list("FOO", 1:3, list(bar
#> 501     = pi)) cat(toJSON(x)) [ [ "FOO" ], [ 1, 2, 3 ], { "bar" : [ 3.14 ] } ] However even though it is
#> 502      possible to generate such JSON, it is bad practice. Fields or collections with ambiguous object
#> 503         types are difficult to describe, interpret and process in the context of inter-system commu-
#> 504  nication. When using JSON to exchange dynamic data, it is important that each property and array is
#> 505   type consistent. In dynamically typed languages, the programmer needs to make sure that properties
#> 506      are of the correct type before encoding into JSON. It also means that unnamed lists in R should
#> 507   generally be avoided when designing interoperable structures because this type is not homogeneous.
#> 508    Note that consistency is somewhat subjective as it refers to the meaning of the elements; they do
#> 509     not necessarily have precisely the same structure. What is important is to keep in mind that the
#> 510       consumer of the data can interpret and process each element identically, e.g. iterate over the
#> 511       elements in the collection and apply the same method to each of them. To illustrate this, lets
#> 512  take the example of the data frame: # conceptually homogenous array x <- data.frame(name = c("Jay",
#> 513     "Mary", NA, NA), gender = c("M", NA, NA, "F")) cat(toJSON(x, pretty = TRUE)) [ { "name" : "Jay",
#> 514                                   "gender" : "M" }, { "name" : "Mary" }, {}, { "gender" : "F" } ] 23
#> 515     The JSON array above has 4 elements, each of which a JSON object. However, due to the NA values,
#> 516 not all elements have an identical structure: some records have more fields than others. But as long
#> 517   as they are conceptually the same type (e.g. a person), the consumer can iterate over the elements
#> 518   to process each person in the set according to a predefined action. For example each element could
#> 519   be used to construct a Person object. A collection of different object classes should be separated
#> 520    and organized using a named list: x <- list( humans = data.frame(name = c("Jay", "Mary"), married
#> 521         = c(TRUE, FALSE)), horses = data.frame(name = c("Star", "Dakota"), price = c(5000, 30000)) )
#> 522          cat(toJSON(x, pretty=TRUE)) { "humans" : [ { "name" : "Jay", "married" : true }, { "name" :
#> 523          "Mary", "married" : false } ], "horses" : [ { "name" : "Star", "price" : 5000 }, { "name" :
#> 524    "Dakota", "price" : 30000 } ] } This might seem obvious, but dynamic languages such as R can make
#> 525   it dangerously tempting to create data containing mixed-type properties or collections. We already
#> 526  mentioned the example of other JSON packages which encode an atomic vector either as JSON primitive
#> 527    or JSON array, depending on its length. Such inconsistent typing is very difficult for clients to
#> 528   predict and a likely source of nasty bugs. Using consistent field names/types and homogeneous JSON
#> 529      arrays is a strong convention among public JSON APIs, for good reasons. We recommend R users to
#> 530                                         respect these conventions when generating JSON data in R. 24
#> 531      Appendices A Public JSON APIs This section lists some examples of public HTTP APIs that publish
#> 532   data in JSON format. These are great to get a sense of the complex structures that are encountered
#> 533        in real world JSON data. All services are free, but some require registration/authentication.
#> 534      Each example returns lots of data, therefore output is ommitted in this document. The reader is
#> 535  encouraged to run the examples in R and inspect the output manually. A.1 No authentication required
#> 536     The following APIs allow for (limited) use without any form of registration: Github Github is an
#> 537     online code repository and has APIs to get live data on almost all activity. Below some examples
#> 538       from a well known R package and author: hadley_orgs <- fromJSON("https://api.github.com/users/
#> 539     hadley/orgs") hadley_repos <- fromJSON("https://api.github.com/users/hadley/repos") gg_issues <-
#> 540      fromJSON("https://api.github.com/repos/hadley/ggplot2/issues") gg_commits <- fromJSON("https://
#> 541  api.github.com/repos/hadley/ggplot2/commits") CitiBike NYC A single public API that shows location,
#> 542        status and current availability for all stations in the New York City bike sharing initative.
#> 543    citibike <- fromJSON("http://citibikenyc.com/stations/json") AngelList AngelList is a job listing
#> 544    directory for startups: res <- fromJSON("http://api.angel.co/1/tags/59/startups") res$startups 25
#> 545    Ergast The Ergast Developer API is an experimental web service which provides a historical record
#> 546          of motor racing data for non-commercial purposes. races <- fromJSON("http://ergast.com/api/
#> 547      f1/2012/1/results.json") races$RaceTable$Races$MRData$Results[[1]]$Driver A.2 Free registration
#> 548   required The following APIs require (free) registration of a key/token. In each case, registration
#> 549    is easy and a key will be emailed. This key has to be appended to the requests to query the APIs.
#> 550     The code below includes some example keys for illustration purposes. New York Times The New York
#> 551      Times has several free APIs that are part of the NYT developer network. These interface to data
#> 552     from various departments, such as news articles, book reviews, real estate, etc. # Register keys
#> 553       at http://developer.nytimes.com/docs/reference/keys # search for articles article_key = "&api-
#> 554           key=c2fede7bd9aea57c898f538e5ec0a1ee:6:68700045" url = "http://api.nytimes.com/svc/search/
#> 555        v2/articlesearch.json?q=obamacare+socialism" articles <- fromJSON(paste0(url, article_key)) #
#> 556      search for best sellers bestseller_key = "&api-key=5e260a86a6301f55546c83a47d139b0d:3:68700045"
#> 557            url = "http://api.nytimes.com/svc/books/v2/lists/overview.json?published_date=2013-01-01"
#> 558              bestsellers <- fromJSON(paste0(url, bestseller_key)) # movie reviews movie_key = "&api-
#> 559        key=5a3daaeee6bbc6b9df16284bc575e5ba:0:68700045" url = "http://api.nytimes.com/svc/movies/v2/
#> 560         reviews/dvd-picks.json?order=by-date" reviews <- fromJSON(paste0(url, movie_key)) CrunchBase
#> 561 CrunchBase is the free database of technology companies, people, and investors that anyone can edit.
#> 562   key <- "f6dv6cas5vw7arn5b9d7mdm3" res <- fromJSON(paste0("http://api.crunchbase.com/v/1/search.js?
#> 563                                                         query=R&api_key=", key)) str(res$results) 26
#> 564            Sunlight Foundation The Sunlight Foundation is a non-profit that helps to make government
#> 565     transparent and accountable through data, tools, policy and journalism. #register key at http://
#> 566      sunlightfoundation.com/api/accounts/register/ key <- "&apikey=39c83d5a4acc42be993ee637e2e4ba3d"
#> 567         #some queries drones <- fromJSON(paste0("http://openstates.org/api/v1/bills/?q=drone", key))
#> 568           word <- fromJSON(paste0("http://capitolwords.org/api/1/dates.json?phrase=obamacare", key))
#> 569   legislators <- fromJSON(paste0("http://congress.api.sunlightfoundation.com/", "legislators/locate?
#> 570  latitude=42.96&longitude=-108.09", key)) A.3 OAuth2 authentication Twitter The twitter API requires
#> 571     a more elaborate authentication process based on the OAuth2 protocol. Some example code: #Create
#> 572     your own appication key at https://dev.twitter.com/apps consumer_key = "EZRy5JzOH2QQmVAe9B4j2w";
#> 573  consumer_secret = "OIDC4MdfZJ82nbwpZfoUO4WOLTYjoRhpHRAWj6JMec"; #basic auth library(httr) secret <-
#> 574  RCurl::base64(paste(consumer_key, consumer_secret, sep=":")); req <- POST("https://api.twitter.com/
#> 575       oauth2/token", config(httpheader = c( "Authorization" = paste("Basic", secret), "Content-Type"
#> 576      = "application/x-www-form-urlencoded;charset=UTF-8" )), body = "grant_type=client_credentials",
#> 577                multipart = FALSE ); res <- fromJSON(rawToChar(req$content)) token <- paste("Bearer",
#> 578  res$access_token); #Actual API call url = "https://api.twitter.com/1.1/statuses/user_timeline.json?
#> 579   count=10&screen_name=UCLA" call1 <- GET(url, config(httpheader = c("Authorization" = token))) obj1
#> 580                                                             <- fromJSON(rawToChar(call1$content)) 27
#> 581  B Simple JSON RPC with OpenCPU The jsonlite package is used by OpenCPU to convert between JSON data
#> 582  and R ojects. Thereby clients can retrieve R objects, or remotely call R functions using JSON where
#> 583    the function arguments as well as function return value are JSON objects. For example to download
#> 584  the Boston data from the MASS package: Command in R Example URL on OpenCPU toJSON(Boston, digits=4)
#> 585         https://cran.ocpu.io/MASS/data/Boston/json?digits=4 toJSON(Boston, dataframe="col") https://
#> 586  cran.ocpu.io/MASS/data/Boston/json?dataframe=col toJSON(Boston, pretty=FALSE) https://cran.ocpu.io/
#> 587  MASS/data/Boston/json?pretty=false To calculate the variance of some the numbers 1:9 in the command
#> 588      line using using curl: curl https://demo.ocpu.io/stats/R/var/json -d 'x=[1,2,3,4,5,6,7,8,9]' Or
#> 589       equivalently post the entire body in JSON format: curl https://demo.ocpu.io/stats/R/var/json -
#> 590  H "Content-Type: application/json" \\ -d '{"x":[1,2,3,4,5,6,7,8,9]}' Below an example where we call
#> 591   the melt function from the reshape2 package using some example rows from the airquality data. Here
#> 592     both input and output consist of a data frame. curl https://cran.ocpu.io/reshape2/R/melt/json -d
#> 593 'id=["Month", "Day"]&data=[ { "Ozone" : 41, "Solar.R" : 190, "Wind" : 7.4, "Temp" : 67, "Month" : 5,
#> 594   "Day" : 1 }, { "Ozone" : 36, "Solar.R" : 118, "Wind" : 8, "Temp" : 72, "Month" : 5, "Day" : 2 } ]'
#> 595  Or equivalently: curl https://cran.ocpu.io/reshape2/R/melt/json -H "Content-Type: application/json"
#> 596  \\ -d '{"id" : ["Month", "Day"], "data" : [ { "Ozone" : 41, "Solar.R" : 190, "Wind" : 7.4, "Temp" :
#> 597 67, "Month" : 5, "Day" : 1 }, { "Ozone" : 36, "Solar.R" : 118, "Wind" : 8, "Temp" : 72, "Month" : 5,
#> 598 "Day" : 2 } ] }' This request basically executes the following R code: mydata <- airquality[1:2, ] y
#> 599                           <- reshape2::melt(data = mydata, id = c("Month", "Day")) cat(toJSON(y)) 28
#> 600      References Edward Anderson, Zhaojun Bai, Christian Bischof, Susan Blackford, James Demmel, Jack
#> 601   Dongarra, Jeremy Du Croz, Anne Greenbaum, S Hammerling, Alan McKenney, et al. LAPACK Users’ guide,
#> 602  volume 9. Siam, 1999. Kristina Chodorow. MongoDB: the definitive guide. O’Reilly Media, Inc., 2013.
#> 603   Alex Couture-Beil. rjson: JSON for R, 2013. URL http://CRAN.R-project.org/package=rjson. R package
#> 604    version 0.2.13. Douglas Crockford. The application/json media type for javascript object notation
#> 605         (json), 2006a. URL http://tools.ietf.org/html/rfc4627. Douglas Crockford. JSON: The fat-free
#> 606  alternative to XML. In Proc. of XML, volume 2006, 2006b. URL http://www.json.org/fatfree.html. Mike
#> 607   Dewar. First steps in data visualisation using d3.js, 2012. URL http://vimeo.com/35005701#t=7m17s.
#> 608        New York Open Statistical Programming Meetup on Jan. 12, 2012. ECMA. 262: ECMAScript Language
#> 609         Specification. European Association for Standardizing Information and Communication Systems,
#> 610       1999. URL http://www.ecma-international.org/publications/files/ ECMA-ST/Ecma-262.pdf. Sadayuki
#> 611        Furuhashi. MessagePack: It’s like JSON. but fast and small, 2014. URL http://msgpack.org/. F.
#> 612         Galiegue and K. Zyp. JSON Schema: core definitions and terminology. draft-zyp-json-schema-04
#> 613    (work in progress), 2013. URL https://tools.ietf.org/html/draft-zyp-json-schema-04. Duncan Temple
#> 614     Lang. RJSONIO: Serialize R objects to JSON, JavaScript Object Notation, 2013. URL http://CRAN.R-
#> 615     project.org/package=RJSONIO. R package version 1.0-3. Chuck L Lawson, Richard J. Hanson, David R
#> 616     Kincaid, and Fred T. Krogh. Basic linear algebra subprograms for fortran usage. ACM Transactions
#> 617       on Mathematical Software (TOMS), 5(3):308–323, 1979. Deborah Nolan and Duncan Temple Lang. XML
#> 618         and Web Technologies for Data Sciences with R. Springer, 2014. URL http://link.springer.com/
#> 619     book/10.1007/978-1-4614-7900-0. Jeroen Ooms, Duncan Temple Lang, and Jonathan Wallace. jsonlite:
#> 620      A smarter JSON encoder/decoder for R, 2014. URL http://github.com/jeroenooms/jsonlite#readme. R
#> 621       package version 0.9.4. R Core Team. R: A Language and Environment for Statistical Computing. R
#> 622   Foundation for Statistical Computing, Vienna, Austria, 2013. URL http://www.R-project.org/. Hadley
#> 623           Wickham. Tidy Data. Under review, 2014. URL http://vita.had.co.nz/papers/tidy-data.pdf. 29
#>     page
#> 1      1
#> 2      1
#> 3      1
#> 4      1
#> 5      1
#> 6      1
#> 7      1
#> 8      1
#> 9      1
#> 10     1
#> 11     1
#> 12     1
#> 13     1
#> 14     1
#> 15     1
#> 16     1
#> 17     1
#> 18     1
#> 19     1
#> 20     1
#> 21     1
#> 22     1
#> 23     1
#> 24     1
#> 25     1
#> 26     1
#> 27     1
#> 28     1
#> 29     1
#> 30     2
#> 31     2
#> 32     2
#> 33     2
#> 34     2
#> 35     2
#> 36     2
#> 37     2
#> 38     2
#> 39     2
#> 40     2
#> 41     2
#> 42     2
#> 43     2
#> 44     2
#> 45     2
#> 46     2
#> 47     2
#> 48     2
#> 49     2
#> 50     2
#> 51     2
#> 52     2
#> 53     2
#> 54     2
#> 55     2
#> 56     2
#> 57     2
#> 58     2
#> 59     2
#> 60     2
#> 61     2
#> 62     2
#> 63     3
#> 64     3
#> 65     3
#> 66     3
#> 67     3
#> 68     3
#> 69     3
#> 70     3
#> 71     3
#> 72     3
#> 73     3
#> 74     3
#> 75     3
#> 76     3
#> 77     3
#> 78     3
#> 79     3
#> 80     3
#> 81     3
#> 82     3
#> 83     3
#> 84     3
#> 85     3
#> 86     3
#> 87     3
#> 88     3
#> 89     3
#> 90     3
#> 91     3
#> 92     3
#> 93     3
#> 94     3
#> 95     3
#> 96     3
#> 97     3
#> 98     3
#> 99     4
#> 100    4
#> 101    4
#> 102    4
#> 103    4
#> 104    4
#> 105    4
#> 106    4
#> 107    4
#> 108    4
#> 109    4
#> 110    4
#> 111    4
#> 112    4
#> 113    4
#> 114    4
#> 115    4
#> 116    4
#> 117    4
#> 118    4
#> 119    4
#> 120    4
#> 121    4
#> 122    4
#> 123    4
#> 124    4
#> 125    4
#> 126    4
#> 127    4
#> 128    4
#> 129    4
#> 130    4
#> 131    4
#> 132    4
#> 133    4
#> 134    4
#> 135    4
#> 136    4
#> 137    4
#> 138    4
#> 139    4
#> 140    4
#> 141    5
#> 142    5
#> 143    5
#> 144    5
#> 145    5
#> 146    5
#> 147    5
#> 148    5
#> 149    5
#> 150    5
#> 151    5
#> 152    5
#> 153    5
#> 154    5
#> 155    5
#> 156    5
#> 157    5
#> 158    5
#> 159    5
#> 160    5
#> 161    5
#> 162    5
#> 163    5
#> 164    6
#> 165    6
#> 166    6
#> 167    6
#> 168    6
#> 169    6
#> 170    6
#> 171    6
#> 172    6
#> 173    6
#> 174    6
#> 175    6
#> 176    6
#> 177    6
#> 178    6
#> 179    6
#> 180    6
#> 181    6
#> 182    6
#> 183    6
#> 184    6
#> 185    6
#> 186    7
#> 187    7
#> 188    7
#> 189    7
#> 190    7
#> 191    7
#> 192    7
#> 193    7
#> 194    7
#> 195    7
#> 196    7
#> 197    7
#> 198    7
#> 199    7
#> 200    7
#> 201    7
#> 202    7
#> 203    7
#> 204    8
#> 205    8
#> 206    8
#> 207    8
#> 208    8
#> 209    8
#> 210    8
#> 211    8
#> 212    8
#> 213    8
#> 214    8
#> 215    8
#> 216    8
#> 217    8
#> 218    8
#> 219    8
#> 220    8
#> 221    8
#> 222    8
#> 223    8
#> 224    8
#> 225    8
#> 226    9
#> 227    9
#> 228    9
#> 229    9
#> 230    9
#> 231    9
#> 232    9
#> 233    9
#> 234    9
#> 235    9
#> 236    9
#> 237    9
#> 238    9
#> 239    9
#> 240    9
#> 241    9
#> 242    9
#> 243    9
#> 244    9
#> 245    9
#> 246    9
#> 247    9
#> 248    9
#> 249    9
#> 250    9
#> 251    9
#> 252    9
#> 253   10
#> 254   10
#> 255   10
#> 256   10
#> 257   10
#> 258   10
#> 259   10
#> 260   10
#> 261   10
#> 262   11
#> 263   11
#> 264   11
#> 265   11
#> 266   11
#> 267   11
#> 268   11
#> 269   11
#> 270   11
#> 271   11
#> 272   11
#> 273   11
#> 274   11
#> 275   12
#> 276   12
#> 277   12
#> 278   12
#> 279   12
#> 280   12
#> 281   12
#> 282   12
#> 283   12
#> 284   12
#> 285   12
#> 286   12
#> 287   12
#> 288   12
#> 289   12
#> 290   12
#> 291   13
#> 292   13
#> 293   13
#> 294   13
#> 295   13
#> 296   13
#> 297   13
#> 298   13
#> 299   13
#> 300   13
#> 301   13
#> 302   13
#> 303   13
#> 304   14
#> 305   14
#> 306   14
#> 307   14
#> 308   14
#> 309   14
#> 310   14
#> 311   14
#> 312   14
#> 313   14
#> 314   14
#> 315   14
#> 316   14
#> 317   14
#> 318   14
#> 319   14
#> 320   14
#> 321   14
#> 322   14
#> 323   14
#> 324   14
#> 325   14
#> 326   14
#> 327   14
#> 328   14
#> 329   14
#> 330   14
#> 331   14
#> 332   14
#> 333   14
#> 334   15
#> 335   15
#> 336   15
#> 337   15
#> 338   15
#> 339   15
#> 340   15
#> 341   15
#> 342   15
#> 343   15
#> 344   15
#> 345   15
#> 346   15
#> 347   15
#> 348   15
#> 349   15
#> 350   16
#> 351   16
#> 352   16
#> 353   16
#> 354   16
#> 355   16
#> 356   16
#> 357   16
#> 358   16
#> 359   16
#> 360   16
#> 361   16
#> 362   16
#> 363   16
#> 364   17
#> 365   17
#> 366   17
#> 367   17
#> 368   17
#> 369   17
#> 370   17
#> 371   17
#> 372   17
#> 373   17
#> 374   17
#> 375   17
#> 376   17
#> 377   17
#> 378   17
#> 379   17
#> 380   17
#> 381   18
#> 382   18
#> 383   18
#> 384   18
#> 385   18
#> 386   18
#> 387   18
#> 388   18
#> 389   18
#> 390   18
#> 391   18
#> 392   18
#> 393   18
#> 394   18
#> 395   18
#> 396   18
#> 397   18
#> 398   18
#> 399   18
#> 400   19
#> 401   19
#> 402   19
#> 403   19
#> 404   19
#> 405   19
#> 406   19
#> 407   19
#> 408   19
#> 409   19
#> 410   19
#> 411   19
#> 412   20
#> 413   20
#> 414   20
#> 415   20
#> 416   20
#> 417   20
#> 418   20
#> 419   20
#> 420   20
#> 421   21
#> 422   21
#> 423   21
#> 424   21
#> 425   21
#> 426   21
#> 427   21
#> 428   21
#> 429   21
#> 430   21
#> 431   21
#> 432   21
#> 433   21
#> 434   21
#> 435   21
#> 436   21
#> 437   21
#> 438   21
#> 439   21
#> 440   21
#> 441   21
#> 442   21
#> 443   21
#> 444   21
#> 445   21
#> 446   21
#> 447   21
#> 448   21
#> 449   21
#> 450   21
#> 451   21
#> 452   21
#> 453   21
#> 454   21
#> 455   21
#> 456   21
#> 457   21
#> 458   21
#> 459   22
#> 460   22
#> 461   22
#> 462   22
#> 463   22
#> 464   22
#> 465   22
#> 466   22
#> 467   22
#> 468   22
#> 469   22
#> 470   22
#> 471   22
#> 472   22
#> 473   22
#> 474   22
#> 475   22
#> 476   22
#> 477   22
#> 478   22
#> 479   22
#> 480   22
#> 481   22
#> 482   22
#> 483   22
#> 484   22
#> 485   22
#> 486   22
#> 487   22
#> 488   22
#> 489   22
#> 490   22
#> 491   22
#> 492   22
#> 493   23
#> 494   23
#> 495   23
#> 496   23
#> 497   23
#> 498   23
#> 499   23
#> 500   23
#> 501   23
#> 502   23
#> 503   23
#> 504   23
#> 505   23
#> 506   23
#> 507   23
#> 508   23
#> 509   23
#> 510   23
#> 511   23
#> 512   23
#> 513   23
#> 514   23
#> 515   24
#> 516   24
#> 517   24
#> 518   24
#> 519   24
#> 520   24
#> 521   24
#> 522   24
#> 523   24
#> 524   24
#> 525   24
#> 526   24
#> 527   24
#> 528   24
#> 529   24
#> 530   24
#> 531   25
#> 532   25
#> 533   25
#> 534   25
#> 535   25
#> 536   25
#> 537   25
#> 538   25
#> 539   25
#> 540   25
#> 541   25
#> 542   25
#> 543   25
#> 544   25
#> 545   26
#> 546   26
#> 547   26
#> 548   26
#> 549   26
#> 550   26
#> 551   26
#> 552   26
#> 553   26
#> 554   26
#> 555   26
#> 556   26
#> 557   26
#> 558   26
#> 559   26
#> 560   26
#> 561   26
#> 562   26
#> 563   26
#> 564   27
#> 565   27
#> 566   27
#> 567   27
#> 568   27
#> 569   27
#> 570   27
#> 571   27
#> 572   27
#> 573   27
#> 574   27
#> 575   27
#> 576   27
#> 577   27
#> 578   27
#> 579   27
#> 580   27
#> 581   28
#> 582   28
#> 583   28
#> 584   28
#> 585   28
#> 586   28
#> 587   28
#> 588   28
#> 589   28
#> 590   28
#> 591   28
#> 592   28
#> 593   28
#> 594   28
#> 595   28
#> 596   28
#> 597   28
#> 598   28
#> 599   28
#> 600   29
#> 601   29
#> 602   29
#> 603   29
#> 604   29
#> 605   29
#> 606   29
#> 607   29
#> 608   29
#> 609   29
#> 610   29
#> 611   29
#> 612   29
#> 613   29
#> 614   29
#> 615   29
#> 616   29
#> 617   29
#> 618   29
#> 619   29
#> 620   29
#> 621   29
#> 622   29
#> 623   29
```

### Office documents  


### Images
