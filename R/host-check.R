# Check if the grover host exists

hostExtant <- function(auth){
  
  grover_host <- readGrover(groverHostTemp())
  host_auth <- auth(grover_host)
  
  if (auth == host_auth) {
    "I'm still here!"
  } else {
    stop('Incorrect authentication key')
  }
}
