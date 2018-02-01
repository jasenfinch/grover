library(msconverteR)

#* @get /convert

function(instrument,directory,file,args,res){
  msconvert(str('Z:/',instrument,'/','directory','/',file),outPath = str_c('C:/TMP_STORE/','/',instrument,'/',directory),args)
  include_file()
}
