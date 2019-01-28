#' Grover
#' @rdname Grover-class
#' @description A simple S4 class containing grover API host information
#' @slot host host address
#' @slot port port on which the API is hosted
#' @slot auth authentication key
#' @export

setClass('Grover',
         slots = list(
           host = 'character',
           port = 'numeric',
           auth = 'character'
         )
)

setClass('Repository',
         slots = list(
           path = 'character',
           files = 'character',
           extensions = 'character'
         ))