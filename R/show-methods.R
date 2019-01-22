#' show-Grover
#' @description Show method for class S4 Grover.
#' @param object S4 object of class Grover
#' @importFrom crayon blue
#' @importFrom methods show
#' @export

setMethod('show',signature = 'Grover',
          function(object){
            cat(blue('\nGrover Information\n\n'))
            cat('Host:\t\t',host(object),'\n')
            cat('Port:\t\t',port(object),'\n')
            cat('Authentication:\t',auth(object),'\n')
            cat('\n')
          }
)

#' #' show-Repository
#' #' @export
#' 
#' setMethod('show',signature = 'Repository',
#'           function(object){
#'             cat(blue('\nRepository\n\n'))
#'             cat('Path:\t\t',path(object),'\n')
#'             cat('Extensions:\t',extensions(object) %>% str_c(collapse = ' '),'\n')
#'             cat('\n')
#'           }
#' )