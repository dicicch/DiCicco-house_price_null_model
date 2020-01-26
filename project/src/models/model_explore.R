library("data.table")
library("tidyr")
library("plyr")

d.full = fread("project/volume/data/interim/data_full.csv")

y = d.full[,SalePrice]
d.full <- subset(d.full, select = -c(SalePrice))

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