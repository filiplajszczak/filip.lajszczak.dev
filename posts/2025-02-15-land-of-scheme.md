title: My Land of Scheme 2025
date: 2025-02-15 08:00
tags: goblins, guile, guix, haunt, mes, pre-scheme, racket, reproducibility, scheme, shepherd, spritely
style: plain
---

I’ve been wandering in the land of Scheme for a while now. While I normally live
in the [land of snakes](https://www.pythonanywhere.com/), my holiday home is
built of parentheses. Usually, I’m there to relax, especially during the
[Advent of Code](https://adventofcode.com/) season, where I try solving some
problems in Scheme.
In [2021](https://github.com/filiplajszczak/advent-of-code-2021),
I used Racket, and in
[2022](https://github.com/filiplajszczak/advent-of-code-2022),
[2023](https://github.com/filiplajszczak/advent-of-code-2023), and
[2024](https://github.com/filiplajszczak/advent-of-code-2024), I switched to
Guile. I’ve also ported some algorithms from
[Racket](https://docs.racket-lang.org/algorithms/index.html)
to [Guile](https://guile-algorithms.lajszczak.dev/). While I’m not an expert,
I’m no longer intimidated by Scheme.

Recently, I had a conversation with someone who encountered Scheme during their
university years in the 1990s. At the time, they saw no commercial value in it
and moved on to other languages. When I mentioned that Scheme still had pockets
of relevance, they asked for more details. That’s why I’m writing this post: to
offer my perspective on the state of Scheme in 2025 - what’s available, what’s
being done, and what might be possible in the future.

#### Haunt and This Blog

First, let’s start here:
[this very blog](https://git.sr.ht/~filiplajszczak/filip-lajszczak-dev) is built
using [Haunt](https://dthompson.us/projects/haunt.html), a static site generator
written in [Guile Scheme](https://www.gnu.org/software/guile/). The
[templates](https://git.sr.ht/~filiplajszczak/filip-lajszczak-dev/tree/master/item/theme.scm)
are written in SXML, a Scheme representation of XML. It’s deployed on SourceHut,
built in a [Guix System 
container](https://git.sr.ht/~filiplajszczak/filip-lajszczak-dev/tree/master/item/.build.yml),
making it a Scheme-driven process. Setting it all up was straightforward and
fun. This is my second project in Haunt, the first being
the [awesome list of sites built with Haunt](https://awesome.haunt.page/).
I’ve also contributed some small improvements to Haunt itself, notably
[automation for Haunt deployment on SourceHut](https://git.dthompson.us/haunt/commit/?id=f93126a099712286b760900c1dc543b54a5ebf1c).

#### Guix and the Shepherd

One of the first things that drew me into the Scheme ecosystem was
[Guix](https://guix.gnu.org/). It’s a functional package manager and the
foundation of the Guix System, a complete, declarative operating system. Similar
to [Nix](https://nixos.org/), it uses Scheme as its configuration language.
Thanks to its functional approach, Guix offers transactional upgrades and
rollbacks, reproducible builds, and per-user package management. Think of it
like
Python’s virtualenv, but on a system-wide scale. Using Guix, you can specify
your entire system configuration in Scheme and version control it like any
other piece of code.

Essential to the Guix System is
[the Shepherd](https://www.gnu.org/software/shepherd/), an init system written
and configured in Guile Scheme. Unlike systemd or SysV init, the Shepherd
expresses system services as Scheme code, allowing you to manage dependencies
and service lifecycles in a highly configurable, introspectable way. Check out
the recent[FOSDEM 
talk](https://fosdem.org/2025/schedule/event/fosdem-2025-5720-the-shepherd-minimalism-in-pid-1/)
for more details.

In many ways, Guix feels like a modern [Lisp 
Machine](https://en.wikipedia.org/wiki/Lisp_machine): the entire system is
defined in a single high-level language, enabling deep metaprogramming. System
configuration is just another program, so you can take advantage of Scheme
features - like higher-order procedures and macros - to explore, customize, and
extend almost any part of the system, from package definitions to service
configurations.

#### GNU Mes and the Importance of Bootstrapping

A key part of the quest for full-system reproducibility is
[GNU Mes](https://www.gnu.org/software/mes/), which tackles the problem of
[bootstrapping from minimal, easily auditable source
code](https://bootstrappable.org/projects/mes.html). Mes includes a small
Scheme interpreter and a limited C compiler, capable of compiling itself and
then building more complex tools like the [Tiny C Compiler 
(TCC)](https://bellard.org/tcc/), eventually leading to the larger GCC 
toolchain. This reduces reliance on opaque binary blobs in the early
stages of system building and directly addresses the famous
[“Trusting Trust” attack](https://www.cs.cmu.edu/~rdriley/487/papers/Thompson_1984_ReflectionsonTrustingTrust.pdf),
where a compromised compiler could insert malicious code into all future
binaries. By providing a minimal, auditable software base, Mes helps ensure that
everything - from the very first lines of code onward - is as trustworthy and
reproducible as possible.

#### Spritely and Goblins

Another long-term vision I’m following in the land of Scheme is the
[Spritely Project](https://spritely.institute/). Its goal is to build a more
decentralized, user-empowering social web, moving away from giant monolithic
platforms toward a truly distributed internet. At the core of Spritely is the
[Goblins library](https://spritely.institute/goblins/) for Guile Scheme, which
implements a [capability-based](https://files.spritely.institute/papers/spritely-core.html)
system for secure distributed programming. That way Spritely aims to enable
private, federation-friendly interactions.

A related tool from the Spritely team is
[Hoot](https://spritely.institute/hoot/), a library that compiles Scheme code
to WebAssembly, enabling it to run in modern browsers. Recently, they even
managed to run Goblins in the browser - an achievement that relies on
cutting-edge
Wasm features like Wasm GC.

Combining efforts from Spritely and Guix, there’s also a project to run the
Shepherd on Goblins. This would introduce new security and flexibility options
for services, allowing them to communicate in a capability-secure manner. The
potential to safely compose services across different users and untrusted
systems is huge. Progress on this initiative was recently [reported at
FOSDEM](https://fosdem.org/2025/schedule/event/fosdem-2025-5315-shepherd-with-spritely-goblins-for-secure-system-layer-collaboration/),
and it looks promising.

#### Pre-Scheme Restoration

The last project I’d like to mention is the
[Pre-Scheme Restoration effort](https://prescheme.org/). Pre-Scheme is a
lesser-known dialect designed for systems programming - somewhere between
Scheme’s high-level expressiveness and C’s low-level efficiency. Originally
developed for [Scheme 48](https://www.s48.org/), Pre-Scheme allows writing
programs that compile down to C while still taking advantage of Scheme’s
metaprogramming. The restoration project aims to modernize Pre-Scheme and bring
it back into practical use.

In the context of Guix, Mes, and Spritely, Pre-Scheme bridges high-level Scheme
and low-level systems development. With Mes proving a Scheme-based bootstrap
possible and Spritely pushing Scheme into distributed computing, Pre-Scheme
offers an efficient way to write the underlying components while retaining the
clarity of Scheme. It’s a reminder that Scheme isn’t just an academic
curiosity - it’s an evolving ecosystem pushing the boundaries of what’s possible
in computing.

#### The Road Goes Ever On

These projects are driven by my personal interests, so if I’ve missed your
favorite Scheme initiative, let me know - I’d love to hear about it. There’s
plenty more happening around my summer house in the land of Scheme, and I’m
curious to see where the journey leads.
