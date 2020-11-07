#* @get /extant
alive <- function(authKey){
  key <- readLines('~/grover.txt')[3]
  if (authKey == key) {
    "I'm still here!"
  } else {
    stop('Incorrect authentication key')
  }
}
