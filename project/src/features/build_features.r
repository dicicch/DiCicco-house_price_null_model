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
d.otest = readWithParams("project/volume/data/raw/Stat_380_test.csv")

rm(readWithParams)

#d.train = drop_na(d.otrain)
#d.test = drop_na(d.otest)

d.train.numonly = subset(d.train, select = -c(BldgType, Heating, CentralAir))
d.train.numonly = apply(d.train.numonly, FUN=as.numeric, MARGIN = 2)
d.test.numonly = subset(d.otest, select = -c(BldgType, Heating, CentralAir))
d.test.numonly = apply(d.test.numonly, FUN=as.numeric, MARGIN = 2)

d.train.nooutlier = d.train[which(apply(outlier(d.train.numonly, logical = T), 1, any)),]
#d.test.nooutlier = d.full[which(apply(outlier(d.test.numonly, logical = T), 1, any)),]

fwrite(d.train.nooutlier, "~/dev/house_price_null_model/project/volume/data/interim/data_train.csv")
fwrite(d.otest, "~/dev/house_price_null_model/project/volume/data/interim/data_test.csv")
