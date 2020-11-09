# Check if the grover host exists

hostExtant <- function(auth){
  if (auth == host_auth) {
    "I'm still here!"
  } else {
    stop('Incorrect authentication key')
  }
}
