#' Retrieve sample raw file header information
#' @rdname info
#' @description Get sample header information for a given raw file or directory using 
#' a grover API.
#' @param grover_client S4 object of class GroverClient
#' @param instrument instrument name
#' @param directory directory name
#' @param file file name
#' @importFrom rjson fromJSON
#' @export

setMethod('sampleInfo',signature = 'GroverClient',
          function(grover_client, instrument, directory, file){
            
            cmd <- str_c(hostURL(grover_client),
                         "/sampleInfo?", 
                         "auth=",auth(grover_client), 
                         "&instrument=",instrument,
                         "&directory=",directory,
                         "&file=", file)
            
            info <- cmd %>%
              GET()
            
            if (info$status_code == 200) {
              info <- info %>%
                content() %>%
                unlist() %>%
                fromJSON() %>%
                as_tibble()
              
              success <- 1
            } else {
              info <- NULL
              
              success <- 0
            }
            
            if (success == 1) {
              message('\r',
                      file,
                      ' ',
                      crayon::green(cli::symbol$tick),
                      '\n',
                      sep = '')
            }
            if (success == 0) {
              message('\r',
                      file,
                      ' ',
                      crayon::red(cli::symbol$cross),
                      '\n',
                      sep = '')
            }
            return(info)
          })

#' @rdname info
#' @importFrom dplyr bind_rows rename
#' @importFrom purrr map
#' @export

setMethod('runInfo',signature = 'GroverClient',
          function(grover_client, instrument, directory) {
            files <- listRawFiles(grover_client, instrument, directory)
            
            message('\nGenrating run info table for ',
                    bold(blue(directory)),
                    ' containing ',
                    bold(yellow(length(files))),
                    ' .raw files\n')
            
            cmd <-  str_c(hostURL(grover_client),
                          "/runInfo?", 
                          "auth=",auth(grover_client), 
                          "&instrument=",instrument,
                          "&directory=",directory)
            
            run_info <- cmd %>%
              GET()
            
            if (run_info$status_code == 200) {
              run_info <- run_info %>%
                content() %>%
                unlist() %>%
                fromJSON() %>%
                as_tibble()
            } else {
             stop(str_c('Failed to retrieve with status code ', 
                        run_info$status_code),call. = FALSE) 
            }
            
            return(run_info)
          })

