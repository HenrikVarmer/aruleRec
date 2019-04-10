# aruleRec

### Easy and fast recommendations with association rule learning in R

The aruleRec function takes a dataframe as input in tidy (long) format with one observation (customer-item pair) per row. This data.frame must contain two columns: a customer ID and a product ID. The data.frame and column names must be provided as arguments to the function, along with the hyperparameters for association rule mining: confidence, support, minlen, and maxlen. 

*Note: This library relies heaviliy on the [arules](https://cran.r-project.org/web/packages/arules/index.html) package.*

The ```aruleRec()``` function returns a dataframe with all customers and corresponding cross-selling recommendations and rule quality parameters.

Example data structure for rule mining:

| CustomerKey   | ProductKey    |
| ------------: |--------------:|
| 1000          | 27            |
| 1000          | 24            |
| 1001          | 22            |
| 1001          | 27            |


Example function input:

```R
aruleRec(data        = dat,         # dataframe
         productkey  = ProductKey,  #item ID column
         customerkey = CustomerKey, # contact ID column
         minlen      = 2, 
         maxlen      = 20, 
         support     = 0.01, 
         confidence  = 0.7)
```


Example output:

| lhs	         | CustomerKey|	rhs  |	support | confidence  | lift   |	count|
|----------------:|-----------:|--------:|----------:|------------:|-------:|--------:|
| 20,23,24,27     |     1001   |	29   |	0.01    | 0.73	    | 4.24   |	1305 |
| 22,27,33        |     1002   |	20   |	0.01    | 0.85	    | 1.97   |	1453 |
| 11,20,33        |     1003   |	27   |	0.08    | 0.75	    | 1.42   |	1151 |

Here, the lhs column constitutes the customer purchase history. The rhs column indicates the cross-selling opportunity based on the mined association rules. 

