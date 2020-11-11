#' sampleInfo
#' @rdname sampleInfo
#' @description get sample header information for a given raw file using the grover API.
#' @param grover_client S4 object of class GroverClient
#' @param instrument instrument name
#' @param directory directory name
#' @param file file name
#' @importFrom rjson fromJSON
#' @export

setMethod('sampleInfo',signature = 'GroverClient',
          function(grover_client, instrument, directory, file){
            
            cat('\n',file,' ',cli::symbol$continue,'\r',sep = '')
            
            cmd <- str_c(hostURL(grover_client), "/sampleInfo?", "auth=",
                         auth(grover_client), "&instrument=", instrument, "&directory=", directory,
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
              cat('\r',file,' ',crayon::green(cli::symbol$tick),'\n',sep = '')
            }
            if (success == 0) {
              cat('\r',file,' ',crayon::red(cli::symbol$cross),'\n',sep = '')
            }
            return(info)
          })

#' runInfo
#' @rdname runInfo
#' @description Get sample meta information for a directory run using the grover API.
#' @param grove S4 object of class Grover
#' @param instrument instrument name
#' @param directory directory name
#' @importFrom dplyr bind_rows rename
#' @importFrom purrr map
#' @export

setMethod('runInfo',signature = 'GroverClient',
          function(grover_client, instrument, directory) {
            files <- listRawFiles(grover_client, instrument, directory)
            
            cat('\nGenrating run info table for',bold(blue(directory)),'containing',bold(yellow(length(files))),'.raw files\n')
            
            pb <- progress_bar$new(
              format = "  retrieving [:bar] :percent eta: :eta",
              total = length(files), clear = FALSE)
            pb$tick(0)
            sample_info <- files %>%
              map(~{
                info <- sampleInfo(grover_client,instrument,directory,.x)
                pb$tick()
                return(info)
              }) %>%
              bind_rows()
            
            return(sample_info)
          })

