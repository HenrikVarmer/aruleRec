# arulerec

> Cross-sell recommendations with **association-rule learning** — pure Python,
> no heavy dependencies.

<p>
<a href="https://github.com/HenrikVarmer/arulerec/actions/workflows/tests.yaml"><img src="https://github.com/HenrikVarmer/arulerec/actions/workflows/tests.yaml/badge.svg" alt="tests"></a>
<img src="https://img.shields.io/badge/python-%E2%89%A5%203.9-3776AB?logo=python&logoColor=white" alt="Python ≥ 3.9">
<img src="https://img.shields.io/badge/license-MIT-green" alt="MIT">
</p>

Give `arulerec` your customers' purchase histories and it mines
[association rules](https://en.wikipedia.org/wiki/Association_rule_learning)
(own Apriori implementation) and turns them into individual cross-sell
recommendations — the item a basket is most likely to be missing, ranked by
lift.

## Install

```bash
pip install -e ".[test]"
```

Zero runtime dependencies (add `.[pandas]` for DataFrame helpers).

## Usage

```python
from arulerec import ARuleRec

transactions = [
    {"milk", "bread", "butter"},
    {"milk", "bread"},
    {"bread", "butter"},
    {"milk", "butter"},
    {"milk", "bread", "butter"},
]

model = ARuleRec(min_support=0.3, min_confidence=0.6).fit(transactions)

for rec in model.recommend({"bread", "butter"}):
    print(rec.as_dict())
# {'item': 'milk', 'confidence': 0.75, 'lift': 1.07, 'support': 0.6}
```

Recommendations exclude items already in the basket and are ranked by **lift**
then confidence.

### From tidy (customer, item) rows

```python
from arulerec import ARuleRec, baskets_from_tidy

rows = [("c1", "milk"), ("c1", "bread"), ("c2", "butter"), ...]
baskets = baskets_from_tidy(rows)

model = ARuleRec(min_support=0.02, min_confidence=0.5).fit(baskets.values())
recs_by_customer = model.recommend_all(baskets, n=5)   # top-5 per customer
```

Only customers with at least one recommendation are returned.

## API

| Object | Purpose |
|--------|---------|
| `ARuleRec(min_support, min_confidence, max_len)` | `.fit(transactions)`, `.recommend(basket, n)`, `.recommend_all(baskets, n)` |
| `apriori(transactions, min_support, max_len)` | Frequent-itemset mining |
| `generate_rules(support, min_confidence)` | Build rules with support / confidence / lift |
| `baskets_from_tidy(rows)` | `{user: {items}}` from tidy rows |
| `Rule`, `Recommendation` | Result dataclasses |

## Note on method

`arulerec` mines **frequent itemsets** with a self-contained
[Apriori](https://en.wikipedia.org/wiki/Apriori_algorithm) pass — single items,
then pairs, then larger sets — keeping only those that appear in at least
`min_support` of the baskets and pruning any candidate with an infrequent
subset. It turns those itemsets into rules `antecedent -> item`, keeps the ones
above `min_confidence`, and scores each by **lift** (confidence divided by the
recommended item's own support) so co-occurrences stronger than chance rank
first.

It is deliberately simple and transparent — every recommendation traces back to
a rule you can read. Know the trade-offs:

- **It needs volume.** Support, confidence and lift are only meaningful over
  enough baskets; on small or sparse data the rules are noise.
- **Low `min_support` is expensive.** Apriori's candidate set grows
  combinatorially as the threshold drops, so keep `min_support` sensible (and
  `max_len` capped) on large catalogs.
- **Rare items never surface.** Anything below `min_support` is pruned before
  rules are built — this is a co-occurrence model, not a cold-start solver.
- **Lift is association, not causation.** A high-lift rule means two items occur
  together more than chance predicts, not that recommending one *causes* the
  other to sell.

For large, dense catalogs or personalized (user × item) recommendations, reach
for a matrix-factorization or embedding-based recommender instead; Apriori is at
its best on modest, interpretable market-basket problems.

## R version

The original R implementation lives at
**[HenrikVarmer/aruleRec-R](https://github.com/HenrikVarmer/aruleRec-R)**
(a wrapper around the `arules` package).

## License

MIT © Henrik Varmer
