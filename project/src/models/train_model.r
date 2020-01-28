library("data.table")
library("outliers")
library("tidyr")
library("plyr")

set.seed(4261998)

d.train = fread("project/volume/data/interim/data_train.csv")
d.test = fread("project/volume/data/interim/data_test.csv")

fit = lm(SalePrice ~ OverallQual + TotalBsmtSF
         + GrLivArea + poly(YearBuilt, 3) + OverallQual:YearBuilt, data=d.full.nooutlier)
summary(fit)
plot(fit)

sqrt(mean(fit$residuals^2))

predictions = as.data.table(round(predict.lm(fit, d.test), 2))

predictions = cbind(d.test[,Id], predictions)
names(predictions) = c("Id","SalePrice")

fwrite(predictions, "./project/predictions.csv", row.names = F)
