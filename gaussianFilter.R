gaussianFilter <- function(imgData, kernelSize) {
  w <- nrow(imgData)
  h <- ncol(imgData)
  
  offset <- floor(kernelSize / 2)
  
  e <- exp(1)
  sigma <- 1
  
  G <- function(x, y) {
    1 / (2 * pi * sigma^2) * e^(-(x^2 + y^2) / (2 * sigma^2))
  }
  
  gaussianVals <- matrix(nrow = kernelSize, ncol = kernelSize)
  
  for (gx in -offset:offset) {
    for (gy in -offset:offset) {
      gaussianVals[gx + offset + 1, gy + offset + 1] <- G(gx, gy)
    }
  }
  
  for (x in offset:(w - offset - 1)) { # why tf is there subtraction here and addition later?
    for (y in offset:(h - offset - 1)) {
      newPixVal <- 0
      
      # Loop over kernel pixels
      xMin <- x - offset + 1
      yMin <- y - offset + 1
      xMax <- x + offset + 1
      yMax <- y + offset + 1
      
      for (kx in xMin:xMax) {
        for (ky in yMin:yMax) {
          ix <- kx - xMin + 1
          iy <- ky - yMin + 1
          
          newPixVal <- newPixVal + gaussianVals[ix, iy] * imgData[kx, ky]
        }
      }
      
      imgData[x, y] <- newPixVal
    }
  }
  
  Image(imgData)
}