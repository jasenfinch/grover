
context('grover api')

grover_host <- grover(host = "127.0.0.1",
                     port = 8000,
                     auth = "1234",
                     repository = system.file('repository',
                                              package = 'grover'))

grover_client <- grover(host = "127.0.0.1",
                       port = 8000,
                       auth = "1234")

api <- groverAPI(grover_host,background = TRUE)

Sys.sleep(5)

test_that('api is running',{
  expect_true(api$is_alive())
})

test_that('client can detect api',{
  expect_equal(extant(grover_client),"I'm still here!")
})

test_that('instruments can be listed',{
  instrument <- listInstruments(grover_client)
  expect_equal(instrument,'Thermo-Exactive')
})

test_that('directories can be listed',{
  instrument <- listDirectories(grover_client,'Thermo-Exactive')
  expect_equal(instrument,'Experiment_1')
})

test_that('files can be listed',{
  instrument <- listFiles(grover_client,'Thermo-Exactive','Experiment_1')
  expect_equal(instrument,'QC01.raw')
})

test_that('raw files can be listed',{
  instrument <- listRawFiles(grover_client,'Thermo-Exactive','Experiment_1')
  expect_equal(instrument,'QC01.raw')
})

test_that('a file can be converted',{
  out_dir <- tempdir()
  convertFile(grover_client,
              'Thermo-Exactive',
              'Experiment_1',
              'QC01.raw',
              outDir = out_dir)
  expect_true(file.exists(str_c(out_dir,'/QC01.mzML')))
})

api$kill()

test_that('client cannot detect api after it is killed',{
  expect_equal(extant(grover_client),"grover is MIA!")
})
