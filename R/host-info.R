#* @get /sampleInfo
#* @json
sampleInfo <- function(authKey,instrument,directory,file){
  key <- readLines('~/grover.txt')[3]
  if (authKey == key) {
    path <- str_c('Y:',instrument,directory,file,sep = '/')
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
    path <- str_c('Y:',instrument,directory,file,sep = '/')
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
    file <- str_c('Y:',instrument,directory,'config.yml',sep = '/')
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