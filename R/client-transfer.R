#' transferFile
#' @rdname transferFile
#' @description Transfer a file using the grover API.
#' @param grover_client S4 object of class GroverClient
#' @param instrument instrument name
#' @param directory directory name
#' @param file file name
#' @param outDir output directory path for transferred file
#' @export

setMethod('transferFile',signature = 'GroverClient',
          function(grover_client,
                   instrument,
                   directory,
                   file,
                   outDir = '.'){
            
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

#' transferDirectory
#' @rdname transferDirectory
#' @description Transfer a directory using the grover API.
#' @param grover_client S4 object of class GroverClient
#' @param instrument instrument name
#' @param directory directory name
#' @param outDir output directory path for converted files
#' @export

setMethod('transferDirectory',signature = 'GroverClient',
          function(grover_client, instrument, directory, outDir = '.'){
            
            outDir <- str_c(outDir,directory,sep = '/')
            
            files <- listFiles(grover_client,instrument,directory)
            
            message('\nTransfering ',
                    bold(blue(directory)),
                    ' containing ',
                    bold(yellow(length(files))),
                    ' files\n')
            
            dir_create(outDir)
            
            pb <- progress_bar$new(
              format = "[:bar] :percent eta: :eta",
              total = length(files), clear = FALSE)
            pb$tick(0)
            
            results <- map(seq_len(length(files)),~{
              suppressMessages({
                res <- transferFile(grover_client,
                                    instrument,
                                    directory,
                                    files[.x],
                                    outDir)
              })
              pb$tick()
              Sys.sleep(2)
              return(res)
            })
            
            message()
            
            results <- files[str_detect(results,'failure')]
            
            if (length(results) > 0) {
              warning(str_c('Unable to transfer files: ',
                            str_c(results,collapse = ', ')),call. = FALSE)
            }
          })
