#' msconvert
#' @description Convert vender mass spectrometry file formats using msconvert
#' @param file file to convert
#' @param outPath output directory path
#' @param args arguments to pass to msconvert
#' @param verbose should output be printed to the console
#' @importFrom stringr str_c
#' @export

msconvert <- function(file, outPath = '.', args= '', verbose = T){
  cmd <- str_c('msconvert',file,'-o',outPath,args,sep = ' ')
  if (verbose == T) {
    cat(str_c('\n[',Sys.time(),']'),cmd,'\n')
  }
  system(cmd,intern = T)
}
