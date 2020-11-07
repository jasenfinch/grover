#' Grover
#' @rdname Grover
#' @description A simple S4 class containing grover API host information
#' @slot host host address
#' @slot port port on which the API is hosted
#' @slot auth authentication key
#' @export

setClass('GroverClient',
         slots = list(
           host = 'character',
           port = 'numeric',
           auth = 'character'
         )
)

#' @rdname Grover
#' @export

setClass('GroverHost',
         slots = list(
           repository = 'character'
         ),contains = 'GroverClient')