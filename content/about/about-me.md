+++
# A Demo section created with the Blank widget.
# Any elements can be added in the body: https://sourcethemes.com/academic/docs/writing-markdown-latex/
# Add more sections by duplicating this file and customizing to your requirements.

widget = "blank"  # See https://sourcethemes.com/academic/docs/page-builder/
headless = true  # This file represents a page section.
active = true # Activate this widget? true/false
weight = 20  # Order that this section will appear.

title = ""
subtitle = ""

[design]
  # Choose how many columns the section has. Valid values: 1 or 2.
  columns = "1"

[design.background]
  # Apply a background color, gradient, or image.
  #   Uncomment (by removing `#`) an option to apply it.
  #   Choose a light or dark text color by setting `text_color_light`.
  #   Any HTML color name or Hex value is valid.

  # Background color.
  # color = "navy"
  
  # Background gradient.
  # gradient_start = "DeepSkyBlue"
  # gradient_end = "SkyBlue"
  
  # Background image.
  image = ""  # Name of image in `static/img/`.
  image_darken = 0.6  # Darken the image? Range 0-1 where 0 is transparent and 1 is opaque.

  # Text color (true=light or false=dark).
  text_color_light = false

[design.spacing]
  # Customize the section spacing. Order is top, right, bottom, left.
  padding = ["20px", "250px", "20px", "250px"]

[advanced]
 # Custom CSS. 
 css_style = ""
 
 # CSS class.
 css_class = "mini"
+++

This blog is dedicated to learning and sharing my data science journey. Most of the posts are case studies in data analysis and machine learning. Many of my current [projects](../#projects) are reading notes on R books. My resume lives [here](/files/resume-en.pdf). Feel free to [contact](#contact) me.

I have broad interests in all things related to statistics, data science and AI. Particularly, I am drawn the most by natural language processing and its applications in healthcare. I consider clinical notes as the key to dynamic decision support.

After joining 51talk, I have been actively learning education data science, computerized adaptive testing (CAT), and the applications of item-response theory. 

Other than that, I aspire to apply data science techniques to quantitative ecology and natural resource management. Although human in natural systems go out of our way to tip that balance in our favor to the extreme detriment of everything else, within the discipline there are some heroes who have at least been able to clearly identify our impacts and are fighting to protect species, habitats, and, ultimately, the human race.




Below is an autobiographical essay on my data science story. 



___

*TO BE DONE*

I became an R user in late 2018. Thanks to the striking animal cover on O'Reilly book series, a book titled *Graphing with R: An introduction* with a colorful bird on the front caught my attention in the school library. The book was about the basics of R programming and making graphs in `base`. It was the first time I learned to create code-based data visualization. At that time, I did not know the word "data science", nor R's computational power. I was excited to find something I love and enjoyed the self-motivated process of learning. I began to document my progress in an MS Word document, by copying & pasting code and plots and adding my own comments.  

After that, I read more R books such as *R in Action* and *ggplot2: Elegant Graphics for Data Analysis*. I came to understand that R's capability went far beyond plotting. So I made my next step to study statistical inference and modeling. Online learning platforms and professors who generously made public their class videos were of great help. I benefited a lot from Prof. [Chris Bilder](http://www.chrisbilder.com/)'s courses in *Regression Analysis* and *Categorical Data Analysis*. The lectures stimulated me to make sense of complex systems with statistical models. R, of course, provided a hands-on environment for practices. In addition, Prof. [Guan-Hua Huang](http://ghuang.stat.nctu.edu.tw/)'s class in *Multivariate Statistics* laid foundations for understanding many machine learning models, and expanded my knowledge in Linear Algebra. 

In March 2019, I got my first internship as a data analyst at DiDi, China's Uber. I gained professional experience in AB testing and marketing research. Clustering, Correspondence Analysis, and PCA are used throughout the job. I was also introduced to text mining methods to extract opinions from customer reviews. More importantly, I had the luck to work in a multilingual data team, where my colleagues used a mix of R, C++, and Python. Over the months, I accumulated a smattering knowledge of programming in the other two languages. In my last project at DiDi, I contributed a handful of components written in C++ to our AB testing environment.

The summer was marked by a deep dive into Python. As a general-purpose language,  it provided for me a gentle introduction to data structures and algorithms, compensating my lack of a formal CS training. Python was also a window into many low-level techniques of which R kindly took care. I also joined Prof. Wang Xiaoning's research team in applied statistics. Our research focus has been on genomics, healthcare analytics, and unsupervised methods. 

I went into machine learning the next semester.  The key resources are the book *Introduction to Statistical Learning* by Gareth James et al. and the MOOC videos by Trevor Hastie and Robert Tibshirani. What machine learning interested me the most was that it was all about trade-offs, the trade-off between bias and variance, accuracy and interpretability, and so on. And I found it most rewarding for data scientists to achieve a fine balance. I had also been elevating my R skills by digging into the `tidyverse` ecosystem. Tidyverse had fundamentally changed the way I do data wrangling in R, making discovering a new R concept like a package or function exciting serendipity. 

In the meantime, I made a transition from MS Word to R Markdown and Jupyter. As my note-taking document grew larger, I got tired of manually copying and pasting. After adopting these tools, I came to appreciate the importance of having your work reproducible and auditable. Since then, the R Markdown ecosystem including `bookdown` and `blogdown` packages had played a central in all my data science projects. This website is also built on top of the blogdown package. The rest of 2019 was spent on various research centering around biomedical study and healthcare analytics.

I visited San Francisco for [RStudio Conf](https://rstudio.com/resources/rstudioconf-2020/) in January 2020, meeting R and data science experts worldwide. I enjoyed talks and Birds of a Feather sessions in machine learning, text mining, Shiny, visualization, and medicine. I also participated in the two-day workshop [Introduction to Machine Learning with the Tidyverse](https://github.com/rstudio-conf-2020/intro-to-ml-tidy), where [Alison Hill](https://alison.rbind.io/) introduced supervised machine learning using the [tidymodels](www.tidymodels.org) core packages. It was a memorable occasion to see the endeavor to knowledge sharing and community building of RStudio and top data scientists in the industry. I was motivated to pour in my effort by becoming an active member in online discussion boards, such as Stack Overflow and RStudio Community. 


In February, I volunteered at [Wuhan2020](https://community.wuhan2020.org.cn/en-us), an information service platform to combat COVID-19. I served both as a developer and community coordinator, where I automated the verification process with Github Actions, and engineered ECharts visualization components for tracking hospital bed occupancy. The project also launched an open data initiative. Many data scientists contributed data, code, and software. As infections continued their rapid spread, there was also a worldwide transformation in universities, academic institutes, and companies to embrace the idea of shared data and research transparency. I had a simple investigation into local hospitals and organizations, in which I witnessed a significantly higher proportion of code-based data analysis and reproducible results. These findings deepened my passion in that data science is more than deploying smarter algorithms, but rather a revolution in both industry and academia towards openness, transparency and reproducibility.

I joined [Analysys](http://www.analysyschina.com/about.html) as a business analyst from June to September. The position is a mixture of roles between an engineer and customer success. Challenges are that I had to constantly switch my audience between technicians and managements. The job was helpful in presentation skills and communicating to non-technical customers. 

I have undertaken research projects since 2020. Many of them are COVID-19 related, and draw heavily on text mining methods such as topic modeling. I was also involved in a metazoan genomic analysis using probabilistic graphic models. Apart from that, Prof. [Elisa Celis](https://datascienceethics.wordpress.com/elisacelis/)’s lecture in data science ethics inspired me to contemplate fairness in machine learning. As a result, I proposed a new loan strategy based on group error parity to local banks.   


After leaving Analysys, I have worked as a data analyst at [51talk](https://51talk.ph/) up till now. At China's largest online English education plat, the Big Data team brings together many R wizards dedicated to education data science. Currently, I am leading projects in developing a tutor evaluation system.  




The following experience section describes my educational background and professional experience in data science. 





