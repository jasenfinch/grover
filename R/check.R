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