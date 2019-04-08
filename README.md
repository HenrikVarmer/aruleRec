# aruleRec

The aruleRec function takes a dataframe as input in tidy (long) format with one observation (transaction) per row. This data.frame must contain two columns: a customer ID and a product ID. The data.frame and column names must be provided as arguments to the function, along with the hyperparameters for association rule mining: confidence, support, minlen, and maxlen.
