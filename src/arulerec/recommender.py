"""ARuleRec — cross-sell recommendations from mined association rules."""

from __future__ import annotations

from dataclasses import dataclass
from typing import Hashable, Iterable, Mapping, Optional

from .apriori import apriori
from .rules import Rule, generate_rules

__all__ = ["ARuleRec", "Recommendation", "baskets_from_tidy"]


@dataclass
class Recommendation:
    item: Hashable
    confidence: float
    lift: float
    support: float

    def as_dict(self) -> dict:
        return {"item": self.item, "confidence": round(self.confidence, 4),
                "lift": round(self.lift, 4), "support": round(self.support, 4)}


def baskets_from_tidy(rows: Iterable, user_index=0, item_index=1) -> dict:
    """Build ``{user: {items}}`` baskets from tidy (user, item) rows.

    ``rows`` may be tuples/lists (use positional indices) or mappings (pass the
    column *names* as ``user_index`` / ``item_index``).
    """
    baskets: dict = {}
    for row in rows:
        if isinstance(row, Mapping):
            u, i = row[user_index], row[item_index]
        else:
            u, i = row[user_index], row[item_index]
        baskets.setdefault(u, set()).add(i)
    return baskets


class ARuleRec:
    """Fit association rules and turn them into per-user recommendations.

    Parameters
    ----------
    min_support, min_confidence:
        Apriori / rule thresholds.
    max_len:
        Optional cap on mined itemset size.
    """

    def __init__(self, min_support: float = 0.01, min_confidence: float = 0.5,
                 max_len: Optional[int] = None):
        self.min_support = min_support
        self.min_confidence = min_confidence
        self.max_len = max_len
        self.rules: list[Rule] = []
        self.support: dict = {}
        self.n: int = 0

    def fit(self, transactions: Iterable[Iterable[Hashable]]) -> "ARuleRec":
        self.support, self.n = apriori(transactions, self.min_support, self.max_len)
        self.rules = generate_rules(self.support, self.min_confidence, max_consequent=1)
        return self

    def recommend(self, basket: Iterable[Hashable], n: Optional[int] = None) -> list[Recommendation]:
        """Recommend items for a basket, ranked by lift then confidence.

        Fires every rule whose antecedent is a subset of the basket; each
        candidate item keeps its best-scoring rule. Items already in the basket
        are never recommended.
        """
        basket = frozenset(basket)
        best: dict = {}
        for rule in self.rules:
            if not rule.antecedent <= basket:
                continue
            for item in rule.consequent:
                if item in basket:
                    continue
                cand = (rule.lift, rule.confidence, rule.support)
                if item not in best or cand > (best[item].lift, best[item].confidence, best[item].support):
                    best[item] = Recommendation(item, rule.confidence, rule.lift, rule.support)
        recs = sorted(best.values(), key=lambda r: (r.lift, r.confidence, r.support), reverse=True)
        return recs[:n] if n else recs

    def recommend_all(self, baskets: Mapping, n: Optional[int] = None) -> dict:
        """Recommend for every basket in a ``{user: items}`` mapping.

        Only users with at least one recommendation are included.
        """
        out = {}
        for user, items in baskets.items():
            recs = self.recommend(items, n)
            if recs:
                out[user] = recs
        return out
