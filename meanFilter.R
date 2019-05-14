meanFilter <- function(imgData, kernelSize) {
  w <- nrow(imgData)
  h <- ncol(imgData)
  
  offset <- floor(kernelSize / 2)
  
  for (x in offset:(w - offset)) {
    for (y in offset:(h - offset)) {
      xMin <- x - offset
      yMin <- y - offset
      xMax <- x + offset
      yMax <- y + offset
      
      insideKernel <- imgData[xMin:xMax, yMin:yMax]
      imgData[x, y] <- .Internal(mean(insideKernel))
    }
  }
  
  Image(imgData)
}