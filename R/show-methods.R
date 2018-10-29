#' show-Grover
#' @importFrom crayon blue
#' @export

setMethod('show',signature = 'Grover',
          function(object){
            cat(blue('\nGrover Information\n\n'))
            cat('Host:\t\t',host(object),'\n')
            cat('Port:\t\t',port(object),'\n')
            cat('Authentication:\t',auth(object),'\n\n')
          }
)