# School project: Numerical Image Processing with R
## Project
In this school project, the class has worked with applying noise to images using
the `EBImage` library for R and then removing the noise again with various
algorithms.

Both Gaussian noise as well as salt-and-pepper noise have been applied to the
images. For filtering the images, a mean, median, and Gaussian filter has been
used.
## Performance discussion
The initial commit of this project took half an hour to process the Obama image.
R's `system.time` yielded:
```R
   user  system elapsed 
1601.12    5.06 1632.89
```
After doing some vectorization optimizations, the runtime was lowered to 20
minutes:
```R
   user  system elapsed 
1189.93    5.39 1219.63
```
Still, there are more optimizations to be done. Currently `Rprof` yields:
```R
                       self.time self.pct total.time total.pct
"insertionSort"           978.02    82.06     979.62     82.20
"medianFilter"             72.52     6.09    1075.34     90.23
"gaussianFilter"           41.42     3.48      47.20      3.96
"meanFilter"               36.34     3.05      36.72      3.08
"as.vector"                18.76     1.57      18.78      1.58
".Call"                     7.14     0.60       7.14      0.60
"meanSquareError"           5.78     0.48       5.88      0.49
"runif"                     5.68     0.48       5.68      0.48
"sum"                       5.42     0.45       5.42      0.45
"getDataPart"               4.72     0.40       4.72      0.40
"is.na"                     4.24     0.36       4.24      0.36
"saltPepperNoise"           2.04     0.17       7.80      0.65
"gaussianNoise"             1.78     0.15       2.52      0.21
[...]
```
This shows that the largest slow-down is the median filter taking up 90% of the
runtime. Here the main problem is the `insertionSort` function. Might there be a better (faster) way to find the median?

Personally, I speculate if it's possible to optimize the progam by somehow
vectorizing this nested for loop that loops through every pixel in the image:
```R
for (x in offset:(w - offset)) {
   for (y in offset:(h - offset)) {
   xMin <- x - offset
   yMin <- y - offset
   xMax <- x + offset
   yMax <- y + offset
   
   insideKernel <- imgData[xMin:xMax, yMin:yMax]
   }
}
```