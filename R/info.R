#' @importFrom stringr coll

getFilename <- function(x){
  y <- str_split(x,coll('\\'))[[1]]
  y <- y[length(y)]
  return(y)
}

#' sampleInfo
#' @description get sample information for a given file using the grover API.
#' @param grove S4 object of class Grover
#' @param instrument instrument name
#' @param directory directory name
#' @param file file name
#' @importFrom tibble as_tibble
#' @importFrom rjson fromJSON
#' @importFrom dplyr mutate select rename
#' @importFrom tibble rowid_to_column
#' @export

sampleInfo <- function(grove, instrument, directory, file){
  cat('\n',file,' ',cli::symbol$continue,'\r',sep = '')
  cmd <- str_c(host(grove), ":", port(grove), "/sampleInfo?", "authKey=", 
               auth(grove), "&instrument=", instrument, "&directory=", directory, 
               "&file=", file)
  
  filters <- sampleScanFilters(grove, instrument, directory, file)
  
  info <- cmd %>% 
    GET() 
  
  if (info$status_code == 200) {
    info <- info %>% 
      content() %>% 
      unlist() %>%
      fromJSON() %>% 
      unlist(recursive = F) %>%
      as_tibble() %>%
      mutate(scan_filters = filters)
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
}

#' sampleScanFilters
#' @description get sample scan filters for a given file using the grover API.
#' @param grove S4 object of class Grover
#' @param instrument instrument name
#' @param directory directory name
#' @param file file name
#' @importFrom tibble as_tibble
#' @importFrom rjson fromJSON
#' @importFrom dplyr mutate select rename
#' @importFrom tibble rowid_to_column
#' @export

sampleScanFilters <- function(grove, instrument, directory, file){
  cmd <- str_c(host(grove), ":", port(grove), "/sampleScanFilters?", "authKey=", 
               auth(grove), "&instrument=", instrument, "&directory=", directory, 
               "&file=", file)
  cmd %>% 
    GET() %>% 
    content() %>% 
    unlist() %>%
    fromJSON() %>%
    unlist(recursive = F) %>%
    str_c(collapse = ';;;')
}

#' runInfo
#' @description get sample information for an instrument run using the grover API and create runinfo table.
#' @param grove S4 object of class Grover
#' @param instrument instrument name
#' @param directory directory name
#' @importFrom dplyr bind_rows arrange rowwise
#' @importFrom purrr map
#' @export

runInfo <- function(grove, instrument, directory) {
  files <- listRawFiles(grove, instrument, directory)
  
  cat('\nGenrating run info table for',bold(blue(directory)),'containing',bold(yellow(length(files))),'.raw files\n')
  
  pb <- progress_bar$new(
    format = "  retrieving [:bar] :percent eta: :eta",
    total = length(files), clear = FALSE)
  pb$tick(0)
  i <- map(1:length(files), ~{
    file <- files[.]
    info <- sampleInfo(grove,instrument,directory,file)
    pb$tick()
    return(info)
  })
  
  i <- i[!sapply(i,is.null)] %>%
    bind_rows()
  
  if (detectOldSampleInfo(i)) {
    i <- i %>%
      rename(inj_order = sample_order,
             sample_order = sample_name,
             sample_name = class,
             class = inj_order)
  }
  i %>%
    mutate(inj_order = creationToinjectionOrder(creation_date)) %>%
    rowwise() %>%
    mutate(file_name = getFilename(file_name),
           instrument_method = str_split(getFilename(instrument_method),"[.]")[[1]][1], 
           directory = getFilename(path),
           inj_vol = inj_vol %>% as.numeric(),
           sample_wt = sample_wt %>% as.numeric(),
           sample_vol = sample_vol %>% as.numeric(),
           istd_amount = sample_vol %>% as.numeric(),
           dilution = dilution %>% as.numeric()
    ) %>%
    rename(fileName = file_name,
           injOrder = inj_order,
           name = sample_name
    ) %>%
    arrange(fileName) %>%
    rowid_to_column(var = "fileOrder") %>%
    mutate(fileName = str_replace_all(fileName,'raw','mzML'))
}

#' @importFrom lubridate dmy 
#' @importFrom stringr str_replace_all str_split_fixed

creationToinjectionOrder <- function(creation_date){
  creation_date %>%
    str_replace_all('/','-') %>%
    str_split_fixed(' ',2) %>%
    as_tibble() %>%
    rename(Date = V1,Time = V2) %>%
    rowid_to_column(var = 'Sample') %>%
    mutate(Date = dmy(Date),Time = Time) %>%
    arrange(Date,Time) %>%
    rowid_to_column(var = 'injOrder') %>%
    arrange(Sample) %>%
    .$injOrder
}

detectOldSampleInfo <- function(info){
  sn <- info$sample_name[1] == 'NA'
  cl <- {info$class %>% unique() %>% length()} == nrow(info)
  io <- suppressWarnings(is.na(as.numeric(info$inj_order[1])))
  
  sn & cl & io
}