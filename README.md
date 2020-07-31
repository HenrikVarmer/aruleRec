# aruleRec

### Easy and fast recommendations with association rule learning in R

Let's say all you know about your customers is their purchase history. With this data you want to generate individual recommendations representing cross-selling opportunities. How? [Association Rule Learning.](https://en.wikipedia.org/wiki/Association_rule_learning) This library relies on the [arules](https://cran.r-project.org/web/packages/arules/index.html) package for mining association rules and simply provides a wrapper for easy generation of recommendations with tidy datasets. 

### Installing aruleRec
Install the package directly from github with devtools. Run the first line if you do not currently have devtools installed.

```R
# install.packages('devtools') 
devtools::install_github('HenrikVarmer/aruleRec')
```
### Using the functions
There a three core functions in this package: ```aruleRec()```, ```aruleTrain()```, ```arulePredict()```. 

### aruleRec()

The aruleRec() function takes a dataframe as input in tidy (long) format with one observation (customer-item pair) per row. The input data.frame must contain two columns: a customer ID and a product ID. The data.frame and column names are provided as arguments to the function, along with the hyperparameters for rule mining - confidence, support, minlen, and maxlen.

The aruleRec() function returns a dataframe with customers and corresponding cross-selling recommendations and rule quality parameters. Only customers with recommendations are returned.

### Example input data structure:

The ideal input data structure contains customers in one column, and products in another. Each row is one observation (i.e. one set of customer - item keys). Notice that one customer can have multiple rows, because one row is one purchase of one item. 

| customer      | product       |
| ------------: |--------------:|
| 1000          | 27            |
| 1000          | 24            |
| 1001          | 22            |
| 1001          | 27            |

### Example usage of aruleRec() function:

Load your data and apply the aruleRec() function. Supply the dataframe, the item column name, the customer column name, as well as parameters for the association rule mining algorithm. The optional keep_all argument defines weather all customers should be returned, or only those where the algorithm can make a recommendation. 

```R
dat <- read.csv("your_sales_data.csv")

recommendations <- aruleRec(data        = dat,      # dataframe
                            productkey  = Item,     # item ID column
                            customerkey = Customer, # contact ID column
                            keep_all    = FALSE,    # return all contacts or just rows with recommendations
                            minlen      = 2, 
                            maxlen      = 20, 
                            support     = 0.01, 
                            confidence  = 0.1)

head(recommendations, 3)

```

### Example output:

In the output dataframe returned from the aruleRec() function, the 'item_history' column constitutes the customer purchase history. The 'recommendation' column indicates the cross-selling opportunity based on the mined association rules, along with key metrics support (the frequency with which the rule set appears in data), confidence (how often the rules is true), lift (how non-random the rules is), and count (how often the rule occurs in data).

| item_history    | customer   |	recommendation  |	support   | confidence  | lift   |	count  |
|----------------:|-----------:|-----------------:|----------:|------------:|-------:|--------:|
| 20,23,24,27     |     1001   |	           29   |	0.01      | 0.73	      | 4.24   |	  1305 |
| 22,27,33        |     1002   |	           20   |	0.01      | 0.85	      | 1.97   |	  1453 |
| 11,20,33        |     1003   |	           27   |	0.08      | 0.75	      | 1.42   |	  1151 |

### aruleTrain()

The aruleTrain function mines recommendations from an input data frame with customers and purchases and stores the mined rules for subsequent prediction with the arulePredict function. 

```R
dat <- read.csv("your_sales_data.csv")

# train (mine rules and store them in rules object)
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
* Seamlessly suport multiple input types (transaction data, tidy data, binary incidence matrix, etc.) 
* Add support for no rules returned by apriori()
* Add nrow support argument

:heavy_check_mark: Add option to "keep all" or (default): keep only customers with recommendations (added 20/04/2019)
