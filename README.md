# aruleRec

### Easy and fast recommendations with association rule learning in R

Let's say all you know about your customers is their purchase history. With this data you want to generate individual recommendations representing cross-selling opportunities. How? [Association Rule Learning.](https://en.wikipedia.org/wiki/Association_rule_learning)

The aruleRec function takes a dataframe as input in tidy (long) format with one observation (customer-item pair) per row. The input data.frame must contain two columns: a customer ID and a product ID. The data.frame and column names are provided as arguments to the function, along with the hyperparameters for rule mining - confidence, support, minlen, and maxlen. 

*Note: This library relies on the [arules](https://cran.r-project.org/web/packages/arules/index.html) package for mining association rules.*

The ```aruleRec()``` function returns a dataframe with customers and corresponding cross-selling recommendations and rule quality parameters. Only customers with recommendations are returned. 

Input data structure for generating recommendations:

| customer      | product       |
| ------------: |--------------:|
| 1000          | 27            |
| 1000          | 24            |
| 1001          | 22            |
| 1001          | 27            |


Example function use:

```R
dat <- read.csv("your_sales_data.csv")

recommendations <- aruleRec(data         = dat,         # dataframe
                            productkey   = product,     # item ID column
                            customerkey  = customer,    # contact ID column
                            minlen       = 2, 
                            maxlen       = 20, 
                            support      = 0.01, 
                            confidence   = 0.7)

```


Example output:

| item_history    | customer   |	recommendation  |	support   | confidence  | lift   |	count  |
|----------------:|-----------:|-----------------:|----------:|------------:|-------:|--------:|
| 20,23,24,27     |     1001   |	           29   |	0.01      | 0.73	      | 4.24   |	  1305 |
| 22,27,33        |     1002   |	           20   |	0.01      | 0.85	      | 1.97   |	  1453 |
| 11,20,33        |     1003   |	           27   |	0.08      | 0.75	      | 1.42   |	  1151 |

Here, the lhs column constitutes the customer purchase history. The rhs column indicates the cross-selling opportunity based on the mined association rules. 

To do :pencil:
* Seamlessly suport multiple input formats (transaction data, tidy data, binary incidence matrix, etc.)
* Build API 
* Add option to "return all" or keep default: only customers with recommendations
