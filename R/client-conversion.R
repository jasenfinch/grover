#' convertFile
#' @rdname convertFile
#' @description Convert a raw MS file using the grover API.
#' @param grover_client S4 object of class GroverClient
#' @param instrument instrument name
#' @param directory directory name
#' @param file file name
#' @param args arguments to pass to msconverteR::convert_files
#' @param outDir output directory path for converted files
#' @importFrom tools file_path_sans_ext
#' @importFrom stringr str_split
#' @importFrom httr PUT
#' @export

setMethod('convertFile',signature = 'GroverClient',
          function(grover_client, instrument, directory, file, args='', outDir = '.'){
            cat('\n',file,' ',cli::symbol$continue,'\r',sep = '')
            
            converted_file <- file %>%
              file_path_sans_ext() %>%
              str_c('.mzML')
            
            tidycmd <- str_c(hostURL(grover_client),'/tidy?',
                             'auth=',auth(grover_client),
                             '&file=',converted_file)
            tidycmd %>% PUT()
            
            cmd <- str_c(hostURL(grover_client),'/convert?',
                         'auth=',auth(grover_client),
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
              
              tidycmd <- str_c(hostURL(grover_client),'/tidyup?',
                               'auth=',auth(grover_client),
                               '&instrument=',instrument,
                               '&directory=',directory
              )
              tidycmd %>% PUT()
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

#' convertDirectory
#' @rdname convertDirectory
#' @description Convert a directory of raw files using the grover API.
#' @param grover_client S4 object of class GroverClient
#' @param instrument instrument name
#' @param directory directory name
#' @param args arguments to pass to msconverteR::convert_files
#' @param outDir output directory path for converted files
#' @import progress
#' @importFrom crayon bold yellow
#' @importFrom purrr walk
#' @export

setMethod('convertDirectory',signature = 'GroverClient',
          function(grover_client, instrument, directory, args = '', outDir = '.'){
            
            files <- listRawFiles(grover_client,instrument,directory)
            
            cat('\nConverting',bold(blue(directory)),'containing',bold(yellow(length(files))),'.raw files\n')
            
            outDir <- str_c(outDir,directory,sep = '/')
            dir.create(outDir)
            
            pb <- progress_bar$new(
              format = "  converting [:bar] :percent eta: :eta",
              total = length(files), clear = FALSE)
            pb$tick(0)
            
            walk(1:length(files),~{
              file <- files[.]
              convertFile(grover_client,instrument,directory,file,args,outDir)
              pb$tick()
            })
          })

#' convertDirectorySplitModes
#' @rdname convertDirectorySplitModes
#' @description Convert a directory of raw files, splitting positive and negative mode data using the grover API.
#' @param grover_client S4 object of class GroverClient
#' @param instrument instrument name
#' @param directory directory name
#' @param args arguments to pass to msconverteR::convert_files
#' @param outDir output directory path for converted files
#' @importFrom crayon red
#' @export

setMethod('convertDirectorySplitModes',signature = 'GroverClient',
          function(grover_client,instrument, directory, args = '', outDir = '.'){
            
            outDir <- str_c(outDir,directory,sep = '/')
            dir.create(outDir)
            
            cat('\n',red('Negative Mode'),sep = '')
            
            negArgs <- str_c(args,conversionArgsNegativeMode(),sep = ' ')
            
            convertDirectory(grover_client,instrument,directory,negArgs,outDir)
            
            negDir <- str_c(outDir,'/',directory,'-neg')
            dir.create(negDir)
            
            walk(list.files(str_c(outDir,'/',directory),full.names = TRUE),~{
              f <- str_split(.,'/')[[1]]
              f <- f[length(f)]
              file.rename(from = ., to = str_c(negDir,'/',f))
            })
            
            unlink(str_c(outDir,'/',directory),recursive = TRUE)
            
            cat('\n',red('Positive Mode'),sep = '')
            
            posArgs <- str_c(args,conversionArgsPositiveMode(),sep = ' ')
            
            convertDirectory(grover_client,instrument,directory,posArgs,outDir)
            
            posDir <- str_c(outDir,'/',directory,'-pos')
            dir.create(posDir)
            
            walk(list.files(str_c(outDir,'/',directory),full.names = TRUE),~{
              f <- str_split(.,'/')[[1]]
              f <- f[length(f)]
              file.rename(from = ., to = str_c(posDir,'/',f))
            })
            unlink(str_c(outDir,'/',directory),recursive = TRUE)
          })

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
