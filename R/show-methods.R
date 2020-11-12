#' show-Grover
#' @rdname show-Grover
#' @description Show method for class S4 Grover.
#' @param object S4 object of class Grover
#' @importFrom crayon blue
#' @importFrom methods show
#' @export

setMethod('show',signature = 'GroverClient',
          function(object){
            cat(blue('\nGrover Information\n\n'))
            cat('Host:\t\t',host(object),'\n')
            cat('Port:\t\t',port(object),'\n')
            cat('Authentication:\t',auth(object),'\n')
            cat('\n')
          }
)

#' @rdname show-Grover
#' @export

setMethod('show',signature = 'GroverHost',
          function(object){
            cat(blue('\nGrover Information\n\n'))
            cat('Host:\t\t',host(object),'\n')
            cat('Port:\t\t',port(object),'\n')
            cat('Authentication:\t',auth(object),'\n')
            cat('Repository:\t',repository(object),'\n')
            cat('\n')
          }
)
