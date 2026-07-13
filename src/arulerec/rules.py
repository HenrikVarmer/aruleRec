"""Association-rule generation from frequent itemsets."""

from __future__ import annotations

from dataclasses import dataclass
from itertools import combinations
from typing import Hashable

__all__ = ["Rule", "generate_rules"]


@dataclass(frozen=True)
class Rule:
    """An association rule ``antecedent -> consequent`` with quality metrics."""

    antecedent: frozenset
    consequent: frozenset
    support: float      # support of antecedent ∪ consequent
    confidence: float   # P(consequent | antecedent)
    lift: float         # confidence / support(consequent)

    def __repr__(self) -> str:  # pragma: no cover - cosmetic
        a = ", ".join(map(str, sorted(self.antecedent, key=str)))
        c = ", ".join(map(str, sorted(self.consequent, key=str)))
        return (f"{{{a}}} -> {{{c}}} "
                f"(supp={self.support:.3f}, conf={self.confidence:.3f}, lift={self.lift:.2f})")


def _proper_nonempty_subsets(itemset: frozenset):
    items = list(itemset)
    for r in range(1, len(items)):
        for combo in combinations(items, r):
            yield frozenset(combo)


def generate_rules(support: dict, min_confidence: float,
                   max_consequent: int | None = 1) -> list[Rule]:
    """Turn frequent itemsets into rules meeting ``min_confidence``.

    ``max_consequent`` caps the consequent size (default 1 — single-item
    recommendations; pass ``None`` for all splits).
    """
    rules: list[Rule] = []
    for itemset, supp in support.items():
        if len(itemset) < 2:
            continue
        for antecedent in _proper_nonempty_subsets(itemset):
            consequent = itemset - antecedent
            if max_consequent is not None and len(consequent) > max_consequent:
                continue
            ante_supp = support.get(antecedent)
            cons_supp = support.get(consequent)
            if not ante_supp or not cons_supp:
                continue
            confidence = supp / ante_supp
            if confidence < min_confidence:
                continue
            lift = confidence / cons_supp
            rules.append(Rule(antecedent, consequent, supp, confidence, lift))
    rules.sort(key=lambda r: (r.lift, r.confidence, r.support), reverse=True)
    return rules
