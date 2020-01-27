library("data.table")
library("outliers")
library("tidyr")
library("plyr")

set.seed(4261998)

d.full = fread("project/volume/data/interim/data_full.csv")

y = d.full[,SalePrice]
#d.full <- subset(d.full, select = -c(SalePrice))

summary(d.full)

feature.vars = numcolwise(sd)(d.full)

barplot(as.matrix(feature.vars), log="y", las=2, cex.names=0.65)
title("Numeric Feature Variances")

x1 = d.full[,LotArea]
x2 = d.full[,YearBuilt]
x3 = d.full[,TotalBsmtSF]
x4 = d.full[,GrLivArea]
x5 = d.full[,PoolArea]

fit = lm(y ~ x1 + x2 + x3 + x4 + x5)
par(mfrow=c(2,2))
plot(fit)

d.full = d.full[-6020,]
fit = lm(y ~ x1 + x2 + x3 + x4 + x5)
par(mfrow=c(2,2))
plot(fit)

cooks.distance(fit)
d.numonly = subset(d.full, select = -c(BldgType, Heating, CentralAir))
outlier(d.numonly)
d.full.nooutlier = d.full[which(apply(outlier(d.numonly, logical = T), 1, any)),]

y.nooutlier = which(apply(outlier(d.numonly, logical = T), 1, any))

y = d.full.nooutlier[,SalePrice]
x1 = d.full.nooutlier[,LotArea]
x2 = d.full.nooutlier[,YearBuilt]
x3 = d.full.nooutlier[,TotalBsmtSF]
x4 = d.full.nooutlier[,GrLivArea]
x5 = d.full.nooutlier[,PoolArea]
fit = lm(y ~ x1 + x2 + x3 + x4 + x5)
par(mfrow=c(2,2))
plot(fit)
summary(fit)

fit = lm(y ~ x1 + x2 + x3 + x4)
summary(fit)

sqrt(mean(fit$residuals^2))

x6 = d.full.nooutlier[,Heating]
x7 = d.full.nooutlier[,CentralAir]
x8 = d.full.nooutlier[,BldgType]

fit = lm(y ~ x1 + x2 + x3 + x4 + + x7 + x8)
summary(fit)

fwrite(d.full.nooutlier, "./project/volume/data/processed/data_full_processed_nooutliers.csv")
