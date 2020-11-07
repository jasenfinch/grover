#' listInstruments
#' @description List available instruments using the grover API.
#' @param grove S4 object of class Grover
#' @export

listInstruments <- function(grove){
  cmd <- str_c(hostURL(grove),'/instruments?','authKey=',auth(grove))
  cmd %>%
    GET() %>%
    content() %>%
    unlist()
}

#' listDirectories
#' @description List all directories for a given instrument using the grover API.
#' @param grove S4 object of class Grover
#' @param instrument instrument name
#' @importFrom stringr str_c
#' @importFrom magrittr %>%
#' @importFrom httr GET content
#' @export

listDirectories <- function(grove,instrument){
  cmd <- str_c(hostURL(grove),'/directories?','authKey=',auth(grove),'&instrument=',instrument)
  cmd %>%
    GET() %>%
    content() %>%
    unlist()
}

#' listRawFiles
#' @description List all raw files present in a given directory using the grover API.
#' @param grove S4 object of class Grover
#' @param instrument instrument name
#' @param directory directory name
#' @export

listRawFiles <- function(grove,instrument,directory){
  cmd <- str_c(hostURL(grove),'/rawfiles?',
               'authKey=',auth(grove),'&instrument=',instrument,'&directory=',directory)
  cmd %>%
    GET() %>%
    content() %>%
    unlist()
}

#' convertFile
#' @description Convert a raw MS file using the grover API.
#' @param grove S4 object of class Grover
#' @param instrument instrument name
#' @param directory directory name
#' @param file file name
#' @param args arguments to pass to msconvert
#' @param outDir output directory path for converted files
#' @importFrom stringr str_split
#' @importFrom utils URLencode
#' @export

convertFile <- function(grove, instrument, directory, file, args='', outDir = '.'){
  cat('\n',file,' ',cli::symbol$continue,'\r',sep = '')
  tidycmd <- str_c(hostURL(grove),'/tidyup?',
                   'authKey=',auth(grove),
                   '&instrument=',instrument,
                   '&directory=',directory
  )
  tidycmd %>% GET()
  cmd <- str_c(hostURL(grove),'/convert?',
               'authKey=',auth(grove),
               '&instrument=',instrument,
               '&directory=',directory,
               '&file=',file,
               '&args=')
  if (args != '') {
    cmd <- str_c(cmd,args)
  }
  fileName <- str_split(file,'[.]')[[1]][1]
  convertedFile <- cmd %>%
    URLencode() %>%
    GET()
  if (convertedFile$status_code == 200) {
    convertedFile <- convertedFile %>%
      content(as = 'text',encoding = 'UTF-8')
    writeLines(convertedFile,str_c(outDir,'/',fileName,'.mzML'))
    tidycmd <- str_c('http://',host(grove),':',port(grove),'/tidyup?',
                     'authKey=',auth(grove),
                     '&instrument=',instrument,
                     '&directory=',directory
    )
    tidycmd %>% GET()
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

#' convertDirectory
#' @description Convert a directory of raw files using the grover API.
#' @param grove S4 object of class Grover
#' @param instrument instrument name
#' @param directory directory name
#' @param args arguments to pass to msconvert
#' @param outDir output directory path for converted files
#' @importFrom purrr walk
#' @importFrom crayon green red bold blue yellow
#' @import cli
#' @import progress
#' @export

convertDirectory <- function(grove, instrument, directory, args = '', outDir = '.'){
  outDir <- str_c(outDir,directory,sep = '/')
  files <- listRawFiles(grove,instrument,directory)
  cat('\nConverting',bold(blue(directory)),'containing',bold(yellow(length(files))),'.raw files\n')
  dir.create(outDir)
  pb <- progress_bar$new(
    format = "  converting [:bar] :percent eta: :eta",
    total = length(files), clear = FALSE)
  pb$tick(0)
  walk(1:length(files),~{
    file <- files[.]
    convertFile(grove,instrument,directory,file,args,outDir)
    pb$tick()
  })
}

#' convertDirectorySplitModeC
#' @description Convert a directory of raw files, splitting positive and negative mode data using the grover API.
#' @param grove S4 object of class Grover
#' @param instrument instrument name
#' @param directory directory name
#' @param args arguments to pass to msconvert
#' @param outDir output directory path for converted files
#' @export

convertDirectorySplitModes <- function(grove,instrument, directory, args = '', outDir = '.'){
  outDir <- str_c(outDir,directory,sep = '/')
  dir.create(outDir)
  cat('\n',red('Negative Mode'),sep = '')
  negArgs <- str_c(args,conversionArgsNegativeMode(),sep = ' ')
  convertDirectory(grove,instrument,directory,negArgs,outDir)
  negDir <- str_c(outDir,'/',directory,'-neg')
  dir.create(negDir)
  walk(list.files(str_c(outDir,'/',directory),full.names = T),~{
    f <- str_split(.,'/')[[1]]
    f <- f[length(f)]
    file.rename(from = ., to = str_c(negDir,'/',f))
  })
  unlink(str_c(outDir,'/',directory),recursive = T)
  cat('\n',red('Positive Mode'),sep = '')
  posArgs <- str_c(args,conversionArgsPositiveMode(),sep = ' ')
  convertDirectory(grove,instrument,directory,posArgs,outDir)
  posDir <- str_c(outDir,'/',directory,'-pos')
  dir.create(posDir)
  walk(list.files(str_c(outDir,'/',directory),full.names = T),~{
    f <- str_split(.,'/')[[1]]
    f <- f[length(f)]
    file.rename(from = ., to = str_c(posDir,'/',f))
  })
  unlink(str_c(outDir,'/',directory),recursive = T)
}

#' conversionArgsPeakPick
#' @description msconvert args for peak picking.
#' @export

conversionArgsPeakPick <- function(){
  '--filter "peakPicking true 1-"'
}

#' conversionArgsNegativeMode
#' @description msconvert args to convert only positive mode data.
#' @export

conversionArgsNegativeMode <- function(){
  '--filter "polarity negative"'
}

#' conversionArgsPositiveMode
#' @description msconvert args to convert only negative mode data.
#' @export

conversionArgsPositiveMode <- function(){
  '--filter "polarity positive"'
}

#' conversionArgsIgnoreUnknownInstrumentError
#' @description msconvert args to ignore the unkown instrument error.
#' @export

conversionArgsIgnoreUnknownInstrumentError <- function(){
  '--ignoreUnknownInstrumentError'
}

#' conversionArgsMSlevel1
#' @description msconvert args to convert only MS level 1.
#' @export

conversionArgsMSlevel1 <- function(){
  '--filter "msLevel 1"'
}

#' conversionArgsMSlevel2
#' @description msconvert args to convert only MS level 2.
#' @export

conversionArgsMSlevel2 <- function(){
  '--filter "msLevel 2"'
}

#' conversionArgsMSlevel3
#' @description msconvert args to convert only MS level 3.
#' @export

conversionArgsMSlevel3 <- function(){
  '--filter "msLevel 3"'
}
