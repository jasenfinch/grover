
context('host functions')

host_auth <- '1234'
host_repository <- system.file('repository',
                               package = 'grover')
host_temp <- character()

instrument <- 'Thermo-Exactive'
directory <- 'Experiment_1'
sample <- 'QC01.raw'

writeGrover("127.0.0.1",
            8000,
            host_auth,
            host_repository,
            host_temp,
            out = stringr::str_c(tempdir(),
                                 'grover_host.yml',sep = '/'))

test_that('hostExtant works',{
  result <- hostExtant(host_auth)
  expect_equal(result,"I'm still here!")
})

test_that('hostExtant fails',{
  expect_error(hostExtant('incorrect'))
})

test_that('hostConvertFile works',{
  output <- hostConvertFile(host_auth,instrument,directory,sample)
  expect_equal(nchar(output),24979028)
})

test_that('hostConvertFile will error with incorrect auth',{
  expect_error(hostConvertFile('incorrect',instrument,directory,sample))
})

test_that('hostSampleInfo works',{
  sample_info <- hostSampleInfo(host_auth,instrument,directory,sample)
  expect_equal(nchar(sample_info),1131)
})

test_that('hostSampleInfo will error with incorrect auth',{
  expect_error(hostSampleInfo('incorrect',instrument,directory,sample))
})

test_that('hostRunInfo works',{
  run_info <- hostRunInfo(host_auth,instrument,directory)
  expect_equal(nchar(run_info),1131)
})

test_that('hostTidy works',{
  result <- hostTidy(host_auth,'QC01.mzML')
  expect_equal(result,'QC01.mzML')
})

test_that('hostListFiles works',{
  result <- hostListFiles(host_auth,instrument,directory)
  expect_equal(result,'QC01.raw')
})

test_that('hostListFiles errors with incorrect auth',{
  expect_error(hostListFiles('incorrect',instrument,directory))
})

test_that('hostListRawFiles works',{
  result <- hostListRawFiles(host_auth,instrument,directory)
  expect_equal(result,'QC01.raw')
})

test_that('hostListRawFiles errors with incorrect auth',{
  expect_error(hostListRawFiles('incorrect',instrument,directory))
})

test_that('hostListDirectories works',{
  result <- hostListDirectories(host_auth,instrument)
  expect_equal(result,'Experiment_1')
})

test_that('hostListDirectories errors with incorrect auth',{
  expect_error(hostListDirectories('incorrect',instrument))
})

test_that('hostListInstruments works',{
  result <- hostListInstruments(host_auth)
  expect_equal(result,'Thermo-Exactive')
})

test_that('hostListInstruments errors with incorrect auth',{
    expect_error(hostListInstruments('incorrect'))
})

test_that('hostGetFile works',{
  raw_file <- hostGetFile(host_auth,instrument,directory,sample)
  expect_equal(class(raw_file),'raw')
})

test_that('hostGetFile fails with incorrect file specification',{
  expect_error(hostGetFile(host_auth,instrument,directory,'incorrect.raw'))
})

test_that('hostGetFile fails with incorrect auth',{
  expect_error(hostGetFile('incorrect',instrument,directory,sample))
})

test_that('hostFileInfo works',{
  file_info <- hostFileInfo(host_auth,instrument,directory,sample)
  expect_equal(nchar(file_info),140)
})

test_that('hostDirectoryFileInfo works',{
  directory_info <- hostDirectoryFileInfo(host_auth,instrument,directory)
  expect_equal(nchar(directory_info),140)
})

test_that('hostInstrumentFileInfo works',{
  instrument_info <- hostInsturmentFileInfo(host_auth,instrument)
  expect_equal(nchar(instrument_info),140)
})

test_that('hostRepositoryFileInfo works',{
  repository_info <- hostRepositoryFileInfo(host_auth)
  expect_equal(nchar(repository_info),140)
})
