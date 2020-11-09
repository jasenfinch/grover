#* @get /instruments
listInstruments <- function(authKey){
  key <- readLines('~/grover.txt')[3]
  if (authKey == key){
    list.dirs('Y:\\',recursive = F,full.names = F)
  } else {
    stop('Incorrect authentication key')
  }
}

#* @get /directories
listDirectories <- function(authKey,instrument){
  key <- readLines('~/grover.txt')[3]
  if (authKey == key) {
    list.dirs(str_c('Y:\\',instrument),recursive = F,full.names = F)
  } else {
    stop('Incorrect authentication key')
  }
}

#* @get /rawfiles
rawFiles <- function(authKey,instrument,directory){
  key <- readLines('~/grover.txt')[3]
  if (authKey == key) {
    path <- str_c('Y:\\',instrument,'\\',directory)
    files <- list.files(path,recursive = F,full.names = F)
    if (instrument == 'TSQ'){
      return(files[str_detect(files,coll('.RAW'))])
    } else {
      return(files[str_detect(files,coll('.raw'))])
    }
  } else {
    stop('Incorrect authentication key')
  }
}

#* @get /listFiles
listFiles <- function(authKey,instrument,directory){
  key <- readLines('~/grover.txt')[3]
  if (authKey == key) {
    path <- str_c('Y:\\',instrument,'\\',directory)
    files <- list.files(path,recursive = F,full.names = F)
  } else {
    stop('Incorrect authentication key')
  }
  return(files)
}

#* @get /convert
#* @xml
convertFile <- function(authKey,instrument,directory,file,args='',res){
  key <- readLines('~/grover.txt')[3]
  if (authKey == key) {
    dirPath <- str_c('C:/TMP_STORE/',instrument,'/',directory)
    dir.create(dirPath)
    msconvert(str_c('Y:\\',instrument,'\\',directory,'\\',file),
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