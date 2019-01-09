library(stringr)
library(magrittr)
library(rjson)
library(GetSampleInfo)
library(yaml)
library(plumber)

#* @get /extant
alive <- function(authKey){
  key <- readLines('~/grover.txt')[3]
  if (authKey == key) {
    "I'm still here!"
  } else {
    stop('Incorrect authentication key')
  }
}

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

#* @get /instruments
listInstruments <- function(authKey){
  key <- readLines('~/grover.txt')[3]
  if (authKey == key){
    list.dirs('Z:\\',recursive = F,full.names = F)
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
    path <- str_c('Z:\\',instrument,'\\',directory)
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

#* @get /sampleInfo
#* @json
sampleInfo <- function(authKey,instrument,directory,file){
  key <- readLines('~/grover.txt')[3]
  if (authKey == key) {
    path <- str_c('Z:',instrument,directory,file,sep = '/')
    GetSampleInfo(path) %>%
      split(1:nrow(.)) %>%
      unname() %>%
      toJSON()
  } else {
    stop('Incorrect authentication key')
  }
}

#* @get /sampleScanFilters
#* @json
sampleScanFilters <- function(authKey,instrument,directory,file){
  key <- readLines('~/grover.txt')[3]
  if (authKey == key) {
    path <- str_c('Z:',instrument,directory,file,sep = '/')
    GetScanFilters(path) %>%
      split(1:nrow(.)) %>%
      unname() %>%
      toJSON()
  } else {
    stop('Incorrect authentication key')
  }
}

#* @get /getConfig
#* @json
getConfig <- function(authKey,instrument,directory){
  key <- readLines('~/grover.txt')[3]
  if (authKey == key) {
    file <- str_c('Z:',instrument,directory,'config.yml',sep = '/')
    if (file.exists(file)) {
      read_yaml(file) %>%
        toJSON()
    } else {
      stop('No config found!')
    }
  } else {
    stop('Incorrect authentication key')
  }
}