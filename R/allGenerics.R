#' @rdname host

setGeneric('host',function(grove){
  standardGeneric('host')
})

#' @rdname host

setGeneric('host<-',function(grove,value){
  standardGeneric('host<-')
})

#' @rdname port

setGeneric('port',function(grove){
  standardGeneric('port')
})

#' @rdname port

setGeneric('port<-',function(grove,value){
  standardGeneric('port<-')
})

#' @rdname auth

setGeneric('auth',function(grove){
  standardGeneric('auth')
})

#' @rdname auth

setGeneric('auth<-',function(grove,value){
  standardGeneric('auth<-')
})

#' @rdname repository

setGeneric('repository',function(grove){
  standardGeneric('repository')
})

#' @rdname repository

setGeneric('repository<-',function(grove,value){
  standardGeneric('repository<-')
})

setGeneric('hostURL',function(grove){
  standardGeneric('hostURL')
})

setGeneric('writeGrover',function(grover_host,out = 'grover_host.yml'){
  standardGeneric('writeGrover')
})

setGeneric('extant',function(grover_client){
  standardGeneric('extant')
})

