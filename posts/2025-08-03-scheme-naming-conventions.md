title: %scheme-naming-conventions
date: 2025-08-03 15:04
tags: guile, scheme
style: plain
---

Scheme's naming conventions are scattered across different sources - some appear
in the standards, others in implementation-specific documentation, and some are
learned only by reading established codebases
like [Guix](https://guix.gnu.org/), [Haunt](https://dthompson.us/projects/haunt.html)
and other [David Thompson's libraries](https://dthompson.us/projects.html), and
other well-designed Scheme projects. While these conventions are individually
straightforward, I haven't found them gathered comprehensively in one place.
This post attempts to piece together Scheme's naming conventions from various
fragments of documentation and real-world code.

The most distinctive convention is **predicates with question marks** (`?`) -
procedures that return boolean values. This pattern appears throughout Scheme
code: `(null? lst)`, `(string? obj)`, `(procedure? obj)`, `(even? n)`. The
question mark immediately indicates the procedure is asking a yes/no question,
similar to Ruby's predicate methods (which makes sense
given [Matz's Scheme inspiration](https://joromir.cc/blog/2024/05/25/understanding-bang-methods-naming-convention-ruby/)).

Another pattern is **mutating procedures with exclamation marks** (`!`) for
operations that have side effects: `(set! variable value)`,
`(vector-set! vec index value)`, `(string-set! str index char)`. This serves as
a warning that the procedure will mutate something - while mutation is possible
in Scheme, it's generally avoided in functional-style code, making these markers
particularly important.

**Constants with percent prefixes** (`%`) appear frequently
in [Guix source code](https://codeberg.org/guix/guix): `%load-path`,
`%site-dir`, `%default-port-encoding`. This pattern in Guix and
other [Guile](https://www.gnu.org/software/guile/) codebases helps distinguish
constants from regular variables.

**Hyphenated identifiers** are remarkably consistent:
`(current-working-directory)`, `(make-hash-table)`, `(string-append str1 str2)`.
Multi-word identifiers are highly readable, and this pattern holds across
virtually all Scheme code.

**Type names with angle brackets** appear in some implementations: `<list>`,
`<string>`, `<procedure>`. This convention is less universal than others -
appearing more frequently in certain implementations than others.

These conventions encode semantic information directly in identifier names,
making code self-documenting. When you see `(empty? my-list)`, it's immediately
clear that it's checking if the list is empty and returning a boolean.

Another pattern is **asterisk variations** (`*`): **procedure variations** like
[`let*`
](https://www.gnu.org/software/guile/manual/html_node/Local-Bindings.html) 
(sequential binding) vs `let` (parallel binding), and [`define*`
](https://www.gnu.org/software/guile/manual/html_node/lambda_002a-and-define_002a.html)
which allows keyword arguments vs basic `define`.

There are other **conventional prefixes**: **`with-`** establishes dynamic
state (`with-output-to-file`), and **`call-with-`** calls procedures with
specific arguments or cleanup needs (`call-with-input-file`). These patterns
become particularly clear when you see them used consistently across
well-designed libraries.

The [R5RS Scheme standard](https://conservatory.scheme.org/schemers/Documents/Standards/R5RS/HTML/r5rs-Z-H-4.html#%_sec_1.3.5)
formalizes many of these conventions and adds others: **type-specific prefixes**
like `char-`, `string-`, `vector-` for related procedures; **conversion
procedures** using `type1->type2` format (`vector->list`, `string->symbol`); and
**numeric comparators** as exceptions to the predicate rule - they use
mathematical symbols (`=`, `<`, `>`, `<=`, `>=`) instead of question marks.

The consistency across the entire ecosystem means that once you learn these
patterns, you can make educated guesses about unfamiliar procedures and usually
be right. The standard explicitly recommends that "programmers employ these same
conventions in their own code whenever possible," showing these are deliberate
design choices meant to be followed consistently.

Much of this information is scattered across different
sources: [The Scheme Programming Language, 4th Edition](https://www.scheme.com/tspl4/intro.html#./intro:h2)
covers basic conventions in Section 1.2,
the [Scheme Wiki](http://community.schemewiki.org/?variable-naming-convention)
has community-gathered patterns, and
the [R5RS Scheme Standard
](https://conservatory.scheme.org/schemers/Documents/Standards/R5RS/HTML/r5rs-Z-H-4.html#%_sec_1.3.5)
formalizes some rules. For style
guidance, [Riastradh's Lisp Style Rules](https://mumble.net/~campbell/scheme/style.txt)
provides comprehensive guidelines that projects
like [Guix](https://guix.gnu.org/manual/en/html_node/Formatting-Code.html)
follow, while
the [Racket Naming conventions
](https://docs.racket-lang.org/racket-glossary/index.html#%28part._.Naming_conventions%29)
offers implementation-specific advice.

