
#* @get /getRaw
getRaw <- function(authKey,instrument,directory,file){
  key <- readLines('~/grover.txt')[3]
  if (authKey == key) {
    f <- str_c('Y:',instrument,directory,file,sep = '/')
    if (file.exists(f)) {
      con <- file(f,'rb')
      f <- readBin(con,'raw',n = file.info(f)$size) %>%
        base64encode()
      close(con)
    } else {
      stop('File not found!')
    }
  } else {
    stop('Incorrect authentication key')
  }
  return(f)
}