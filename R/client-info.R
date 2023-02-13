#' Retrieve sample raw file header information
#' @rdname info
#' @description Get sample header information for a given raw file or directory using 
#' a grover API.
#' @param grover_client S4 object of class GroverClient
#' @param instrument instrument name
#' @param directory directory name
#' @param file file name
#' @param exclude A character vector of regular expression patterns for which the information matching files will not be retrieved.
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
#' @importFrom purrr map map_dfr
#' @importFrom httr timeout
#' @export

setMethod('runInfo',signature = 'GroverClient',
          function(grover_client, instrument, directory,exclude = character()) {
            files <- listRawFiles(grover_client, instrument, directory)
            
            files <- files[exclude %>% 
                             map(
                               ~!grepl(.x,files)) %>% 
                             setNames(seq_along(.)) %>% 
                             as_tibble() %>% 
                             split(1:nrow(.)) %>% 
                             map_lgl(all)] %>% 
              na.omit()
            
            message('\nGenrating run info table for ',
                    bold(blue(directory)),
                    ' containing ',
                    bold(yellow(length(files))),
                    ' .raw files\n')
            
            pb <- progress_bar$new(
              format = "[:bar] :percent eta: :eta",
              total = length(files), clear = FALSE)
            pb$tick(0)
            
            run_info <- files %>% 
              map_dfr(~{
                suppressMessages({
                  sample_info <- sampleInfo(
                    grover_client = grover_client,
                    instrument = instrument,
                    directory = directory,
                    file = .x)
                })
                
                pb$tick()
                
                return(sample_info)
              })
            
            failed <- files[!(files %in% run_info$`RAW file`)]
            
            if (length(failed) > 0) {
              warning(str_c('Unable to retrieve information for files: ',
                            str_c(failed,collapse = ', ')),call. = FALSE)
            }
            
            return(run_info)
          })

