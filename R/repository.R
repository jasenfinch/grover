#' #' @export
#' 
#' repository <- function(repoPath,extensions = '.raw'){
#'   new('Repository',
#'       path = repoPath %>%
#'         path.expand(),
#'       files = list.files(repoPath, recursive = TRUE,no.. = TRUE, include.dirs = TRUE,full.names = TRUE),
#'       extensions = extensions)
#' }
#' 
#' setMethod('path',signature = 'Repository',
#'           function(repo){
#'             repo@path
#'           })
#' 
#' setMethod('extensions',signature = 'Repository',
#'           function(repo){
#'             repo@extensions
#'           }
#' )

# setMethod('dataDirectories',signature = 'Repository',
#           function(repo,level = NULL){
#             level <- str_c(path(repo),level,sep = '/')
#             files <- repo@files %>%
#               {.[str_detect(.,level)]} 
#           })