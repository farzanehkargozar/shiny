mechanism_mapping <- function(drugs, targetVector){
  
  mechanism <- drugs$mechanism
  temp <- c()
  for (i in 1:length(targetVector)) {
    
    temp <- append(temp, mechanism[targetVector[i]])
    
  }
  return(temp)
}