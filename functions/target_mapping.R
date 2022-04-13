target_mapping <- function(targetMatrix, targetVector){
  
  name <- colnames(targetMatrix)
  temp <- c()
  for (i in 1:length(targetVector)) {
    
    temp <- append(temp, name[targetVector[i]])
    
  }
  return(temp)
}