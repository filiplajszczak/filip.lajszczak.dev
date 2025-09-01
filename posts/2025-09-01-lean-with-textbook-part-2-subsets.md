title: Lean 4 with a Math Textbook - Part 2 - Subsets
date: 2025-09-01 21:00
tags: lean, math, learning, rasiowa
style: math
---

*We continue our systematic exploration of Helena Rasiowa's "Introduction to
Modern Mathematics" through Lean 4
formalization ([see introduction](/lean-4-with-a-math-textbook---part-0---introduction.html)).
Having established how sets and membership work through predicate encoding
in [Part 1](/lean-4-with-a-math-textbook---part-1---defining-sets-and-membership.html),
we now move to subset relations.*

#### Subset Relations: Formula (5)

Rasiowa's definition:

> If every element of a set $A$ is an element of a set $B$, then we say that
*$A$ is a subset of $B$*. We also say that *the set $A$ is contained in the
set $B$* or that $B$ *contains* $A$, which is written $A \subseteq B$
> or $B \supseteq A$.

She then gives the formal condition:

> By definition, $A \subseteq B$ *if and only if the following condition is
satisfied for every $x$*: *if $x \in A$, then $x \in B$*.

In her symbolic notation:

$$(A \subseteq B) \leftrightarrow (\textit{for every } x : x \in A
\Rightarrow x \in B) \tag{5}$$

**This translates directly to Lean**:

```lean4
def subset (A B : RasiowaSet α) : Prop := ∀ x, x ∈ A → x ∈ B
infixr:50 " ⊆ " => subset
infixr:50 " ⊇ " => fun A B => B ⊆ A  -- superset notation: 
                                     -- A ⊇ B means B ⊆ A
```

**Proper subsets**: Rasiowa mentions in a footnote that when sets A and B are
not identical, "it is said that $A$ is a *proper* subset of $B$." A proper 
subset relationship means $A$ is contained in $B$, but $A$ and $B$ are not equal—there 
exists at least one element in $B$ that's not in $A$.

```lean4
- Proper subset: A ⊂ B means A ⊆ B and A ≠ B (Rasiowa's footnote)
def proper_subset (A B : RasiowaSet α) : Prop := A ⊆ B ∧ A ≠ B
infixr:50 " ⊂ " => proper_subset
```

**Perfect correspondence**: Both Rasiowa and Lean express subset as universal
quantification (∀ - "for all") over an implication (→ - "if...then"). The
mathematical content is identical.

**Making the connection explicit**: While Lean automatically understands that
our infix notation `A ⊆ B` means the same as the logical formula
`∀ x, x ∈ A → x ∈ B`, it's educational to state this equivalence explicitly:

```lean4
theorem subset_def (A B : RasiowaSet α) :
  A ⊆ B ↔ ∀ x, x ∈ A → x ∈ B := by rfl
```

This theorem proves the equivalence using `rfl` (reflexivity) because the two
sides are **definitionally equal**—the infix notation `⊆` is syntactic sugar
that expands to the logical formula. This explicit statement seems to help
bridge the gap between mathematical notation and formal logic, suggesting that
Rasiowa's textbook definition and our Lean encoding are expressing identical
mathematical content.

Rasiowa provides several concrete examples:

> The set of all integers is contained in the set of all rational numbers, since
> every integer is a rational number. The set $A = \{1, 2\}$ is contained in the
> set $B = \{1, 2, 3\}$, since $1 \in B$ and $2 \in B$. [...] The set of all
> irrational numbers is contained in the set of all real numbers, since every
> irrational number is a real number.

#### When Sets Are not Subsets: Formula (6)

Rasiowa also explains when sets are not subsets:

> The statement that $A$ is not a subset of $B$ is written $A \nsubseteq B$
> or $B \nsupseteq A$. [...] It follows from the definition of a subset
> that $A \nsubseteq B$ *if and only if not every element of the set $A$ is an
element of the set $B$*, that is, *there exists in the set $A$ an element which
is not an element of $B$*. In symbolic notation:
>
> $$\sim(A \subseteq B) \Leftrightarrow (\textit{there is an } x \textit{ such that: } x \in A \textit{ and } \sim(x \in B)) \tag{6}$$

She provides this example: "The set of all integers divisible by 3 is not
contained in the set of all integers divisible by 6, since there exists an
integer divisible by 3 which is not divisible by 6, e.g., the number 9."

**Lean proof tactics we'll use:**

The `constructor`
tactic ([see](https://lean-lang.org/doc/reference/latest//Tactic-Proofs/Tactic-Reference/#constructor))
splits bidirectional statements (if and only
if, ↔) into two separate goals: the forward direction (→) and the reverse
direction (←).

The `intro`
tactic ([see](https://lean-lang.org/doc/reference/latest//Tactic-Proofs/Tactic-Reference/#intro))
handles assumptions: for universal quantifiers (∀) it introduces variables, and
for implications (→) it assumes the hypothesis.

The `rewrite`
tactic ([see](https://lean-lang.org/doc/reference/latest//Tactic-Proofs/Tactic-Reference/#rewrite))
replaces expressions using equality or equivalence.
The syntax `rewrite [theorem_name] at hypothesis` applies the rewrite to a
specific hypothesis.

The `cases`
tactic ([see](https://lean-lang.org/doc/reference/latest//Tactic-Proofs/Tactic-Reference/#cases))
performs case analysis on inductive types like
disjunctions (∨), existentials (∃), and conjunctions (∧).

The `have` tactic introduces intermediate results. The syntax
`have name : type := proof` creates a new hypothesis that can be used in
subsequent steps.

The `exact`
tactic ([see](https://lean-lang.org/doc/reference/latest///Tactic-Proofs/Tactic-Reference/#exact))
provides a proof term that exactly matches the current
goal. It's used when we have the precise evidence needed to complete the proof
step.

The dots (·) are Lean's bullet points - they help organize structured proofs by
clearly separating different cases or subgoals.

The `theorem` keyword creates a named proof that can be referenced
later. Unlike `example` (which is anonymous), theorems become part of our
mathematical library and can be used in other proofs.

```lean4
theorem not_subset_iff (A B : RasiowaSet α) :
  ¬(A ⊆ B) ↔ ∃ x, (x ∈ A ∧ x ∉ B) := by
  constructor  -- Split bidirectional proof 
               -- into forward and reverse directions
  · -- Forward: ¬(A ⊆ B) → ∃ x, (x ∈ A ∧ x ∉ B)
    intro h  -- Assume h : ¬(A ⊆ B)
    rewrite [subset_def] at h  -- Use our explicit theorem to unfold:
                               -- h : ¬(∀ x, x ∈ A → x ∈ B)
    rewrite [not_forall] at h  -- Apply logical equivalence:
                               -- h : ∃ x, ¬(x ∈ A → x ∈ B)
    cases h with  -- Extract witness from existential
    | intro x hx =>  -- hx : ¬(x ∈ A → x ∈ B)
      rewrite [not_imp] at hx  -- Apply ¬(P → Q) ↔ (P ∧ ¬Q):
                               -- hx : x ∈ A ∧ x ∉ B
      exact ⟨x, hx⟩  -- Provide witness x with proof hx
  · -- Reverse: ∃ x, (x ∈ A ∧ x ∉ B) → ¬(A ⊆ B)
    intro h  -- Assume h : ∃ x, (x ∈ A ∧ x ∉ B)
    cases h with  -- Extract witness from existential
    | intro x hx =>  -- hx : x ∈ A ∧ x ∉ B
      cases hx with  -- Destructure conjunction
      | intro hx_in_A hx_not_in_B =>  -- hx_in_A : x ∈ A,
                                      -- hx_not_in_B : x ∉ B
        intro h_subset  -- Assume h_subset : A ⊆ B (for contradiction)
        have hx_in_B : x ∈ B := h_subset x hx_in_A  -- Apply subset 
                                                    -- to get x ∈ B
        exact hx_not_in_B hx_in_B  -- Contradiction: x ∉ B but x ∈ B
```

This proof establishes the logical equivalence that Rasiowa describes: $A$ is
not a subset of $B$ exactly when there exists some element in $A$ that's not
in $B$.

Let's go through that proof step by step in ordinary mathematical language to
illustrate the equivalence between formal and informal reasoning:

**Forward direction**: We want to show that if $A$ is not a subset of $B$, then
there exists some element in $A$ that's not in $B$.

Suppose $A$ is not a subset of $B$. By definition, this means it's not the case
that every element of $A$ is in $B$. In classical logic, "not every" is
equivalent to "there exists some... not", so there must exist some element $x$
such that $x \in A$ but $x \notin B$. This is exactly what we wanted to prove.

**Reverse direction**: We want to show that if there exists some element in $A$
that's not in $B$, then $A$ is not a subset of $B$.

Suppose there exists some specific element $x$ such that $x \in A$
and $x \notin B$. Now assume, for the sake of contradiction,
that $A \subseteq B$. Then by definition of subset, every element of $A$ must be
in $B$. In particular, since $x \in A$, we must have $x \in B$. But we also
know $x \notin B$—contradiction! Therefore our assumption was wrong,
and $A \nsubseteq B$.

#### Set Equality: Formula (7)

Rasiowa defines when two sets are equal:

> The sets $A$ and $B$ are *identical* *if and only if they have the same
elements*. This is written as follows:
>
> $$(A = B) \Leftrightarrow (\textit{for every } x : x \in A \Leftrightarrow x \in B) \tag{7}$$

**In Lean, this is set extensionality theorem:**

```lean4
theorem set_extensionality (A B : RasiowaSet α) :
  A = B ↔ ∀ x, (x ∈ A ↔ x ∈ B) := by
  constructor  -- Split bidirectional proof into forward and reverse
  · -- Forward direction: if A = B, then same membership
    intro h x  -- Assume h : A = B, let x be arbitrary
    rw [h]     -- Rewrite goal using A = B: 
               -- x ∈ A ↔ x ∈ B becomes x ∈ B ↔ x ∈ B
               -- which is trivially true by reflexivity
  · -- Reverse direction: if same membership, then A = B
    intro h    -- Assume h : ∀ x, (x ∈ A ↔ x ∈ B)
    funext x   -- Function extensionality: 
               -- to prove A = B (functions equal),
               -- show A x = B x for all x
    exact propext (h x)  -- Propositional extensionality: 
                         -- since h x proves
                         -- x ∈ A ↔ x ∈ B, 
                         -- propositions A x and B x are equal
```

This theorem establishes what Rasiowa states: two sets are equal exactly
when they have the same element -- the basic principle of set
extensionality.

With subset relations and set equality formalized, we're ready to explore the
deeper mathematical properties that follow from these definitions. Rasiowa's
next step is to demonstrate the basic properties that every mathematical
structure built on subsets must satisfy—properties like reflexivity,
transitivity, and antisymmetry that reveal the underlying logical architecture
of set theory.

**Next**: [Part 3 - Properties of Subsets](/lean-4-with-a-math-textbook---part-3---properties-of-subsets.html)
