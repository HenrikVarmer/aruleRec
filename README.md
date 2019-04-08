# aruleRec

The aruleRec function takes a dataframe as input in tidy (long) format with one observation (transaction) per row. This data.frame must contain two columns: a customer ID and a product ID. The data.frame and column names must be provided as arguments to the function, along with the hyperparameters for association rule mining: confidence, support, minlen, and maxlen.

Example function input:

```R
aruleRec(data = dat, # dataframe
         productkey = ProductId, #item ID column
         customerkey = ContactKey, # contact ID column
         minlen = 2, 
         maxlen = 20, 
         support = 0.01, 
         confidence = 0.7)

```


