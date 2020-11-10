
#* @get /tidyup
removeDirectory <- function(authKey,instrument,directory){
  key <- readLines('~/grover.txt')[3]
  if (authKey == key){
    unlink(str_c('C:/TMP_STORE/',instrument,'/',directory),recursive = T)
  } else {
    stop('Incorrect authentication key')
  }
}