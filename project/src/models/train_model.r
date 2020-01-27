library("data.table")
library("outliers")
library("tidyr")
library("plyr")

set.seed(4261998)

d.train = fread("project/volume/data/interim/data_train.csv")
d.test = fread("project/volume/data/interim/data_test.csv")

y = d.train[,SalePrice]
x1 = log(d.train[,LotArea])
x2 = d.train[,YearBuilt]
x3 = d.train[,TotalBsmtSF]
x4 = d.train[,GrLivArea]
x5 = d.train[,PoolArea]
x6 = d.train[,Heating]
x7 = d.train[,CentralAir]
x8 = d.train[,BldgType]

fit = lm(y ~ x1 + x2 + x3 + x4 + x5, data=d.train)
summary(fit)

sqrt(mean(fit$residuals^2))

predictions = as.data.table(round(predict.lm(fit, d.test), 2))

predictions = cbind(d.test[,Id], predictions)
names(predictions) = c("Id","SalePrice")

fwrite(predictions, "./project/predictions.csv", row.names = F)
