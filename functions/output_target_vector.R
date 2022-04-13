output_target_vector <- function(sortRandomWalkVector, targetMatrix, numberTarget){
  
  targetVector <- c()
  targetProbability <- c()
  
  temp <- targetMatrix
  cnt <- 0
    
    for (i in 1:nrow(sortRandomWalkVector)) {
      
      for (j in 1:ncol(targetMatrix)) {
        
        if(temp[sortRandomWalkVector$node[i],j]==1 && cnt < numberTarget){
          
          targetVector <- append(targetVector, j)
          targetProbability <- append(targetProbability, sortRandomWalkVector$value[i])
          cnt <- cnt + 1
          temp[,j] <- 0
          
        }
        
      }
      
    }
  
  return(data.frame(target = targetVector, probability = targetProbability))
  
}