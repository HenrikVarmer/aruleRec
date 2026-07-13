import math

from arulerec import ARuleRec, apriori, baskets_from_tidy, generate_rules

# Classic market-basket toy data: milk/bread/butter co-occur strongly.
TXNS = [
    {"milk", "bread", "butter"},
    {"milk", "bread"},
    {"milk", "bread", "butter"},
    {"bread", "butter"},
    {"milk", "butter"},
    {"milk", "bread", "butter"},
    {"bread"},
    {"milk", "bread", "butter"},
]


def test_apriori_supports():
    supp, n = apriori(TXNS, min_support=0.25)
    assert n == 8
    assert supp[frozenset({"milk"})] == 6 / 8
    assert supp[frozenset({"bread"})] == 7 / 8
    # frequent pair present
    assert frozenset({"bread", "butter"}) in supp


def test_apriori_min_support_prunes():
    supp, _ = apriori([{"a"}, {"b"}, {"a", "b"}], min_support=0.9)
    # nothing reaches 90% support
    assert supp == {}


def test_rule_metrics_are_correct():
    supp, _ = apriori(TXNS, min_support=0.25)
    rules = generate_rules(supp, min_confidence=0.5)
    r = next(x for x in rules if x.antecedent == frozenset({"butter"})
             and x.consequent == frozenset({"bread"}))
    # butter in 6 txns, {bread,butter} in 5 -> conf 5/6
    assert math.isclose(r.confidence, 5 / 6, rel_tol=1e-9)
    # lift = conf / support(bread) = (5/6) / (7/8)
    assert math.isclose(r.lift, (5 / 6) / (7 / 8), rel_tol=1e-9)


def test_recommend_excludes_basket_items_and_ranks():
    model = ARuleRec(min_support=0.25, min_confidence=0.5).fit(TXNS)
    recs = model.recommend({"butter"})
    items = [r.item for r in recs]
    assert "butter" not in items          # never recommend what's in the basket
    assert "bread" in items or "milk" in items
    # sorted by lift descending
    assert all(recs[i].lift >= recs[i + 1].lift for i in range(len(recs) - 1))


def test_recommend_top_n_and_empty():
    model = ARuleRec(min_support=0.25, min_confidence=0.5).fit(TXNS)
    assert len(model.recommend({"bread"}, n=1)) <= 1
    assert model.recommend({"nonexistent"}) == []


def test_recommend_all_from_tidy():
    rows = [("u1", "milk"), ("u1", "bread"), ("u2", "butter")]
    baskets = baskets_from_tidy(rows)
    assert baskets["u1"] == {"milk", "bread"}
    model = ARuleRec(min_support=0.25, min_confidence=0.5).fit(TXNS)
    out = model.recommend_all(baskets)
    # only users with recommendations are returned
    assert all(len(v) > 0 for v in out.values())
