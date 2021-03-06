#' Convert raw files to mzML format
#' @rdname convert
#' @description Convert a raw MS file using a grover API.
#' @param grover_client S4 object of class GroverClient
#' @param instrument instrument name
#' @param directory directory name
#' @param file file name
#' @param args arguments to pass to msconverteR::convert_files
#' @param outDir output directory path for converted files
#' @importFrom tools file_path_sans_ext
#' @importFrom stringr str_split
#' @importFrom httr PUT
#' @importFrom utils URLencode
#' @importFrom fs dir_create
#' @importFrom progress progress_bar
#' @importFrom crayon yellow bold
#' @export

setMethod('convertFile',signature = 'GroverClient',
          function(grover_client, 
                   instrument, 
                   directory, 
                   file, 
                   args = NULL, 
                   outDir = '.'){
            
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
            
            if (is.null(args)) {
             args <- ''
            }
            
            cmd <- str_c(cmd,args)
            
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
              message('\r',
                      file,
                      ' ',
                      crayon::green(cli::symbol$tick),
                      '\n',
                      sep = '')
              return('success')
            }
            if (success == 0) {
              message('\r',
                      file,
                      ' ',
                      crayon::red(cli::symbol$cross),
                      '\n',
                      sep = '')
              return('failure')
            }
          })

#' @rdname convert
#' @export

setMethod('convertDirectory',signature = 'GroverClient',
          function(grover_client, 
                   instrument, 
                   directory, 
                   args = '', 
                   outDir = '.'){
            
            files <- listRawFiles(grover_client,instrument,directory)
            
            message('\nConverting ',
                    bold(blue(directory)),
                    ' containing ',
                    bold(yellow(length(files))),
                    ' .raw files\n')
            
            outDir <- str_c(outDir,directory,sep = '/')
            dir_create(outDir)
            
            pb <- progress_bar$new(
              format = "[:bar] :percent eta: :eta",
              total = length(files), clear = FALSE)
            pb$tick(0)
            
            results <- map(seq_len(length(files)),~{
              file <- files[.]
              suppressMessages({
                res <- convertFile(grover_client,
                                   instrument,
                                   directory,
                                   file,
                                   args,
                                   outDir)
              })
              pb$tick()
              return(res)
            })
            
            message()
            
            results <- files[str_detect(results,'failure')]
            
            if (length(results) > 0) {
              warning(str_c('Unable to convert files: ',
                            str_c(results,collapse = ', ')),call. = FALSE)
            }
          })

#' @rdname convert
#' @importFrom purrr walk
#' @importFrom fs dir_delete file_move
#' @importFrom crayon red
#' @export

setMethod('convertDirectorySplitModes',signature = 'GroverClient',
          function(grover_client,
                   instrument, 
                   directory, 
                   args = '', 
                   outDir = '.'){
            
            outDir <- str_c(outDir,directory,sep = '/')
            dir_create(outDir)
            
            message('\n',red('Negative Mode'),sep = '')
            
            negArgs <- c(args,conversionArgsNegativeMode())
            
            convertDirectory(grover_client,
                             instrument,
                             directory,
                             negArgs,
                             outDir)
            
            negDir <- str_c(outDir,'/',directory,'-neg')
            dir_create(negDir)
            
            walk(list.files(str_c(outDir,'/',directory),full.names = TRUE),~{
              f <- str_split(.,'/')[[1]]
              f <- f[length(f)]
              file_move(.x,str_c(negDir,'/',f))
            })
            
            dir_delete(str_c(outDir,'/',directory))
            
            message('\n',red('Positive Mode'),sep = '')
            
            posArgs <- c(args,conversionArgsPositiveMode())
            
            convertDirectory(grover_client,
                             instrument,
                             directory,
                             posArgs,
                             outDir)
            
            posDir <- str_c(outDir,'/',directory,'-pos')
            dir_create(posDir)
            
            walk(list.files(str_c(outDir,'/',directory),full.names = TRUE),~{
              f <- str_split(.,'/')[[1]]
              f <- f[length(f)]
              file_move(.x,str_c(posDir,'/',f))
            })
            dir_delete(str_c(outDir,'/',directory))
          })

#' Conversion arguments
#' @rdname conversionArgs
#' @description Helper functions for msconvert arguments for raw data conversion.
#' @details 
#' These functions return character strings suitable for supplying to the \code{args} 
#' argument of \code{convertFile} for passing to msconvert.
#' @examples 
#' conversionArgsPeakPick()
#' @export

conversionArgsPeakPick <- function(){
  'peakPicking true1-'
}

#' @rdname conversionArgs
#' @export

conversionArgsNegativeMode <- function(){
  'polarity negative'
}

#' @rdname conversionArgs
#' @export

conversionArgsPositiveMode <- function(){
  'polarity positive'
}

#' @rdname conversionArgs
#' @export

conversionArgsMSlevel1 <- function(){
  'msLevel 1'
}

#' @rdname conversionArgs
#' @export

conversionArgsMSlevel2 <- function(){
  'msLevel 2'
}

#' @rdname conversionArgs
#' @export

conversionArgsMSlevel3 <- function(){
  'msLevel 3'
}
