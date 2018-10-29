
denied <- function(){
  stop('Incorrect authentication key')
}

#' @importFrom plumber plumber
#' @export
groverAPI <- function(grove,repository,tmp){
  api <- plumber$new()
  
  api$handle('GET','/extant',function(auth){
    key <- auth(grove)
    if (auth == key) {
      "I'm still here!"
    } else {
      denied()
    }
  })
  
  
  api$run(port = port(grove),host = host(grove))
}
