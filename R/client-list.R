#' listInstruments
#' @description List available instruments using the grover API.
#' @param grover_client S4 object of class GroverClient
#' @export

setMethod('listInstruments',signature = 'GroverClient',
          function(grover_client){
            cmd <- str_c(hostURL(grover_client),
                         '/listInstruments?',
                         'auth=',
                         auth(grover_client))
            cmd %>%
              GET() %>%
              content() %>%
              unlist()
          })

#' listDirectories
#' @description List all directories for a given instrument using the grover API.
#' @param grove S4 object of class Grover
#' @param instrument instrument name
#' @export

setMethod('listDirectories',signature = 'GroverClient',
          function(grover_client,instrument){
            cmd <- str_c(hostURL(grover_client),
                         '/listDirectories?',
                         'auth=',
                         auth(grover_client),
                         '&instrument=',
                         instrument)
            cmd %>%
              GET() %>%
              content() %>%
              unlist()
          })

#' listFiles
#' @description List all files present in a given directory using the grover API.
#' @param grove S4 object of class Grover
#' @param instrument instrument name
#' @param directory directory name
#' @export

setMethod('listFiles',signature = 'GroverClient',
          function(grover_client,instrument,directory){
            cmd <- str_c(hostURL(grover_client),
                         '/listFiles?',
                         'auth=',
                         auth(grover_client),
                         '&instrument=',
                         instrument,
                         '&directory=',
                         directory)
            cmd %>%
              GET() %>%
              content() %>%
              unlist()
          })

#' listRawFiles
#' @description List all raw files present in a given directory using the grover API.
#' @param grove S4 object of class Grover
#' @param instrument instrument name
#' @param directory directory name
#' @export

setMethod('listRawFiles',signature = 'GroverClient',
          function(grover_client,instrument,directory){
            cmd <- str_c(hostURL(grover_client),
                         '/listRawFiles?',
                         'auth=',
                         auth(grover_client),
                         '&instrument=',
                         instrument,
                         '&directory=',
                         directory)
            cmd %>%
              GET() %>%
              content() %>%
              unlist()
          })