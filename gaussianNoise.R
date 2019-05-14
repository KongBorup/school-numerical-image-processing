gaussianNoise <- function(imgData, noiseVal) {
  w <- nrow(imgData)
  h <- ncol(imgData)
  
  randNums <- rnorm(w * h, mean = 0, sd = noiseVal)
  
  for (x in 1:w) {
    for (y in 1:h) {
      imgData[x, y] <- imgData[x, y] + randNums[x + w * (y - 1)]
    }
  }
  
  Image(imgData)
}