# SETUP VARIABLES

inputFile <- 'inputs/obama.jpg'
kernelSizes <- c(3, 5, 7) # NEEDS to be uneven!

options(scipen = 999)


# PROGRAM START

library('EBImage')

# Load own scripts
source('gaussianNoise.R')
source('saltPepperNoise.R')
source('meanFilter.R')
source('medianFilter.R')
source('gaussianFilter.R')
source('meanSquareError.R')

# Load input image
loadImage <- function(path) {
  img <- readImage(path)
  img <- channel(img, 'gray')
  imgData <- as.array(img)
  
  imgData
}

# Util file saving function
saveImageFile <- function(imgData, folderPath, fileName) {
  fileName <- paste(fileName, '.jpg', sep = '')
  
  writeImage(outImg, file.path(folderPath, fileName))
}

imgData <- loadImage(inputFile)


# GAUSSIAN NOISE

gaussianNoiseVals <- seq(from = 0, to = 0.5, by = 0.05)

for (noiseVal in gaussianNoiseVals) {
  outImg <- gaussianNoise(imgData, noiseVal)

  saveImageFile(outImg,
                'outputs/obama/gaussian-noise',
                paste('noise-', format(noiseVal, nsmall = 2), sep = ''))
}


# SALT-AND-PEPPER NOISE

saltPepperNoiseVals <- seq(from = 0, to = 0.3, by = 0.05)

for (noiseVal in saltPepperNoiseVals) {
  outImg <- saltPepperNoise(imgData, noiseVal)

  saveImageFile(outImg,
                'outputs/obama/salt-and-pepper-noise',
                paste('noise-', format(noiseVal, nsmall = 2), sep = ''))
}

MSETable <- data.frame(matrix(0, ncol = 0, nrow = length(gaussianNoiseVals)))
row.names(MSETable) <- format(gaussianNoiseVals, nsmall = 2)

for (kernelSize in kernelSizes) {
  
  # MEAN FILTER
  
  for (noiseVal in gaussianNoiseVals) {
    filePath <- paste('outputs/obama/gaussian-noise/noise-',
                      format(noiseVal, nsmall = 2), '.jpg', sep = '')
    imgData <- loadImage(filePath)
  
    outImg <- meanFilter(imgData, kernelSize)
  
    saveImageFile(outImg,
                  paste('outputs/obama/mean-filter/gaussian-noise/kernel-size=', kernelSize, sep = ''),
                  paste('noise-', format(noiseVal, nsmall = 2), sep = ''))
  }

  for (noiseVal in saltPepperNoiseVals) {
    filePath <- paste('outputs/obama/salt-and-pepper-noise/noise-',
                      format(noiseVal, nsmall = 2), '.jpg', sep = '')
    imgData <- loadImage(filePath)
  
    outImg <- meanFilter(imgData, kernelSize)
  
    saveImageFile(outImg,
                  paste('outputs/obama/mean-filter/salt-and-pepper-noise/kernel-size=', kernelSize, sep = ''),
                  paste('noise-', format(noiseVal, nsmall = 2), sep = ''))
  }

  # MEDIAN FILTER

  for (noiseVal in gaussianNoiseVals) {
    filePath <- paste('outputs/obama/gaussian-noise/noise-',
                      format(noiseVal, nsmall = 2), '.jpg', sep = '')
    imgData <- loadImage(filePath)
  
    outImg <- medianFilter(imgData, kernelSize)
  
    saveImageFile(outImg,
                  paste('outputs/obama/median-filter/gaussian-noise/kernel-size=', kernelSize, sep = ''),
                  paste('noise-', format(noiseVal, nsmall = 2), sep = ''))
  }
  
  for (noiseVal in saltPepperNoiseVals) {
    filePath <- paste('outputs/obama/salt-and-pepper-noise/noise-',
                      format(noiseVal, nsmall = 2), '.jpg', sep = '')
    imgData <- loadImage(filePath)
  
    outImg <- medianFilter(imgData, kernelSize)
  
    saveImageFile(outImg,
                  paste('outputs/obama/median-filter/salt-and-pepper-noise/kernel-size=', kernelSize, sep = ''),
                  paste('noise-', format(noiseVal, nsmall = 2), sep = ''))
  }

  # GAUSSIAN FILTER

  for (noiseVal in gaussianNoiseVals) {
    filePath <- paste('outputs/obama/gaussian-noise/noise-',
                      format(noiseVal, nsmall = 2), '.jpg', sep = '')
    imgData <- loadImage(filePath)

    outImg <- gaussianFilter(imgData, kernelSize)

    saveImageFile(outImg,
                  paste('outputs/obama/gaussian-filter/gaussian-noise/kernel-size=', kernelSize, sep = ''),
                  paste('noise-', format(noiseVal, nsmall = 2), sep = ''))
  }
  
  for (noiseVal in saltPepperNoiseVals) {
    filePath <- paste('outputs/obama/salt-and-pepper-noise/noise-',
                      format(noiseVal, nsmall = 2), '.jpg', sep = '')
    imgData <- loadImage(filePath)

    outImg <- gaussianFilter(imgData, kernelSize)

    saveImageFile(outImg,
                  paste('outputs/obama/gaussian-filter/salt-and-pepper-noise/kernel-size=', kernelSize, sep = ''),
                  paste('noise-', format(noiseVal, nsmall = 2), sep = ''))
  }

  # MEAN SQUARE ERROR (MSE) ANALYSIS OF FILTERED GAUSSIAN NOISE

  meanColumnName <- paste('meanFilter-', kernelSize, 'x', kernelSize, sep = '')
  MSETable[meanColumnName] = NA
  medianColumnName <- paste('medianFilter-', kernelSize, 'x', kernelSize, sep = '')
  MSETable[medianColumnName] = NA
  gaussianColumnName <- paste('gaussianFilter-', kernelSize, 'x', kernelSize, sep = '')
  MSETable[gaussianColumnName] = NA

  for (noiseVal in gaussianNoiseVals) {
    originalImageData <- loadImage(inputFile)

    # Mean filter
    filteredImageData <- loadImage(paste('outputs/obama/mean-filter/gaussian-noise/kernel-size=',
                                         kernelSize, '/', 'noise-', format(noiseVal, nsmall = 2),
                                         '.jpg', sep = ''))

    MSETable[format(noiseVal, nsmall = 2), meanColumnName] <- meanSquareError(originalImageData, filteredImageData)


    # Median filter
    filteredImageData <- loadImage(paste('outputs/obama/median-filter/gaussian-noise/kernel-size=',
                                         kernelSize, '/', 'noise-', format(noiseVal, nsmall = 2),
                                         '.jpg', sep = ''))

    MSETable[format(noiseVal, nsmall = 2), medianColumnName] <- meanSquareError(originalImageData, filteredImageData)

    # Gaussian filter
    filteredImageData <- loadImage(paste('outputs/obama/gaussian-filter/gaussian-noise/kernel-size=',
                                         kernelSize, '/', 'noise-', format(noiseVal, nsmall = 2),
                                         '.jpg', sep = ''))

    MSETable[format(noiseVal, nsmall = 2), gaussianColumnName] <- meanSquareError(originalImageData, filteredImageData)
  }
}
