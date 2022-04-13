sort_RandomWalk_vector <- function(randomWalkMatrix, rowNumber){
  
  vectorRandomWalk <- randomWalkMatrix[rowNumber,]
  sortVectorRandomWalk <- sort(vectorRandomWalk, decreasing = TRUE)
  
  numberNode <- c()
  
  for (i in 1:length(vectorRandomWalk)) {
    
    temp <- match(sortVectorRandomWalk[i], vectorRandomWalk)
    numberNode <- append(numberNode, temp)
    
  }
  
  return(data.frame(value = sortVectorRandomWalk, node = numberNode))
}