
context('host functions')

host_auth <<- '1234'
host_repository <<- system.file('repository',
                               package = 'grover')
instrument <- 'Thermo-Exactive'
directory <- 'Experiment_1'
sample <- 'QC01.raw'

test_that('hostExtant works',{
  result <- hostExtant(host_auth)
  expect_equal(result,"I'm still here!")
})

test_that('hostConvertFile works',{
  output_path <- hostConvertFile(host_auth,instrument,directory,sample)
  expect_equal(basename(output_path),'QC01.mzML')
})

test_that('hostSampleInfo works',{
  sample_info <- hostSampleInfo(host_auth,instrument,directory,sample)
  expect_equal(nchar(sample_info),597)
})

test_that('hostTidy works',{
  result <- hostTidy(host_auth,instrument,directory)
  expect_equal(result,0)
})

test_that('hostListFiles works',{
  result <- hostListFiles(host_auth,instrument,directory)
  expect_equal(result,'QC01.raw')
})

test_that('hostListRawFiles works',{
  result <- hostListRawFiles(host_auth,instrument,directory)
  expect_equal(result,'QC01.raw')
})

test_that('hostListDirectories works',{
  result <- hostListDirectories(host_auth,instrument)
  expect_equal(result,'Experiment_1')
})

test_that('hostListInstruments works',{
  result <- hostListInstruments(host_auth)
  expect_equal(result,'Thermo-Exactive')
})

test_that('hostGetFile works',{
  raw_file <- hostGetFile(host_auth,instrument,directory,sample)
  expect_equal(class(raw_file),'raw')
})