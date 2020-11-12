
hostExtant <- function(auth){
  
  grover_host <- readGrover(groverHostTemp())
  host_auth <- auth(grover_host)
  
  checkAuth(auth,host_auth)
  
  return("I'm still here!")
}
