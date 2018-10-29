denied <- function(){
  stop('Incorrect authentication key')
}

extant <- function(auth){
  key <- auth(grove)
  if (auth == key) {
    "I'm here!"
  } else {
    denied()
  }
}

repository <- function(path){
  
}
