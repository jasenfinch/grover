
context('Grover class methods')

test_that('grover constructors and accessors work',{
  grover_example <- system.file('example_grover.yml',package = 'grover')
  grove <- readGrover(grover_example)
  
  host(grove) <- 'localhost'
  port(grove) <- 8000
  auth(grove) <- '1234'
  h <- host(grove)
  p <- port(grove)
  a <- auth(grove)
  
  expect_s4_class(grove,'Grover')
  expect_equal(h,'localhost')
  expect_equal(p,8000)
  expect_equal(a,'1234')
})

test_that('host URL constructed correclty',{
  grove <- grover('localhost',8000,'1234')
  url <- hostURL(grove)
  
  grove_80 <- grover('localhost',80,'1234')
  url_80 <- hostURL(grove_80)
  
  expect_equal(url,'http://localhost:8000')
  expect_equal(url_80,'http://localhost')
})