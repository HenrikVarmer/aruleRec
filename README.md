# aruleRec

### Easy and fast recommendations with association rule learning in R

Let's say all you know about your customers is their purchase history. With this data you want to generate individual recommendations representing cross-selling opportunities. How? [Association Rule Learning.](https://en.wikipedia.org/wiki/Association_rule_learning)

### Installing aruleRec
Install the package directly from github with devtools. Run the first line if you do not currently have devtools installed.

```R
# install.packages('devtools') 
devtools::install_github('HenrikVarmer/aruleRec')
```
### Using the functions
The ```aruleRec()``` function takes a dataframe as input in tidy (long) format with one observation (customer-item pair) per row. The input data.frame must contain two columns: a customer ID and a product ID. The data.frame and column names are provided as arguments to the function, along with the hyperparameters for rule mining - confidence, support, minlen, and maxlen. 

*Note: This library relies on the [arules](https://cran.r-project.org/web/packages/arules/index.html) package for mining association rules.*

The ```aruleRec()``` function returns a dataframe with customers and corresponding cross-selling recommendations and rule quality parameters. Only customers with recommendations are returned. 

Input data structure for generating recommendations:

| customer      | product       |
| ------------: |--------------:|
| 1000          | 27            |
| 1000          | 24            |
| 1001          | 22            |
| 1001          | 27            |


### aruleRec()

This function mines recommendations from an input data frame with customers and purchases and applies the mined rules to the same input dataset.

```R
dat <- read.csv("your_sales_data.csv")

recommendations <- aruleRec(data        = dat,      # dataframe
                            productkey  = Item,     # item ID column
                            customerkey = Customer, # contact ID column
                            keep_all    = FALSE,    # return all customers or just those with recommended items
                            minlen      = 2, 
                            maxlen      = 20, 
                            support     = 0.01, 
                            confidence  = 0.1)

head(recommendations, 3)

```


Example output:

| item_history    | customer   |	recommendation  |	support   | confidence  | lift   |	count  |
|----------------:|-----------:|-----------------:|----------:|------------:|-------:|--------:|
| 20,23,24,27     |     1001   |	           29   |	0.01      | 0.73	      | 4.24   |	  1305 |
| 22,27,33        |     1002   |	           20   |	0.01      | 0.85	      | 1.97   |	  1453 |
| 11,20,33        |     1003   |	           27   |	0.08      | 0.75	      | 1.42   |	  1151 |

Here, the lhs column constitutes the customer purchase history. The rhs column indicates the cross-selling opportunity based on the mined association rules. 

--------

### aruleTrain()

The aruleTrain function mines recommendations from an input data frame with customers and purchases and stores the mined rules for subsequent prediction with the arulePredict function. 

```R
dat <- read.csv("your_sales_data.csv")

# train (mine rules)
rules   <- aruleTrain(data        = dat,      # dataframe
                      productkey  = Item,     # item ID column
                      customerkey = Customer, # contact ID column
                      minlen      = 2, 
                      maxlen      = 20, 
                      support     = 0.01, 
                      confidence  = 0.1)
```
### arulePredict()

The arulePredict function takes a rule data.frame as primary input along with the columns for customer and item and the keep_all argument, which specifies whether to return all customers or just those with recommended items

```R
newdata <- read.csv("your_new_sales_data.csv")

# predict (make recommendations on a row of new data with previously mined rules)
predict <- arulePredict(rules, 
                        newdata, 
                        Customer, 
                        Item, 
                        keep_all = TRUE)

```

--------------------

To do :pencil:
* Seamlessly suport multiple input formats (transaction data, tidy data, binary incidence matrix, etc.)
* Build API 
* Add support for no rules returned by apriori()

:heavy_check_mark: Add option to "keep all" or (default): keep only customers with recommendations (added 20/04/2019)
