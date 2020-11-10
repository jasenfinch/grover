# 
# context('grover api')
# 
# grover_host <- grover(host = "127.0.0.1",
#                      port = 8000,
#                      auth = "1234",
#                      repository = system.file('repository',
#                                               package = 'grover'))
# 
# grover_client <- grover(host = "127.0.0.1",
#                        port = 8000,
#                        auth = "1234")
# 
# api <- callr::r_bg(function(groverAPI,grover_host){
#   host_auth <<- auth(grover_host)
#   host_repository <<- repository(grover_host)
#   groverAPI(grover_host)
# },args = list(groverAPI = groverAPI,
#               grover_host = grover_host))
# 
# 
# test_that('api is running',{
#   expect_true(api$is_alive())
# })
# 
# test_that('client can detect api',{
#   expect_equal(extant(grover_client),"I'm still here!")
# })
# 
# api$kill()
