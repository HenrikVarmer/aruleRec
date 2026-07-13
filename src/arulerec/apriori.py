"""Frequent-itemset mining with the Apriori algorithm (pure Python)."""

from __future__ import annotations

from collections import Counter
from itertools import combinations
from typing import Hashable, Iterable

__all__ = ["apriori"]

Itemset = frozenset


def apriori(transactions: Iterable[Iterable[Hashable]], min_support: float,
            max_len: int | None = None) -> tuple[dict, int]:
    """Mine frequent itemsets.

    Parameters
    ----------
    transactions:
        Iterable of transactions, each an iterable of hashable items.
    min_support:
        Minimum fraction of transactions an itemset must appear in (0..1).
    max_len:
        Optional cap on itemset size.

    Returns
    -------
    (support, n)
        ``support`` maps each frequent ``frozenset`` to its support (fraction);
        ``n`` is the number of transactions.
    """
    txns = [frozenset(t) for t in transactions]
    n = len(txns)
    if n == 0:
        return {}, 0
    min_count = min_support * n

    # L1
    c1: Counter = Counter()
    for t in txns:
        for item in t:
            c1[frozenset((item,))] += 1
    freq: dict = {s: c / n for s, c in c1.items() if c >= min_count}

    current = list(freq.keys())
    k = 2
    while current and (max_len is None or k <= max_len):
        # candidate generation: join frequent (k-1)-itemsets that share k-2 items
        candidates = set()
        for a, b in combinations(current, 2):
            union = a | b
            if len(union) == k:
                # prune: every (k-1)-subset must be frequent
                if all((union - frozenset((x,))) in freq for x in union):
                    candidates.add(union)
        if not candidates:
            break
        counts: Counter = Counter()
        for t in txns:
            for c in candidates:
                if c <= t:
                    counts[c] += 1
        new_freq = {c: cnt / n for c, cnt in counts.items() if cnt >= min_count}
        freq.update(new_freq)
        current = list(new_freq.keys())
        k += 1

    return freq, n
