library(msconverteR)
library(stringr)
library(magrittr)

#* @get /convert
#* @xml
convertFile <- function(instrument,directory,file,args='',res){
  dirPath <- str_c('C:/TMP_STORE/',instrument,'/',directory)
  dir.create(dirPath)
  msconvert(str_c('Z:\\',instrument,'\\',directory,'\\',file),
            outPath = str_c('C:\\TMP_STORE\\',instrument,'\\',directory),
            args) %>%
    str_c(collapse = '\n')
  fl <- list.files(dirPath,full.names = T)
  include_file(fl,res)
}


