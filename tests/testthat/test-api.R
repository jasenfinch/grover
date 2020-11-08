
context('grover api')

grover_host <- grover(host = "127.0.0.1",
                     port = 8000,
                     auth = "1234",
                     repository = system.file('repository',
                                              package = 'grover'))

grover_client <- grover(host = "127.0.0.1",
                       port = 8000,
                       auth = "1234")

api <- callr::r_bg(function(grover_host){
  grover::groverAPI(grover_host)
},args = list(grover_host = grover_host),package = TRUE)


test_that('api is running',{
  expect_true(api$is_alive())
})

test_that('client can detect api',{
  expect_equal(extant(grover_client),"I'm still here")
})

api$kill()
