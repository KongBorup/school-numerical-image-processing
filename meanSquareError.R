meanSquareError <- function(before, after) {
  w <- nrow(before)
  h <- ncol(before)
  
  offset <- floor(kernelSize / 2)
  
  pixelSum <- 0
  
  for (x in offset:(w - offset)) {
    for (y in offset:(h - offset)) {
      # print()
      pixelSum <- pixelSum + (before[x, y] - after[x, y])^2
    }
  }
  
  mse <- pixelSum / (w * h)
}