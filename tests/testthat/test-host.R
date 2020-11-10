
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

test_that('hostExtant fails',{
  expect_error(hostExtant('incorrect'))
})

test_that('hostConvertFile works',{
  output_path <- hostConvertFile(host_auth,instrument,directory,sample)
  expect_equal(basename(output_path),'QC01.mzML')
})

test_that('hostConvertFile fails',{
  expect_error(hostConvertFile('incorrect',instrument,directory,sample))
})

test_that('hostSampleInfo works',{
  sample_info <- hostSampleInfo(host_auth,instrument,directory,sample)
  expect_equal(nchar(sample_info),597)
})

test_that('hostSampleInfo fails',{
  expect_error(hostSampleInfo('incorrect',instrument,directory,sample))
})

test_that('hostTidy works',{
  result <- hostTidy(host_auth,'QC01.mzML')
  expect_equal(result,0)
})

test_that('hostTidy fails',{
  expect_error(hostTidy('incorrect','QC01.mzML'))
})

test_that('hostListFiles works',{
  result <- hostListFiles(host_auth,instrument,directory)
  expect_equal(result,'QC01.raw')
})

test_that('hostListFiles fails',{
  expect_error(hostListFiles('incorrect',instrument,directory))
})

test_that('hostListRawFiles works',{
  result <- hostListRawFiles(host_auth,instrument,directory)
  expect_equal(result,'QC01.raw')
})

test_that('hostListRawFiles fails',{
  expect_error(hostListRawFiles('incorrect',instrument,directory))
})

test_that('hostListDirectories works',{
  result <- hostListDirectories(host_auth,instrument)
  expect_equal(result,'Experiment_1')
})

test_that('hostListDirectories fails',{
  expect_error(hostListDirectories('incorrect',instrument))
})

test_that('hostListInstruments works',{
  result <- hostListInstruments(host_auth)
  expect_equal(result,'Thermo-Exactive')
})

test_that('hostListInstruments fails',{
  expect_error(hostListInstruments('incorrect'))
})

test_that('hostGetFile works',{
  raw_file <- hostGetFile(host_auth,instrument,directory,sample)
  expect_equal(class(raw_file),'raw')
})

test_that('hostGetFile authentication fails',{
  expect_error(hostGetFile('incorrect',instrument,directory,sample))
})

test_that('hostGetFile fails with incorrect file specification',{
  expect_error(hostGetFile(host_auth,instrument,directory,'incorrect.raw'))
})
