
context('grover api')

out_dir <- tempdir()

grover_host <- grover(host = "127.0.0.1",
                     port = 8000,
                     auth = "1234",
                     repository = system.file('repository',
                                              package = 'grover'))

grover_client <- grover(host = "127.0.0.1",
                       port = 8000,
                       auth = "1234")

api <- groverAPI(grover_host,
                 background = TRUE,
                 log_dir = paste0(tempdir(),'/logs'),
                 temp_dir = paste0(tempdir(),'/temp'))

Sys.sleep(8)

test_that('api is running',{
  expect_true(api$is_alive())
})

test_that('client can detect api',{
  expect_true(extant(grover_client))
})

test_that('the api version is returned',{
  expect_equal(version(grover_client),
               packageVersion('grover') %>% 
                 as.character())
})

test_that('instruments can be listed',{
  instrument <- listInstruments(grover_client)
  expect_equal(instrument,'Thermo-Exactive')
})

test_that('directories can be listed',{
  directory <- listDirectories(grover_client,'Thermo-Exactive')
  expect_equal(directory,'Experiment_1')
})

test_that('files can be listed',{
  file <- listFiles(grover_client,'Thermo-Exactive','Experiment_1')
  expect_equal(file,'QC01.raw')
})

test_that('raw files can be listed',{
  instrument <- listRawFiles(grover_client,'Thermo-Exactive','Experiment_1')
  expect_equal(instrument,'QC01.raw')
})

test_that('a file can be converted',{
  converted_file <- convertFile(grover_client,
              'Thermo-Exactive',
              'Experiment_1',
              'QC01.raw',
              outDir = out_dir)
  
  expect_type(converted_file,'character')
  expect_true(file.exists(str_c(out_dir,'/QC01.mzML.gz')))
  unlink(str_c(out_dir,'/QC01.mzML.gz'))
})

test_that('a directory can be converted',{
  convertDirectory(grover_client,
              'Thermo-Exactive',
              'Experiment_1',
              outDir = out_dir)
  expect_true(file.exists(str_c(out_dir,'/Experiment_1/QC01.mzML.gz')))
  unlink(str_c(out_dir,'/Experiment_1'),recursive = TRUE)
})

test_that('a directory can be converted with peak picking argument',{
  convertDirectory(grover_client,
                   'Thermo-Exactive',
                   'Experiment_1',
                   args = conversionArgsPeakPick(),
                   outDir = out_dir)
  expect_true(file.exists(str_c(out_dir,'/Experiment_1/QC01.mzML.gz')))
  unlink(str_c(out_dir,'/Experiment_1'),recursive = TRUE)
})

test_that('a directory can be converted with MS level 1 argument',{
  convertDirectory(grover_client,
                   'Thermo-Exactive',
                   'Experiment_1',
                   args = conversionArgsMSlevel1(),
                   outDir = out_dir)
  expect_true(file.exists(str_c(out_dir,'/Experiment_1/QC01.mzML.gz')))
  unlink(str_c(out_dir,'/Experiment_1'),recursive = TRUE)
})

test_that('a directory can be converted with MS level 2 argument',{
  convertDirectory(grover_client,
                   'Thermo-Exactive',
                   'Experiment_1',
                   args = conversionArgsMSlevel2(),
                   outDir = out_dir)
  expect_true(file.exists(str_c(out_dir,'/Experiment_1/QC01.mzML.gz')))
  unlink(str_c(out_dir,'/Experiment_1'),recursive = TRUE)
})

test_that('a directory can be converted with MS level 3 argument',{
  convertDirectory(grover_client,
                   'Thermo-Exactive',
                   'Experiment_1',
                   args = conversionArgsMSlevel3(),
                   outDir = out_dir)
  expect_true(file.exists(str_c(out_dir,'/Experiment_1/QC01.mzML.gz')))
  unlink(str_c(out_dir,'/Experiment_1'),recursive = TRUE)
})

test_that('a directory can be converted with split modes',{
  convertDirectorySplitModes(grover_client,
                   'Thermo-Exactive',
                   'Experiment_1',
                   outDir = out_dir)
  expect_true(file.exists(str_c(out_dir,
                                '/Experiment_1/Experiment_1-neg/QC01.mzML.gz')))
  expect_true(file.exists(str_c(out_dir,
                                '/Experiment_1/Experiment_1-pos/QC01.mzML.gz')))
  unlink(str_c(out_dir,'/Experiment_1'),recursive = TRUE)
})

test_that('a file can be transfered',{
  transferFile(grover_client,
          'Thermo-Exactive',
          'Experiment_1',
          'QC01.raw',
          outDir = out_dir)
  expect_true(file.exists(str_c(out_dir,'/QC01.raw')))
  unlink(str_c(out_dir,'/QC01.raw'))
})

test_that('a directory can be transfered',{
  transferDirectory(grover_client,
               'Thermo-Exactive',
               'Experiment_1',
               outDir = out_dir)
  expect_true(file.exists(str_c(out_dir,'/Experiment_1/QC01.raw')))
  unlink(str_c(out_dir,'/Experiment_1/QC01.raw'))
})

test_that('sample information can be returned',{
  sample_info <- sampleInfo(grover_client,
                            'Thermo-Exactive',
                            'Experiment_1',
                            'QC01.raw')
  expect_s3_class(sample_info,'tbl_df')
})

test_that('run information for a directory can be returned',{
  run_info <- runInfo(grover_client,
                      'Thermo-Exactive',
                      'Experiment_1')
  expect_s3_class(run_info,'tbl_df')
})

test_that('file information can be returned',{
  file_info <- fileInfo(grover_client,
                        'Thermo-Exactive',
                        'Experiment_1',
                        'QC01.raw')
  expect_s3_class(file_info,'tbl_df')
})

test_that('directory file information can be returned',{
  directory_info <- directoryFileInfo(grover_client,
                                      'Thermo-Exactive',
                                      'Experiment_1')
  expect_s3_class(directory_info,'tbl_df')
})

test_that('instrument file information can be returned',{
  instrument_info <- instrumentFileInfo(grover_client,
                                        'Thermo-Exactive')
  expect_s3_class(instrument_info,'tbl_df')
})

test_that('repository file information can be returned',{
  repository_info <- repositoryFileInfo(grover_client)
  expect_s3_class(repository_info,'tbl_df')
})

api$kill()

test_that('client cannot detect api after it is killed',{
  expect_equal(extant(grover_client),FALSE)
})
