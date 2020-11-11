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

#' @rdname extant

setGeneric('extant',function(grover_client){
  standardGeneric('extant')
})

#' @rdname listInstruments

setGeneric('listInstruments',function(grover_client){
  standardGeneric('listInstruments')
})

#' @rdname listDirectories

setGeneric('listDirectories',function(grover_client,instrument){
  standardGeneric('listDirectories')
})

#' @rdname listFiles

setGeneric('listFiles',function(grover_client,instrument,directory){
  standardGeneric('listFiles')
})

#' @rdname listFiles

setGeneric('listRawFiles',function(grover_client,instrument,directory){
  standardGeneric('listRawFiles')
})

#' @rdname convertFile

setGeneric('convertFile',function(grover_client, instrument, directory, file, args='', outDir = '.'){
  standardGeneric('convertFile')
})

#' @rdname convertDirectory

setGeneric('convertDirectory',function(grover_client, instrument, directory, args='', outDir = '.'){
  standardGeneric('convertDirectory')
})

#' @rdname convertDirectorySplitModes

setGeneric('convertDirectorySplitModes',function(grover_client, instrument, directory, args='', outDir = '.'){
  standardGeneric('convertDirectorySplitModes')
})