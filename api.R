library(msconverteR)
library(stringr)
library(magrittr)

#* @get /convert
#* @xml
convertFile <- function(authKey,instrument,directory,file,args='',res){
  key <- readLines('~/grover.txt')[3]
  if (authKey == key) {
    dirPath <- str_c('C:/TMP_STORE/',instrument,'/',directory)
    dir.create(dirPath)
    msconvert(str_c('Z:\\',instrument,'\\',directory,'\\',file),
              outPath = str_c('C:\\TMP_STORE\\',instrument,'\\',directory),
              args) %>%
      str_c(collapse = '\n')
    fl <- list.files(dirPath,full.names = T)
    include_file(fl,res)
  } else {
    stop('Incorrect authentication key')
  }
}

#* @get /tidyup
removeDirectory <- function(authKey,instrument,directory){
  key <- readLines('~/grover.txt')[3]
  if (authKey == key){
    unlink(str_c('C:/TMP_STORE/',instrument,'/',directory),recursive = T)
  } else {
    stop('Incorrect authentication key')
  }
}

#* @get /directories
listDirectories <- function(authKey,instrument){
  key <- readLines('~/grover.txt')[3]
  if (authKey == key) {
    list.dirs(str_c('Z:\\',instrument),recursive = F,full.names = F)
  } else {
    stop('Incorrect authentication key')
  }
}

#* @get /rawfiles
listFiles <- function(authKey,instrument,directory){
  key <- readLines('~/grover.txt')[3]
  if (authKey == key) {
    files <- list.files(str_c('Z:\\',instrument,'\\',directory),recursive = F,full.names = F)
    files[str_detect(files,coll('.raw'))]
  } else {
    stop('Incorrect authentication key')
  }
}
