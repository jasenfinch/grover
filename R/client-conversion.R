#' Convert raw files to mzML format
#' @rdname convert
#' @description Convert a raw MS file using a grover API.
#' @param grover_client S4 object of class GroverClient
#' @param instrument instrument name
#' @param directory directory name
#' @param file file name
#' @param args arguments to pass to msconverteR::convert_files
#' @param outDir output directory path for converted files
#' @param zip zip converted file 
#' @param overwrite overwrite local mzML files that already exist at the `outDir` path that have the same file name as the raw files to be converted 
#' @param exclude A character vector of regular expression patterns for which raw files with matching patterns will not be converted.
#' @return A vector of file paths to converted data files.
#' @importFrom tools file_path_sans_ext
#' @importFrom stringr str_split
#' @importFrom httr PUT
#' @importFrom utils URLencode
#' @importFrom fs dir_create file_delete
#' @importFrom progress progress_bar
#' @importFrom crayon yellow bold
#' @importFrom R.utils gzip
#' @importFrom purrr map_lgl
#' @export

setMethod('convertFile',signature = 'GroverClient',
          function(grover_client, 
                   instrument, 
                   directory, 
                   file, 
                   args = NULL, 
                   outDir = '.',
                   zip = TRUE,
                   overwrite = FALSE){
            
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
            
            if (length(args) > 1) {
              args <- args %>% 
                .[. != ''] %>% 
                str_c(collapse = ' ')
            }
            
            cmd <- str_c(cmd,args)
            
            fileName <- str_split(file,'[.]')[[1]][1]
            
            convertedFile <- cmd %>%
              URLencode() %>%
              GET()
            
            if (convertedFile$status_code == 200) {
              convertedFile <- convertedFile %>%
                content(as = 'text',encoding = 'UTF-8')
              
              if (!dir.exists(outDir)){
                dir_create(outDir)
              }
              
              converted_file_path <- str_c(outDir,'/',fileName,'.mzML')
              
              writeLines(convertedFile,converted_file_path)
              
              if (isTRUE(zip)){
                zipped_file_path <- str_c(outDir,'/',fileName,'.mzML.gz')
                
                gzip(converted_file_path,
                     zipped_file_path,
                     overwrite = overwrite)
                
                converted_file_path <- zipped_file_path
              }
              
              tidycmd <- str_c(hostURL(grover_client),'/tidyup?',
                               'auth=',auth(grover_client),
                               '&instrument=',instrument,
                               '&directory=',directory
              )
              tidycmd %>% PUT()
              success <- converted_file_path
            } else {
              success <- NA
            }
            if (!is.na(success)) {
              message('\r',
                      file,
                      ' ',
                      crayon::green(cli::symbol$tick),
                      '\n',
                      sep = '')
            } else {
              message('\r',
                      file,
                      ' ',
                      crayon::red(cli::symbol$cross),
                      '\n',
                      sep = '')
            }
            
            return(success)
          })

#' @rdname convert
#' @importFrom purrr map_chr
#' @export

setMethod('convertDirectory',signature = 'GroverClient',
          function(grover_client, 
                   instrument, 
                   directory, 
                   args = '', 
                   outDir = '.',
                   zip = TRUE,
                   overwrite = FALSE,
                   exclude = character()){
            
            outDir <- str_c(outDir,directory,sep = '/')
            
            if (!dir.exists(outDir)) {
              dir_create(outDir) 
            }
            
            local_files <- list.files(
              outDir,
              pattern = '.mzML'
            )
            
            raw_files <- listRawFiles(grover_client,instrument,directory)
            
            raw_files <- raw_files[exclude %>% 
                                     map(
                                       ~!grepl(.x,raw_files)) %>% 
                                     setNames(seq_along(.)) %>% 
                                     as_tibble() %>% 
                                     split(1:nrow(.)) %>% 
                                     map_lgl(all)] %>% 
              na.omit()
            
            if (isFALSE(overwrite)){
              files <- raw_files[!(file_path_sans_ext(raw_files) %in% 
                                     file_path_sans_ext(local_files,compression = zip))] 
            } else {
              files <- raw_files
            }
            
            message('\nConverting ',
                    bold(yellow(length(files))),
                    ' .raw files from directory ',
                    bold(blue(directory)),
                    '\n')
            
            pb <- progress_bar$new(
              format = "[:bar] :percent eta: :eta",
              total = length(files), clear = FALSE)
            pb$tick(0)
            
            results <- map_chr(seq_len(length(files)),~{
              file <- files[.]
              suppressMessages({
                res <- convertFile(grover_client,
                                   instrument,
                                   directory,
                                   file,
                                   args,
                                   outDir,
                                   zip,
                                   overwrite)
              })
              pb$tick()
              return(res)
            })
            
            message()
            
            failed <- files[is.na(results)]
            
            if (length(failed) > 0) {
              warning(str_c('Unable to convert files: ',
                            str_c(failed,collapse = ', ')),call. = FALSE)
            }
            
            return(results)
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
                   outDir = '.',
                   zip = TRUE){
            
            outDir <- str_c(outDir,directory,sep = '/')
            dir_create(outDir)
            
            message('\n',red('Negative Mode'),sep = '')
            
            negArgs <- c(args,conversionArgsNegativeMode())
            
            convertDirectory(grover_client,
                             instrument,
                             directory,
                             negArgs,
                             outDir,
                             zip)
            
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
  'peakPicking true 1-'
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
