title: Lean 4 with a Math Textbook - Part 1 - Defining Sets and Membership
date: 2025-09-01 20:00
tags: lean, math, learning, rasiowa
style: math
---

*We start our exploration of Helena Rasiowa's "Introduction to Modern
Mathematics" through Lean 4 formalization. We're working through Chapter I,
Section 1 on the concept of sets, translating classical mathematical definitions
into type-theoretic
foundations. [See the introduction](/lean-4-with-a-math-textbook---part-0---introduction.html)
for context and motivation.*

#### Textbook Definition vs Lean's Predicate Encoding

Rasiowa begins Chapter I with:

> The concept of *set* is one of the fundamental concepts of mathematics. As
> examples of sets one may quote: the set of all books in a given library; the
> set of all letters of the Greek alphabet; the set of all integers; the set of all
> sides of a given polygon; the set of all circles on a given plane.

She then establishes her definition of membership:

> The objects which belong to a given set are called its *elements*. The
> statement that an *element a belongs to a set A* (or: that *a is an element of
a
set A*) is written:
> $$a \in A \tag{1}$$

When introduced in the textbook, sets simply are collections of objects but
despite this presentation, Rasiowa explicitly connects sets to
**properties**. To clearly establish connection with Lean's representation of 
sets we need to jump briefly forward to Section 5:

> When the subsets of a given universe $X$ are considered, the concept of subset
> is often identified with that of the *property* which is an attribute of every
> element of that subset and is not an attribute of any other element of that
> universe. Then, if $A \subseteq X$, $x \in A$ is replaced in writing by $A(x)$
> and read $x$ *has the property* $A$.

This seems to provide an important bridge to our programmatic lean encoding.
Rasiowa shows that sets and properties are two ways of expressing the same mathematical
content. Property based definitions is what we would use to formalize sets in Lean.

**To encode this in Lean, we need to do some setup first**

First, we import classical logic for reasoning about negations and
contradictions:

```lean4
open Classical
```

The `open Classical` directive gives us access to classical logical principles
like the law of excluded middle (every proposition is either true or false) and
proof by contradiction. While not needed for our basic definitions, these will
become essential when we prove properties involving negations and "not subset"
relations.

This raises an interesting question about foundations. Dependent type theory (as
discussed
in [the introduction](/lean-4-with-a-math-textbook---part-0---introduction.html))
is often associated with constructive logic, where we prove existence by
construction rather than by contradiction. Yet here we use classical reasoning
to formalize Rasiowa's classical set theory. Lean's approach seems to be pragmatic: its
foundational logic is constructive by default, but classical principles are
available as axioms when needed. Since Rasiowa's textbook reasoning is
inherently classical (she uses proof by contradiction and assumes excluded
middle), we follow her mathematical style rather than attempting a constructive
reinterpretation. This choice prioritizes faithful representation of her
mathematical reasoning over foundational purity.

These foundational questions become particularly relevant when considering Rasiowa's later sections on axioms of set theory (Section 6), axioms of set theory more broadly (Section 9), and her discussion of axiomatic approaches including Russell's paradox (Section 10). If we eventually work through those sections, we'll encounter deeper questions about how different foundational systems—classical set theory, constructive type theory, and various axiomatic approaches—relate to each other.

Next, we need to declare a **universe level**:

```lean4
universe u
```

[Universe levels](https://lean-lang.org/doc/reference/latest/The-Type-System/Universes/)
solve [Russell's paradox](https://en.wikipedia.org/wiki/Russell's_paradox) in type theory. We can't have a "type of all types"
because that leads to contradictions. Instead, Lean creates a hierarchy:
`Type 0`, `Type 1`, `Type 2`, etc. The declaration `universe u` introduces a
universe level variable that can be any level in this hierarchy.

Next, we need to declare a **type variable**:

```lean4
variable {α : Type u}
```

Type variables like `α : Type u` let us write generic definitions that work for
any element type. Instead of writing separate definitions for `NatSet`,
`StringSet`, `BoolSet`, etc., we write one definition `RasiowaSet α` that works
for any type `α`. The curly braces `{α : Type u}` make `α` an implicit
parameter—Lean infers it from context so we don't have to write it explicitly
every time.

And finally, we can define our **RasiowaSet** type:

```lean4
def RasiowaSet (α : Type u) : Type u := α → Prop
```

In Lean, `Prop` is the type of propositions—statements that
can be either true or false. Examples include `2 + 2 = 4` (true), `1 = 0` (
false), or `x > 5` (depends on x). Unlike computations that return values,
propositions require proofs to establish their truth.

So `α → Prop` means "a function that takes an element of type α and returns a
proposition." This appears to capture the idea of a property: give me an
element, and I'll tell you a statement about whether that element satisfies the
property.

Of course there is already a built-in set type for this in Lean, but we declare
our own `RasiowaSet` so we could later build on top of it.

Textbook sets and Lean's predicate functions appear to represent the same mathematical 
concept through different foundations:

- **Textbook**: Sets are collections; membership is primitive; properties emerge
  from subsets
- **Lean**: Properties are primitive; sets are predicates; membership becomes
  function application

**The membership translation**:

```lean4
def mem (a : α) (A : RasiowaSet α) : Prop := A a
```

Since we declared `variable {α : Type u}` at the top, Lean automatically infers
the type parameter in all our definitions.

So, membership is defined as a function that takes an element `a` of type `α`
and a predicate `A` of type `RasiowaSet α`, then applies the predicate `A` to
the element `a`.

**But we want to use mathematical notation `∈` instead of `mem`**:

```lean4
infixr:50 " ∈ " => mem
```

This declares `∈` as a right-associative infix operator with precedence 50. The
`infixr:50` part handles parsing (how Lean reads the symbols), while `=> mem`
gives it computational meaning (what function actually gets called). When we
write `a ∈ A`, Lean translates it to `mem a A` behind the scenes.

When we write `a ∈ A` in Lean, it unfolds to `A a`—the proposition that "a has
property A." Since `A : RasiowaSet α` is defined as `α → Prop`, it means `A` is
a function that takes an element of type `α` and returns a proposition (`Prop`).
When we apply `A` to element `a`, we get `A a : Prop`—a proposition that is
either provable (true) or not provable (false). If `A a` is provable, we say "a
satisfies the property A" or "a has property A." If `A a` is not provable,
then "a does not have property A."

For example, if `A` represents "is even", then `A 4` is the proposition "4 is
even" (provable) and `A 3` is the proposition "3 is even" (not provable). So
`4 ∈ A` is true, but `3 ∈ A` is false. This connects directly to Rasiowa's
insight: sets and properties are the same thing viewed from different angles.

#### Non-membership: Formula (2)

Rasiowa defines non-membership in formula (2):

> The statement that $a$ does not belong to a set $A$ (i.e., $a$ is not an
> element of the set $A$) will be written:
> $$a \notin A \quad \text{or} \quad \sim(a \in A) \tag{2}$$
>
> The symbol $\sim$ will always stand for *not* or *it is not the case that*.

In Lean, we define this as the negation of membership:

```lean4
def not_mem (a : α) (A : RasiowaSet α) : Prop := ¬(a ∈ A)
infixr:50 " ∉ " => not_mem
```

#### The Empty Set

Rasiowa introduces the empty set:

> It is convenient to introduce in mathematics the concept of *empty set*, i.e.,
> the set which has no elements. It may be said, for instance, that the set of all
> real roots of the equation $x^2 + 1 = 0$ is empty instead of there does not
> exist any real number which is a root of the equation $x^2 + 1 = 0$.

She notes that "The empty set is denoted by $\varnothing$."

**In Lean's predicate encoding**:

```lean4
def empty : RasiowaSet α := fun _ => False
notation "∅" => empty
```

The `fun _ => False` syntax creates a function (lambda) that ignores its
argument (indicated by `_`) and always returns `False`. This captures the idea
that no element satisfies the empty set condition.

The empty set is the condition that's never satisfied. For any element `a`:

- `a ∈ ∅` becomes `empty a` (by definition of `∈`)
- `empty a` becomes `(fun _ => False) a` (by definition of `empty`)
- This beta-reduces to `False` (lambda function application)

#### Finite Sets and Singleton Sets: Formulas (3) and (4)

Rasiowa introduces notation for finite sets:

> The set whose all elements are $a_1, \dots, a_n$ will be denoted by
> $$\lbrace a_1, \dots, a_n \rbrace \tag{3}$$

She then defines singleton sets:

> A set may also consist of one element. For instance, the set of all even prime
> numbers has exactly one element, namely the number $2$. A set whose only element
> is $a$ will, by analogy to (3), be denoted by
> $$\lbrace a \rbrace \tag{4}$$

**In Lean, we can define singleton sets:**

```lean4
def singleton (a : α) : RasiowaSet α := fun x => x = a
```

This defines a singleton set containing only element `a` as the predicate "x
equals a".

#### Walking Through a Concrete Example

To see how our encoding works in practice, let's define a concrete set and prove
that a specific element belongs to it. We'll work with the
set $\lbrace 1, 2 \rbrace$ and demonstrate the step-by-step process of
membership verification.

The `example` keyword creates an anonymous proof for demonstration purposes.
Unlike `theorem`, it doesn't give the proof a name we can reference later - it
simply verifies that the statement is provable.

**Tactics** are commands that help construct proofs interactively - they
transform proof goals step by step until we reach something provable. Here we
use the `by` keyword to enter tactic mode for step-by-step proof construction.
The `right`
tactic ([see](https://lean-lang.org/doc/reference/latest///Tactic-Proofs/Tactic-Reference/#right))
chooses the right side of a disjunction (∨) - here
proving
`2 = 2` instead of `2 = 1`. The `rfl`
tactic ([see](https://lean-lang.org/doc/reference/latest//Tactic-Proofs/Tactic-Reference/#rfl))
proves the goal `2 = 2` by
reflexivity of equality.

```lean
-- Define a set containing 1 and 2
def exampleSet : RasiowaSet Nat := fun x => x = 1 ∨ x = 2

-- Check if 2 belongs to this set
example : 2 ∈ exampleSet := by
  -- Step 1: 2 ∈ exampleSet becomes mem 2 exampleSet
  -- Step 2: By definition of mem: exampleSet 2  
  -- Step 3: By definition of exampleSet: (fun x => x = 1 ∨ x = 2) 2
  -- Step 4: Beta reduction: 2 = 1 ∨ 2 = 2
  -- Step 5: This is provable using the right disjunct: 2 = 2
  right
  rfl
```

**Beta reduction** is the process of applying a lambda function to its
argument—replacing the parameter with the actual value.

Now that we've established the basic encoding of sets as predicates and
seen how membership works in practice, we can move beyond individual elements to
explore relationships between entire sets. The next natural step in Rasiowa's
development is the concept of subsets—when one set is entirely contained within
another. This will introduce us to universal quantification in Lean and show how
mathematical statements about "all elements" translate into formal proofs.

**Next**: [Part 2 - Subsets](/lean-4-with-a-math-textbook---part-2---subsets.html)
