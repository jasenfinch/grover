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
                unlist(recursive = FALSE) %>%
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
  sample_info <- map(1:length(files), ~{
    file <- files[.]
    info <- sampleInfo(grover_client,instrument,directory,file) %>%
      select(-fileOrder)
    pb$tick()
    return(info)
  }) %>%
    bind_rows(.id = 'fileOrder') %>%
    mutate(fileOrder = as.numeric(fileOrder))
  
  if (detectOldSampleInfo(sample_info)) {
    sample_info <- sample_info %>%
      rename(injOrder = sample_order,
             sample_order = name,
             name = class,
             class = injOrder)
  }
  sample_info <- sample_info %>%
    mutate(injOrder = creationToinjectionOrder(creation_date))
})


#' @importFrom stringr str_replace_all str_split_fixed 
#' @importFrom tibble rowid_to_column 
#' @importFrom dplyr arrange
#' @importFrom lubridate dmy
#' @importFrom magrittr set_colnames

creationToinjectionOrder <- function(creation_date){
  creation_date %>%
    str_replace_all('/','-') %>%
    str_split_fixed(' ',2) %>%
    as_tibble(.name_repair = 'minimal') %>%
    set_colnames(c('Date','Time')) %>%
    rowid_to_column(var = 'Sample') %>%
    mutate(Date = dmy(Date),Time = Time) %>%
    arrange(Date,Time) %>%
    rowid_to_column(var = 'injOrder') %>%
    arrange(Sample) %>%
    .$injOrder
}

detectOldSampleInfo <- function(sample_info){
  sn <- sample_info$name[1] == 'NA'
  cl <- {sample_info$class %>% unique() %>% length()} == nrow(sample_info)
  io <- suppressWarnings(is.na(as.numeric(sample_info$injOrder[1])))
  
  sn & cl & io
}