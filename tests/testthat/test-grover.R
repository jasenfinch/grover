
context('Grover class methods')

test_that('grover constructors and accessors work',{
  grover_client <- system.file('grover_client.yml',package = 'grover')
  grove_client <- readGrover(grover_client)
  
  grove_host <- system.file('grover_host.yml',package = 'grover')
  grove_host <- readGrover(grove_host)
  
  host(grove_client) <- 'localhost'
  port(grove_client) <- 8000
  auth(grove_client) <- '1234'
  repository(grove_host) <- './data'
  h <- host(grove_client)
  p <- port(grove_client)
  a <- auth(grove_client)
  r <- repository(grove_host)
  
  expect_s4_class(grove_client,'GroverClient')
  expect_equal(h,'localhost')
  expect_equal(p,8000)
  expect_equal(a,'1234')
  expect_equal(r,'./data')
})

test_that('host URL constructed correclty',{
  grove <- grover('localhost',8000,'1234')
  url <- hostURL(grove)
  
  grove_80 <- grover('localhost',80,'1234')
  url_80 <- hostURL(grove_80)
  
  expect_equal(url,'http://localhost:8000')
  expect_equal(url_80,'http://localhost')
})