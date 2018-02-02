## Place grover.txt file in the home directory containing the IP, port on which to host the server and authentication key.

library(plumber)

r <- plumb('api.R')

details <- readLines('~/grover.txt')

r$run(port = as.numeric(details[2]),host = details[1])
