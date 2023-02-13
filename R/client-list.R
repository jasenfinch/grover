#' List raw data repository contents
#' @rdname list
#' @description List available instruments, experiment directories or samples using a grover API.
#' @param grover_client S4 object of class GroverClient
#' @param instrument instrument name
#' @param directory directory name
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
              unlist() %>% 
              sort()
          })

#' @rdname list
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
              unlist() %>% 
              sort()
          })

#' @rdname list
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
              unlist() %>% 
              sort()
          })

#' @rdname list
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
              unlist() %>% 
              sort()
          })
