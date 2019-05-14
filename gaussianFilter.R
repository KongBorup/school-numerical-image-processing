e <- exp(1)
sigma <- 1

G <- function(x, y) {
  1 / (2 * pi * sigma^2) * e^(-(x^2 + y^2) / (2 * sigma^2))
}

gaussianFilter <- function(imgData, kernelSize) {
  w <- nrow(imgData)
  h <- ncol(imgData)
  
  offset <- floor(kernelSize / 2)
  
  gaussianVals <- matrix(nrow = kernelSize, ncol = kernelSize)
  
  for (gx in -offset:offset) {
    for (gy in -offset:offset) {
      gaussianVals[gx + offset + 1, gy + offset + 1] <- G(gx, gy)
    }
  }
  
  for (x in (offset + 1):(w - offset)) {
    for (y in (offset + 1):(h - offset)) {
      xMin <- x - offset
      yMin <- y - offset
      xMax <- x + offset
      yMax <- y + offset
      
      imgData[x, y] <- sum(gaussianVals * imgData[xMin:xMax, yMin:yMax])
    }
  }
  
  Image(imgData)
}