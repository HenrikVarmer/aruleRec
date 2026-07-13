"""arulerec — cross-sell recommendations with association-rule learning.

    from arulerec import ARuleRec

    model = ARuleRec(min_support=0.2, min_confidence=0.6).fit(transactions)
    model.recommend({"bread", "butter"})          # -> [Recommendation(item="milk", ...)]

Pure Python (own Apriori) — no heavy dependencies.
"""

from __future__ import annotations

from .apriori import apriori
from .recommender import ARuleRec, Recommendation, baskets_from_tidy
from .rules import Rule, generate_rules

__version__ = "0.1.0"

__all__ = [
    "ARuleRec", "Recommendation", "baskets_from_tidy",
    "apriori", "generate_rules", "Rule", "__version__",
]
