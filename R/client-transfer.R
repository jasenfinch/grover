#' getFile
#' @rdname getFile
#' @description Transfer a file using the grover API.
#' @param grover_client S4 object of class GroverClient
#' @param instrument instrument name
#' @param directory directory name
#' @param file file name
#' @param outDir output directory path for transferred file
#' @param base
#' @export

setMethod('getFile',signature = 'GroverClient',
          function(grover_client,instrument,directory,file,outDir = '.'){
            
            cat('\n',file,' ',cli::symbol$continue,'\r',sep = '')
            
            cmd <- str_c(hostURL(grover_client),'/getFile?',
                         'auth=',auth(grover_client),
                         '&instrument=',instrument,
                         '&directory=',directory,
                         '&file=',file)
            
            file_data <- cmd %>%
              URLencode() %>%
              GET()
            
            if (file_data$status_code == 200) {
              con <- str_c(outDir,'/',file) %>%
                file('wb')
              
              file_data <- file_data %>%
                content(as = 'raw')
              
              writeBin(file_data,con)
              close(con)
              
              success <- 1
            } else {
              success <- 0
            }
            if (success == 1) {
              cat('\r',file,' ',crayon::green(cli::symbol$tick),'\n',sep = '')
            }
            if (success == 0) {
              cat('\r',file,' ',crayon::red(cli::symbol$cross),'\n',sep = '')
            }
          })

#' rawFile
#' @description Transfer a raw MS file using the grover API.
#' @param grove S4 object of class Grover
#' @param instrument instrument name
#' @param directory directory name
#' @param file file name
#' @param outDir output directory path for converted files
#' @export

rawFile <- function(grove,instrument,directory,file,outDir = '.'){
  cat('\n',file,' ',cli::symbol$continue,'\r',sep = '')
  cmd <- str_c(hostURL(grove),'/getRaw?',
               'authKey=',auth(grove),
               '&instrument=',instrument,
               '&directory=',directory,
               '&file=',file)
  rawData <- cmd %>%
    URLencode() %>%
    GET()
  if (rawData$status_code == 200) {
    con <- str_c(outDir,'/',file) %>%
      file('wb')
    rawD <- rawData %>%
      content(as = 'text',encoding = 'UTF-8') %>%
      base64enc::base64decode()
    writeBin(rawD,con)
    close(con)
    success <- 1
  } else {
    success <- 0
  }
  if (success == 1) {
    cat('\r',file,' ',crayon::green(cli::symbol$tick),'\n',sep = '')
  }
  if (success == 0) {
    cat('\r',file,' ',crayon::red(cli::symbol$cross),'\n',sep = '')
  }
}

#' rawDirectory
#' @description Transfer a directory of raw files using the grover API.
#' @param grove S4 object of class Grover
#' @param instrument instrument name
#' @param directory directory name
#' @param outDir output directory path for converted files
#' @export

rawDirectory <- function(grove, instrument, directory, outDir = '.'){
  outDir <- str_c(outDir,directory,sep = '/')
  files <- listRawFiles(grove,instrument,directory)
  cat('\nTransfering',bold(blue(directory)),'containing',bold(yellow(length(files))),'.raw files\n')
  dir.create(outDir)
  pb <- progress_bar$new(
    format = "  transfering [:bar] :percent eta: :eta",
    total = length(files), clear = FALSE)
  pb$tick(0)
  walk(1:length(files),~{
    rawFile(grove,instrument,directory,files[.x],outDir)
    pb$tick()
  })
}