#' @importFrom fs fs_bytes

fileStatsResults <- function(cmd){
  res <- cmd %>%
    GET()
  
  if (res$status_code == 200){
    res <- content() %>%
      unlist() %>%
      fromJSON() %>%
      as_tibble() %>%
      mutate(size = fs_bytes(size))
  } else {
    stop(str_c('Failed to retrieve with status code', 
               res$status_code),call. = FALSE) 
  }
    
  return(res)
}

#' Retrieve file information
#' @rdname stats
#' @description Return file information for a given file using the grover API.
#' @param grover_client S4 object of class GroverClient
#' @param instrument instrument name
#' @param directory directory name
#' @param file file name
#' @export

setMethod('fileInfo',signature = 'GroverClient',
          function(grover_client,instrument,directory,file){
            cmd <- str_c(hostURL(grover_client),
                         '/fileInfo?',
                         'auth=',auth(grover_client),
                         '&instrument=',instrument,
                         '&directory=',directory,
                         '&file=',file) 
            
            fileStatsResults(cmd)
          })

#' @rdname stats
#' @export

setMethod('directoryFileInfo',signature = 'GroverClient',
          function(grover_client,instrument,directory){
            cmd <- str_c(hostURL(grover_client),
                         '/directoryFileInfo?',
                         'auth=',auth(grover_client),
                         '&instrument=',instrument,
                         '&directory=',directory) 
            
            fileStatsResults(cmd)
          })

#' @rdname stats
#' @export

setMethod('instrumentFileInfo',signature = 'GroverClient',
          function(grover_client,instrument){
            cmd <- str_c(hostURL(grover_client),
                         '/instrumentFileInfo?',
                         'auth=',auth(grover_client),
                         '&instrument=',instrument) 
            
            fileStatsResults(cmd)
          })

#' @rdname stats
#' @export

setMethod('repositoryFileInfo',signature = 'GroverClient',
          function(grover_client){
            cmd <- str_c(hostURL(grover_client),
                         '/repositoryFileInfo?',
                         'auth=',auth(grover_client)) 
            
            fileStatsResults(cmd)
          })
