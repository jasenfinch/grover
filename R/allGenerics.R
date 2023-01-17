#' @rdname GroverClient-accessors

setGeneric('host',function(grover_client){
  standardGeneric('host')
})

#' @rdname GroverClient-accessors

setGeneric('host<-',function(grover_client,value){
  standardGeneric('host<-')
})

#' @rdname GroverClient-accessors

setGeneric('port',function(grover_client){
  standardGeneric('port')
})

#' @rdname GroverClient-accessors

setGeneric('port<-',function(grover_client,value){
  standardGeneric('port<-')
})

#' @rdname GroverClient-accessors

setGeneric('auth',function(grover_client){
  standardGeneric('auth')
})

#' @rdname GroverClient-accessors

setGeneric('auth<-',function(grover_client,value){
  standardGeneric('auth<-')
})

#' @rdname GroverHost-accessors

setGeneric('repository',function(grover_host){
  standardGeneric('repository')
})

#' @rdname GroverHost-accessors

setGeneric('repository<-',function(grover_host,value){
  standardGeneric('repository<-')
})

setGeneric('hostURL',function(grover_client){
  standardGeneric('hostURL')
})

#' @rdname extant

setGeneric('extant',function(grover_client){
  standardGeneric('extant')
})

#' @rdname list

setGeneric('listInstruments',function(grover_client){
  standardGeneric('listInstruments')
})

#' @rdname list

setGeneric('listDirectories',function(grover_client,instrument){
  standardGeneric('listDirectories')
})

#' @rdname list

setGeneric('listFiles',function(grover_client,instrument,directory){
  standardGeneric('listFiles')
})

#' @rdname list

setGeneric('listRawFiles',function(grover_client,instrument,directory){
  standardGeneric('listRawFiles')
})

#' @rdname convert

setGeneric('convertFile',function(grover_client, 
                                  instrument, 
                                  directory, 
                                  file, 
                                  args = '',
                                  outDir = '.',
                                  zip = TRUE,
                                  overwrite = FALSE){
  standardGeneric('convertFile')
})

#' @rdname convert

setGeneric('convertDirectory',function(grover_client, 
                                       instrument, 
                                       directory, 
                                       args = '', 
                                       outDir = '.',
                                       zip = TRUE,
                                       overwrite = FALSE,
                                       exclude = character()){
  standardGeneric('convertDirectory')
})

#' @rdname convert

setGeneric('convertDirectorySplitModes',function(grover_client, 
                                                 instrument, 
                                                 directory, 
                                                 args = '', 
                                                 outDir = '.',
                                                 zip = TRUE){
  standardGeneric('convertDirectorySplitModes')
})

#' @rdname transfer

setGeneric('transferFile',function(grover_client, 
                                   instrument,
                                   directory,
                                   file,
                                   outDir = '.'){
  standardGeneric('transferFile')
})

#' @rdname transfer

setGeneric('transferDirectory',function(grover_client,
                                        instrument,
                                        directory,
                                        outDir = '.'){
  standardGeneric('transferDirectory')
})

#' @rdname info

setGeneric('sampleInfo',function(grover_client,instrument,directory,file){
  standardGeneric('sampleInfo')
})

#' @rdname info

setGeneric('runInfo',function(grover_client,instrument,directory,time_out = 100){
  standardGeneric('runInfo')
})

#' @rdname stats

setGeneric('fileInfo',function(grover_client,instrument,directory,file){
  standardGeneric('fileInfo')
})

#' @rdname stats

setGeneric('directoryFileInfo',function(grover_client,instrument,directory){
  standardGeneric('directoryFileInfo')
})

#' @rdname stats

setGeneric('instrumentFileInfo',function(grover_client,instrument){
  standardGeneric('instrumentFileInfo')
})

#' @rdname stats

setGeneric('repositoryFileInfo',function(grover_client){
  standardGeneric('repositoryFileInfo')
})

