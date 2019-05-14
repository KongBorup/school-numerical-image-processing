meanFilter <- function(imgData, kernelSize) {
  w <- nrow(imgData)
  h <- ncol(imgData)
  
  offset <- floor(kernelSize / 2)
  
  for (x in offset:(w - offset)) {
    for (y in offset:(h - offset)) {
      # Read all pixels inside kernel
      xMin <- x - offset
      yMin <- y - offset
      xMax <- x + offset
      yMax <- y + offset
      
      insideKernel <- c()
      
      for (kx in xMin:xMax) {
        for (ky in yMin:yMax) {
          insideKernel <- c(insideKernel, imgData[kx, ky])
        }
      }
      
      imgData[x, y] <- mean(insideKernel)
    }
  }
  
  Image(imgData)
}