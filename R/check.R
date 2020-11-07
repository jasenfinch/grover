#' checkGrover
#' @description Check grover API is active.
#' @param grove S4 object of class Grover
#' @importFrom stringr str_c
#' @export

checkGrover <- function(grove){
  cmd <- str_c(hostURL(grove),'/extant?','authKey=',auth(grove))
  answer <- try({cmd %>%
      GET() %>%
      content() %>%
      unlist()},silent = T)
  if (answer != "I'm still here!") {
    answer <- 'grover is MIA!'
  }
  return(answer)
}

checkMSconvert <- function(out = c('error','warning')){
  result <- Sys.which('msconvert')
  
  if (result == "") {
    if (out == 'error') {
      stop(msconvertWarning(),call. = FALSE)  
    }
    if (out == 'warning') {
      warning(msconvertWarning(),call. = FALSE)
    }
  }
}

msconvertWarning <- function(){
'
The system program msconvert has not been found. Mass spectrometry raw file conversion functionality will be unavailable. msconvert is part of the ProteoWizard software suite which can be downloaded from:
  
http://proteowizard.sourceforge.net/download.html

Platform dependent installation instructions are available from:

http://proteowizard.sourceforge.net/doc_users.html

Ensure that the msconvert program is executable from the commandline.
'
}