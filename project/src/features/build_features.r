library("data.table")
library("tidyr")
library("dplyr")

readWithParams = function(filein){
  return(as.data.table(
               fread(filein,
                 header = T,
                 stringsAsFactors = T
                )
               )
         )
}

d.otrain = readWithParams("project/volume/data/raw/Stat_380_train.csv")
d.otest = readWithParams("project/volume/data/raw/Stat_380_train.csv")

rm(readWithParams)

d.full = rbind(d.otrain, d.otest)

d.full = drop_na(d.full)
