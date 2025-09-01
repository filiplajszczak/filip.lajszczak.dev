title: Lean 4 with a Math Textbook - Part 0 - Introduction
date: 2025-09-01 19:00
tags: lean, math, learning, rasiowa
style: plain
---

In a recent Lex Fridman [conversation with Terence
Tao](https://lexfridman.com/terence-tao) an important
[part](https://lexfridman.com/terence-tao-transcript#chapter10_ai_assisted_theorem_proving)
was dedicated to his discovery and use of [Lean 4](https://lean-lang.org/) for
formalizing mathematics. Tao also talks about how readable and
accessible Lean is, and how professional mathematicians, students, and
hobbyists can all use it. He
mentions [mathlib project](https://github.com/leanprover-community/mathlib4)
that is a community-driven effort to build a
unified library of
mathematics, [Equational Theories Project](https://teorth.github.io/equational_theories/)
he initiated, and
[formalization](https://github.com/teorth/analysis) of his
own [Analysis textbook](https://terrytao.wordpress.com/books/analysis-i/).

To dip my toes into Lean and theorem proving, I wanted to start with
something concrete and structured. I found a perfect candidate in [Helena
Rasiowa's](https://en.wikipedia.org/wiki/Helena_Rasiowa) "Introduction to Modern
Mathematics", a classic textbook that
systematically builds mathematical foundations. Rasiowa's book first appeared in
Polish as "Wstęp do matematyki współczesnej" in 1967, with an English
translation published in 1973. It had fourteen almost unchanged editions
(last in 2004) and is still used as one of the standard textbooks in
[Introduction to
Mathematics](https://usosweb.mimuw.edu.pl/kontroler.php?_action=katalog2/przedmioty/pokazPrzedmiot&kod=1000-111bWMAa)
course at the University of Warsaw where 1st year students are introduced to
academic mathematics.

I'm starting with a very beginning of the book, Chapter I, Section 1, The
concept of set. It's a very short section, only 4 pages long, and
covers membership, subsets, and the empty set. It is short, but it took me
quite some time to translate it into Lean. The goal is to explain it in a
way that is accessible to someone like me when I was starting out, so
assuming familiarity with basic mathematical concepts, but no prior
experience with formalization or computer-assisted theorem proving but
having some programming experience. The heavily
commented code with is available in
the [repository](https://github.com/filiplajszczak/rasiowa-formalization/blob/master/Rasiowa/Section1.lean). All book quotes are taken from the 1973 English edition.

But working through this formalization revealed something unexpected: Lean
isn't built on the same set-theoretic foundations that Rasiowa teaches. Instead,
it uses something called [dependent type
theory](https://en.wikipedia.org/wiki/Dependent_type) as its mathematical foundation.

Rasiowa's book builds on set theory -- the idea
that mathematical objects are sets, and mathematical statements are about
membership, subsets, and set operations. Dependent type theory offers an
alternative foundation where instead of sets being the basic building blocks, we start with
types (like "natural numbers" or "real numbers") and functions between
types. What makes it "dependent" is that types can depend on values -- for
example, the type "vectors of length n" depends on the specific number n. This
creates a rich system where mathematical propositions are themselves types, and
proofs are programs that construct values of those types.

While this might sound abstract, dependent type
theory works well for formalizing mathematics, and it's what
underlies modern proof assistants like Lean.

When Rasiowa published her book in late 60s, dependent type theory didn't
exist as we know it today. The concepts were just emerging through the work of
[Per Martin-Löf](https://en.wikipedia.org/wiki/Per_Martin-L%C3%B6f) and others,
evolving alongside functional programming languages
in the 1970s and 1980s. This creates a curious situation: dependent type theory
appears as an advanced, highly technical subject when encountered through modern
proof assistants, yet it serves as an alternative foundational system for
mathematics -- potentially as basic as the set theory Rasiowa teaches.

Formalization isn't a translation between different mathematical systems, but
rather the recognition that classical mathematics and type-theoretic foundations
describe identical mathematical structures through different lenses. Lean can
work with classical logic when needed, including principles like
the [law of excluded
middle](https://en.wikipedia.org/wiki/Law_of_excluded_middle) that appear in
Part 2 of this series.

Here we begin our descent into the rabbit hole of formalizing concepts that
mathematicians cheerfully wave away as "trivial" or "obvious".

**Series so far:**

- [Part 1 - Defining Sets and Membership](/lean-4-with-a-math-textbook---part-1---defining-sets-and-membership.html)
- [Part 2 - Subsets](/lean-4-with-a-math-textbook---part-2---subsets.html)
- [Part 3 - Properties of Subsets](/lean-4-with-a-math-textbook---part-3---properties-of-subsets.html)

