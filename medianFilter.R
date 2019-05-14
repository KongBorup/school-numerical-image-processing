# Use manually written insertion sort because it is much faster at sorting small
# vectors than the built-in sort() function.
insertionSort <- function(v) {
  for (j in 2:length(v)) {
    key <- v[j]
    i <- j - 1 
    
    while (i > 0 && v[i] > key) {
      v[i + 1] <- v[i]
      i <- i - 1 
    }
    
    v[i + 1] <- key
  }
  
  v
}

medianFilter <- function(imgData, kernelSize) {
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
      insideKernelVec <- as.vector(insideKernel)
      insideKernelVec <- insideKernelVec[!is.na(insideKernelVec)]
      
      # Add 0.5 because kernel size is always an uneven number
      medianPixel <- insertionSort(insideKernelVec)[kernelSize^2 / 2 + 0.5]
      
      imgData[x, y] <- medianPixel
    }
  }
  
  Image(imgData)
}