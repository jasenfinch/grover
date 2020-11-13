
fileSampleInfo <- function(path,directory){
  sample_info <- readFileHeader(path,
                                exe = system.file('exec/rawR.exe',
                                                  package = 'rawR')) %>%
    as_tibble() %>%
    slice(1) %>%
    mutate(directory = directory)
  
  scan_filters <- readIndex(path) %>%
    .$scanType %>%
    unique() %>%
    str_c(collapse = ';;;')
  
  sample_info <- sample_info %>%
    mutate(`Scan filters` = scan_filters)
  
  return(sample_info)
}

#' @importFrom rawR readFileHeader readIndex
#' @importFrom dplyr slice mutate select
#' @importFrom rjson toJSON
#' @importFrom tibble as_tibble

hostSampleInfo <- function(auth,instrument,directory,file){
  
  grover_host <- readGrover(groverHostTemp())
  host_auth <- auth(grover_host)
  host_repository <- repository(grover_host)
  
  checkAuth(auth,host_auth)
  
  path <- str_c(host_repository,instrument,directory,file,sep = '/')
  
  sample_info <- path %>%
    fileSampleInfo(directory) %>%
    toJSON()
  
  return(sample_info)
}

hostRunInfo <- function(auth,instrument,directory){
  grover_host <- readGrover(groverHostTemp())
  host_auth <- auth(grover_host)
  host_repository <- repository(grover_host)
  
  checkAuth(auth,host_auth)
  
  raw_files <- dir_ls(str_c(host_repository,
                            instrument,
                            directory,
                            sep = '/'),
                      type = 'file',
                      recurse = FALSE) %>%
    {
      . <- .[str_detect(.,
                        regex('[.]raw',ignore_case = TRUE))]
      return(.)
    }
  
  run_info <- raw_files %>%
    map(fileSampleInfo,directory = directory) %>%
    bind_rows() %>%
    toJSON()
  
  return(run_info)
}
