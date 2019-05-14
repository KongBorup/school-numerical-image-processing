saltPepperNoise <- function(imgData, noiseVal) {
  w <- nrow(imgData)
  h <- ncol(imgData)
  
  for (x in 1:w) {
    for (y in 1:h) {
      randVal <- runif(1)
      
      if (randVal > 1 - noiseVal) {
        imgData[x, y] <- 1
      } else if (randVal < noiseVal) {
        imgData[x, y] <- 0
      }
    }
  }
  
  Image(imgData)
}