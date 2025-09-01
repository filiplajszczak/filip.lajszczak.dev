title: Lean 4 with a Math Textbook - Part 3 - Properties of Subsets
date: 2025-09-01 22:00
tags: lean, math, learning, rasiowa
style: math
---

*We conclude our formalization of Helena Rasiowa's basic section on
sets ([introduction](/lean-4-with-a-math-textbook---part-0---introduction.html))
by proving the essential properties that follow from our definitions. Building
on our encoding of sets and membership
([Part 1](/lean-4-with-a-math-textbook---part-1---defining-sets-and-membership.html))
and subset relations
([Part 2](/lean-4-with-a-math-textbook---part-2---subsets.html)), we
now tackle Rasiowa's Proposition 1.1.*

Rasiowa states the properties that follow from the definition of subset:

> It follows from the definition of a subset that
>
> **1.1.** *For any sets* $A$, $B$, $C$:
>
> $$\varnothing \subseteq A \tag{8}$$
> $$A \subseteq A \tag{9}$$
> $$\textit{if } A \subseteq B \textit{ and } B \subseteq C, \textit{ then } A \subseteq C \tag{10}$$
> $$\textit{if } A \subseteq B \textit{ and } B \subseteq A, \textit{ then } A = B \tag{11}$$
> $$\textit{if } A \ne B, \textit{ then } A \nsubseteq B \textit{ or } B \nsubseteq A \tag{12}$$

Let's prove each of these properties in Lean:

#### Property (8): Empty Set is Subset of Any Set

Rasiowa explains: "Formula (8) states that the empty set is contained in every
set. Since the empty set does not have any elements, the condition that every
element of the set $\varnothing$ is an element of a set $A$ is satisfied."

```lean4
theorem empty_subset (A : RasiowaSet α) : ∅ ⊆ A := by
  intro x h  -- Assume x is arbitrary and h : x ∈ ∅
             -- Goal becomes: x ∈ A
  exact False.elim h  -- Since x ∈ ∅ means False,
                      -- use explosion principle
                      -- (from False, anything follows)
```

**Step by step proof explanation**:

**What we're proving**: The statement `∅ ⊆ A` means "the empty set is a subset
of any set A." By our definition of subset, this unfolds to
`∀ x, x ∈ ∅ → x ∈ A` (for all x, if x is in the empty set, then x is in A).

**The `by` keyword**: This enters "tactic mode" where we build the proof step by
step, rather than providing a complete proof term all at once.

**The `intro x h` tactic**: Since our goal is `∀ x, x ∈ ∅ → x ∈ A`, we need to
prove a universal statement with an implication. The `intro` tactic handles
both:

- `intro x` says "let x be an arbitrary element" (handling the ∀ x part)
- `intro h` says "assume the hypothesis h : x ∈ ∅" (handling the → implication)

After `intro x h`, our assumptions are:

- `x : α` (x is some arbitrary element of type α)
- `h : x ∈ ∅` (we're assuming x belongs to the empty set)

And our goal becomes: `x ∈ A` (we need to prove x belongs to A).

**The contradiction**: But `h : x ∈ ∅` means `h : False` (since empty set means
the predicate always returns False). We have a proof of False!

**The `exact False.elim h` tactic**: From a proof of False, we can prove
anything. `False.elim` is the principle of explosion (ex falso quodlibet)—if we
have a contradiction, any statement becomes provable. Since `h : False`, we can
use `False.elim h` to prove our goal `x ∈ A`.

#### Property (9): Every Set is Subset of Itself (Reflexivity)

Rasiowa explains: "Formula (9) states that every set is a subset of itself. In
fact, every element of a set $A$ is an element of $A$."

```lean4
theorem subset_refl (A : RasiowaSet α) : A ⊆ A := by
  intro x h  -- Assume x is arbitrary and h : x ∈ A
             -- Goal becomes: x ∈ A
  exact h    -- We already have exactly what we need to prove
```

This case appears much simpler: we assume `x ∈ A` and need to prove `x ∈ A`—we
already have what we need!

#### Property (10): Transitivity of Subset Relation

Rasiowa explains: "Formula (10) is the law of transitivity for the relation of
inclusion. To prove it let us assume that $A \subseteq B$ and $B \subseteq C$.
Then every element of the set $A$ is an element of the set $B$, and every
element of the set $B$ is an element of the set $C$. Hence it follows that every
element of the set $A$ is an element of the set $C$, and hence $A \subseteq C$."

```lean4
theorem subset_trans (A B C : RasiowaSet α) :
  A ⊆ B → B ⊆ C → A ⊆ C := by
  intro h₁ h₂  -- Assume h₁ : A ⊆ B and h₂ : B ⊆ C
               -- Goal becomes: A ⊆ C (i.e., ∀ x, x ∈ A → x ∈ C)
  intro x h    -- Let x be arbitrary, assume h : x ∈ A
               -- Goal becomes: x ∈ C
  have h_B : x ∈ B := h₁ x h  -- Apply h₁ to get x ∈ B from x ∈ A
  exact h₂ x h_B              -- Apply h₂ to get x ∈ C from x ∈ B
```

We chain the implications step by step: first we get `h_B : x ∈ B` from
`h : x ∈ A` using `h₁`, then use `h_B` with `h₂` to get `x ∈ C`.

#### Property (11): Antisymmetry - Mutual Subsets Imply Equality

Rasiowa explains: "To prove (11) let us assume that $A \subseteq B$
and $B \subseteq A$. Hence every element of the set $A$ is an element of the
set $B$, and every element of the set $B$ is an element of the set $A$. Thus the
sets $A$ and $B$ have the same elements, that is, they are identical."

She also notes: "Formula (11) is often used in proving the identity of sets."

```lean4
theorem subset_antisymm (A B : RasiowaSet α) :
  A ⊆ B → B ⊆ A → A = B := by
  intro h₁ h₂  -- Assume h₁ : A ⊆ B and h₂ : B ⊆ A
               -- Goal becomes: A = B
  -- Use set extensionality: 
  -- two sets are equal iff they have same membership
  rw [set_extensionality]  -- Goal becomes: ∀ x, (x ∈ A ↔ x ∈ B)
  intro x      -- Let x be arbitrary
               -- Goal becomes: x ∈ A ↔ x ∈ B
  constructor  -- Split bidirectional into forward and reverse
  · -- Forward: x ∈ A → x ∈ B
    exact h₁ x -- Apply subset relation h₁
  · -- Reverse: x ∈ B → x ∈ A
    exact h₂ x -- Apply subset relation h₂
```

#### Property (12): Contrapositive of Antisymmetry

Rasiowa explains: "Formula (12) follows from formula (11). Should it be
that $A \subseteq B$ and $B \subseteq A$, then by (11) the sets $A$ and $B$
would be identical, contrary to the assumption that $A \ne B$."

**New tactics:** We introduce `by_cases` for classical case analysis - it splits
the proof based on whether a proposition is true or false. We also use `left`
and `right` tactics: when the goal is a disjunction (P ∨ Q), use `left` to prove
P or `right` to prove Q.

```lean4
theorem inequality_disjunction (A B : RasiowaSet α) : 
  A ≠ B → ¬(A ⊆ B) ∨ ¬(B ⊆ A) := by
  intro h   -- Assume h : A ≠ B
            -- Goal becomes: ¬(A ⊆ B) ∨ ¬(B ⊆ A)
  -- Use classical reasoning: either A ⊆ B or A ⊄ B
  by_cases h₁ : A ⊆ B  -- Split into cases based on whether A ⊆ B
  · -- Case: A ⊆ B
    right  -- Choose right side of disjunction: ¬(B ⊆ A)
    intro h₂  -- Assume h₂ : B ⊆ A (for contradiction)
              -- Goal becomes: False
    -- By antisymmetry: A = B
    have h_eq : A = B := subset_antisymm A B h₁ h₂
    -- Contradiction with h : A ≠ B
    exact h h_eq  -- Apply h : A ≠ B to h_eq : A = B to get False
  · -- Case: A ⊄ B (¬(A ⊆ B))
    left   -- Choose left side of disjunction: ¬(A ⊆ B)
    exact h₁  -- We already have the proof from the case split
```

**Working through the proof
that $\lbrace 1, 2 \rbrace \subseteq \lbrace 1, 2, 3 \rbrace$**:

First, let's define our sets:

```lean4
def setA : RasiowaSet Nat := fun x => x = 1 ∨ x = 2
def setB : RasiowaSet Nat := fun x => x = 1 ∨ x = 2 ∨ x = 3
```

Then we can prove the subset relation:

```lean4
example : setA ⊆ setB := by
  intro x h        -- Assume x is arbitrary and h : x ∈ setA
                   -- h : x = 1 ∨ x = 2 (by definition of setA)
                   -- Goal: x ∈ setB (i.e., x = 1 ∨ x = 2 ∨ x = 3)
  cases h with     -- Case analysis on x = 1 ∨ x = 2
  | inl h1 =>      -- Case: h1 : x = 1
    left; exact h1 -- Choose left disjunct of 1 ∨ 2 ∨ 3, 
                   -- provide proof h1
  | inr h2 =>      -- Case: h2 : x = 2  
    right; left; exact h2 -- Choose middle disjunct of 1 ∨ 2 ∨ 3, 
                          -- provide proof h2
```

**The pattern here**: We decompose the disjunction (∨, "or" statement) in our
assumption, then reconstruct the appropriate disjunction in our goal.

We can also verify specific membership examples:

```lean4
example : 1 ∈ setA := by left; rfl   -- 1 ∈ {1, 2} because 1 = 1
example : 2 ∈ setA := by right; rfl  -- 2 ∈ {1, 2} because 2 = 2
example : 1 ∈ setB := by left; rfl   -- 1 ∈ {1, 2, 3} because 1 = 1
example : 2 ∈ setB := by right; left; rfl  -- 2 ∈ {1, 2, 3} 
                                           -- because 2 = 2
```

#### Satisfying Formalization

Working through Rasiowa's definitions in Lean suggests how formal mathematics
might bridge the gap between intuitive mathematical reasoning and precise
computational verification. The tactical proofs we've constructed mirror the
logical steps that Rasiowa outlines in her textbook, but with each inference
made explicit and checkable.

The process of translating mathematical prose into Lean tactics has been
illuminating. When Rasiowa writes "from the definition of subset it follows
that," we see this unfold as specific rewrite rules and logical transformations
in our proofs. Her informal reasoning about witnesses and contradictions becomes
structured case analysis and explicit proof construction.

#### Discovering the Connection

What seems to emerge from this formalization is not a translation between
different
mathematical systems, but rather the recognition that classical set theory and
type-theoretic foundations might describe the same mathematical reality through
different lenses. Rasiowa's insight that sets can be viewed as
properties -- explicitly stated when she writes "$A(x)$" to mean "$x$ has
property $A$" -- is what Lean encodes as `α → Prop`.

The logical structure remains identical: subset relations are universal
implications, empty set proofs rely on vacuous truth, and set equality follows
from extensionality. The formalization doesn't change the mathematics; it seems
to make visible the logical architecture that was present in Rasiowa's careful
exposition.

This experience echoes what Terence Tao described in his conversation with
Lex Fridman -- Lean 4 formal verification makes mathematical reasoning both more
accessible and more rigorous. Working through Rasiowa's foundational concepts in
Lean reveals how classical mathematical exposition and modern proof assistants
serve the same goal: making mathematical truth both discoverable and
verifiable. That leads also to formal verification of algorithms and
computer programs, which is another topic that I hope to explore in the future.

#### Next Steps

That series of posts is the longest material on that blog so far, and it covers
only four pages of Rasiowa's book. I've started that as a single blog post, but
it escalated
quickly. The next section of the textbook covers the concept of union of sets
and, God willing, I hope to cover it in the next post.

If any real mathematician got that far, please let me know if I made any
mistakes or if you have any comments or suggestions. I would also like to hear
from anyone who is learning lean if that kind of deep dive is useful for them.