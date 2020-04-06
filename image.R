library(magick)
library(magrittr)




image_read("/featured.jpg") %>% 
  image_resize("1800x1200") %>% 
  image_write("featured.jpg")
