
hostExtant <- function(auth){
  if (auth == auth(grove_host)) {
    "I'm still here!"
  } else {
    stop('Incorrect authentication key')
  }
}
