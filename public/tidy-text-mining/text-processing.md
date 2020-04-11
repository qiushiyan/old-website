

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
```


```r
download.file("http://arxiv.org/pdf/1403.2805.pdf", "data/1403.2805.pdf", mode = "wb")
```



```r
txt <- pdf_text("data/1403.2805.pdf")

# all 29 pages  
length(txt) 
#> [1] 29

cat(txt[[1]])
#>                                               The jsonlite Package: A Practical and Consistent Mapping
#>                                                                    Between JSON Data and R Objects
#>                                                                                     Jeroen Ooms
#> arXiv:1403.2805v1 [stat.CO] 12 Mar 2014
#>                                                                               UCLA Department of Statistics
#>                                                                                              Abstract
#>                                                   A naive realization of JSON data in R maps JSON arrays to an unnamed list, and JSON objects to a
#>                                                named list. However, in practice a list is an awkward, inefficient type to store and manipulate data.
#>                                                Most statistical applications work with (homogeneous) vectors, matrices or data frames. Therefore JSON
#>                                                packages in R typically define certain special cases of JSON structures which map to simpler R types.
#>                                                Currently there exist no formal guidelines, or even consensus between implementations on how R data
#>                                                should be represented in JSON. Furthermore, upon closer inspection, even the most basic data structures
#>                                                in R actually do not perfectly map to their JSON counterparts and leave some ambiguity for edge cases.
#>                                                These problems have resulted in different behavior between implementations and can lead to unexpected
#>                                                output. This paper explicitly describes a mapping between R classes and JSON data, highlights potential
#>                                                problems, and proposes conventions that generalize the mapping to cover all common structures. We
#>                                                emphasize the importance of type consistency when using JSON to exchange dynamic data, and illustrate
#>                                                using examples and anecdotes. The jsonlite R package is used throughout the paper as a reference
#>                                                implementation.
#>                                           1    Introduction
#>                                           JavaScript Object Notation (JSON) is a text format for the serialization of structured data (Crockford, 2006a).
#>                                           It is derived from the object literals of JavaScript, as defined in the ECMAScript Programming Language
#>                                           Standard, Third Edition (ECMA, 1999). Design of JSON is simple and concise in comparison with other
#>                                           text based formats, and it was originally proposed by Douglas Crockford as a “fat-free alternative to XML”
#>                                           (Crockford, 2006b). The syntax is easy for humans to read and write, easy for machines to parse and generate
#>                                           and completely described in a single page at http://www.json.org. The character encoding of JSON text
#>                                           is always Unicode, using UTF-8 by default (Crockford, 2006a), making it naturally compatible with non-
#>                                           latin alphabets. Over the past years, JSON has become hugely popular on the internet as a general purpose
#>                                           data interchange format. High quality parsing libraries are available for almost any programming language,
#>                                           making it easy to implement systems and applications that exchange data over the network using JSON. For
#>                                           R (R Core Team, 2013), several packages that assist the user in generating, parsing and validating JSON
#>                                           are available through CRAN, including rjson (Couture-Beil, 2013), RJSONIO (Lang, 2013), and jsonlite
#>                                           (Ooms et al., 2014).
#>                                           The emphasis of this paper is not on discussing the JSON format or any particular implementation for using
#>                                                                                                  1

enframe(txt) %>% 
  rename(page = name) %>% 
  nest_paragraphs(input = value, width = 100) %>%
  head()
#>                                                                                                   text
#> 1 The jsonlite Package: A Practical and Consistent Mapping Between JSON Data and R Objects Jeroen Ooms
#> 2   arXiv:1403.2805v1 [stat.CO] 12 Mar 2014 UCLA Department of Statistics Abstract A naive realization
#> 3    of JSON data in R maps JSON arrays to an unnamed list, and JSON objects to a named list. However,
#> 4    in practice a list is an awkward, inefficient type to store and manipulate data. Most statistical
#> 5    applications work with (homogeneous) vectors, matrices or data frames. Therefore JSON packages in
#> 6  R typically define certain special cases of JSON structures which map to simpler R types. Currently
#>   page
#> 1    1
#> 2    1
#> 3    1
#> 4    1
#> 5    1
#> 6    1
```

### Office documents  


### Images
