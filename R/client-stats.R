
fileStatsResults <- function(cmd){
  cmd %>%
    GET() %>%
    content() %>%
    unlist() %>%
    fromJSON() %>%
    as_tibble() %>%
    mutate(size = fs::fs_bytes(size))
}

#' fileInfo
#' @rdname fileInfo
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

#' directoryFileInfo
#' @rdname directoryFileInfo
#' @description Return file information for all files in a given directory using the grover API.
#' @param grover_client S4 object of class GroverClient
#' @param instrument instrument name
#' @param directory directory name
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

#' instrumentFileInfo
#' @rdname instrumentFileInfo
#' @description Return file information for all files in a given instrument directory using the grover API.
#' @param grover_client S4 object of class GroverClient
#' @param instrument instrument name
#' @export

setMethod('instrumentFileInfo',signature = 'GroverClient',
          function(grover_client,instrument){
            cmd <- str_c(hostURL(grover_client),
                         '/instrumentFileInfo?',
                         'auth=',auth(grover_client),
                         '&instrument=',instrument) 
            
            fileStatsResults(cmd)
          })

#' repositoryFileInfo
#' @rdname repositoryFileInfo
#' @description Return file information for all files in the data repository using the grover API.
#' @param grover_client S4 object of class GroverClient
#' @export

setMethod('repositoryFileInfo',signature = 'GroverClient',
          function(grover_client){
            cmd <- str_c(hostURL(grover_client),
                         '/repositoryFileInfo?',
                         'auth=',auth(grover_client)) 
            
            fileStatsResults(cmd)
          })