

# 其他 {#others}


## 云雨图 {#Raincloud}



云雨图可以看成核密度曲线估计图，箱线图和抖动散点图的组合图表。有三个主要图层：自定义的半小提琴函数 `geom_flat_violin()`、箱线图`geom_boxplot()` 和抖动散点图 `geom_jitter()`。其中定义半小提琴图的函数来自 https://gist.github.com/dgrtwo/eb7750e74997891d7c20  



```r
## 半小提琴图的示例  
source("R/geom_flat_violin.R")
diamonds_sub <- diamonds[sample(nrow(diamonds), 1500), ]
p <- ggplot(diamonds_sub, aes(cut, carat, fill = cut))
p + geom_flat_violin()    
```

<img src="others_files/figure-html/unnamed-chunk-2-1.svg" width="90%" />


相比于 ggplot2 中的 `geom_violin`, 半小提琴图省却了多余的一半核密度估计曲线，这为叠加其他图层增加了方便：  



```r
p + 
  geom_flat_violin(position = position_nudge(x = 0.25)) + 
  geom_boxplot(fill = "white", position = position_nudge(x = 0.25),
               width = 0.1) + 
  geom_jitter(aes(color = cut), width =  0.1,
              size = 0.5)
```

<img src="others_files/figure-html/unnamed-chunk-3-1.svg" width="90%" />

上面就是一副比较基本的云雨图了，几个关键点：  

1. 箱线图一般都会过宽，从而遮挡半小提琴图和散点图的位置，应该减小`geom_boxplot()` 中的 `width`  
2. 半小提琴图应该和箱线图在一条轴线上，且与抖动点分离。这里的操作是将 `geom_flat_vilon()` 和 `geom_boxplot()` 平移了相同距离  
3. 别忘了还要映射抖动点的颜色属性     


## 坡度图  


