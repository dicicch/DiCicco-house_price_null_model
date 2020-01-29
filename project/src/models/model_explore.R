library("data.table")
library("outliers")
library("corrplot")
library("e1071")
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

d.numonly = subset(d.full, select = -c(BldgType, Heating, CentralAir))
d.full.nooutlier = d.full[which(apply(outlier(d.numonly, logical = T), 1, any)),]

p.cor = cor(d.numonly)
corrplot(p.cor)

fit = lm(SalePrice ~ OverallQual + TotalBsmtSF
         + GrLivArea + YearBuilt + OverallQual:YearBuilt, data=d.full.nooutlier)

fit = lm(SalePrice ~ OverallQual + TotalBsmtSF
         + GrLivArea + poly(YearBuilt, 3) + OverallQual:YearBuilt, data=d.full.nooutlier)
par(mfrow=c(2,2))
plot(fit)

sqrt(mean(fit$residuals^2))

fit = svm(SalePrice ~ OverallQual + TotalBsmtSF
          + GrLivArea + YearBuilt,
          data=d.full.nooutlier,
          kernel="radial",
          cross=20
          )

summary(fit)

fwrite(d.full.nooutlier, "./project/volume/data/processed/data_full_processed_nooutliers.csv")
