
source("aruleRec.R")

# test the function on test set

dat <- read.csv("dat.csv") %>% select(ContactKey, ProductId)

test <- aruleRec(data = dat, productkey = ProductId, customerkey = ContactKey, minlen = 2, maxlen = 20, support = 0.01, confidence = 0.7)

head(test)