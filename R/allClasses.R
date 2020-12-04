#' GroverClient class
#' @description A simple S4 class containing grover API host information for client-side use.
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

#' GroverHost class
#' @description A simple S4 class containing host information for configuring a grover API.
#' @slot host host address
#' @slot port port on which the API is hosted
#' @slot auth authentication key
#' @slot repository directory path to the raw mass spectrometry data repository
#' @details This class inherits from the GroverClient class so GroverClient accessor methods are applicable.
#' @export

setClass('GroverHost',
         slots = list(
           repository = 'character'
         ),contains = 'GroverClient')
