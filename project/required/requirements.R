packages = c("data.table", "optparse","tidyr", "plyr", "outliers", "glmnet", "corrplot")

if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())))  
}
