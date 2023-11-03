title: Test-Driven Development with Python revisited
date: 2023-10-31 08:00
tags: tdd, python, book
style: plain
---

Harry Percival’s [Test-Driven Development with
Python](https://www.obeythetestinggoat.com/) was a transformative book for me,
so much so that I had to start a blog just to pay tribute to it. It has been
almost nine years since the publication of the book, six since the second
edition, and five since I was fortunate enough to read it. It was a ticket for
the vehicle that took me from the happy hobby hacking to a much more rigorous
land of professional software development.

![Harry Percival’s Test-Driven Development with Python book
cover](static/images/tdd-hjwp.png)

As for someone who had not practiced Test-Driven Development before, the most
valuable “Aha!” moment happened when the [concept of
spiking](https://www.obeythetestinggoat.com/book/chapter_spiking_custom_auth.html#_exploratory_coding_aka_spiking)
was introduced. I realized that all I had been doing until that point was just
exploratory coding or spiking. That does not mean that spiking is bad, it
is just not production-ready. You may think that in order to despike it, you
should just add tests, but TTD says: “No”. The right thing is to write tests,
and implement the same functionality
[again](https://www.obeythetestinggoat.com/book/chapter_spiking_custom_auth.html#_de_spiking),
step-by-step. Very often, the final test-driven code would be much better,
because you have already thought through the problem at least twice, first time
while spiking, and second time while writing the tests.

The scope of the book is much broader than just TDD, as the author took a
holistic approach embracing all layers of the web development stack. Of course,
Python and Django are the heart of it, but there is much more. Some layers are
only touched (like [rather minimalistic framework-less frontend
javascript](https://www.obeythetestinggoat.com/book/chapter_javascript.html)),
or [configuring an nginx
server](https://www.obeythetestinggoat.com/book/chapter_making_deployment_production_ready.html).
Other tools are introduced quietly in the background. For example [git version
control](https://www.obeythetestinggoat.com/book/chapter_01.html#_starting_a_git_repository)
is used through the whole book, and the proposed methodology is going beyond the
basic use cases.

Far from being limited to Django testing, the book gently introduces elements of
[functional
programming](https://www.obeythetestinggoat.com/book/chapter_hot_lava.html#_architectural_solutions),
practical use
of [decorators](https://www.obeythetestinggoat.com/book/chapter_fixtures_and_wait_decorator.html#_our_final_explicit_wait_helper_a_wait_decorator),
and bits and pieces of devops. Deployment chapters are not limited to one or
another platform as a service but go into lower level interaction with a server.

Levels of complexity are built up gradually. The reader is led by hand from
naive basic solutions to more advanced Django. From running tests by hand to
deployment of automation and [Continuous
Integration](https://www.obeythetestinggoat.com/book/chapter_CI.html). All of
that without jumping over intermediate steps and with proper explanation.

At all the stages it is clear that the book is about tests and testing and that
is the subject covered thoroughly. All the topics touched in the book are there
on purpose and all are covered to the extent required by the context.
Nevertheless, the author is deploying traffic lights and road signs to the
tangled
streets of the city-maze of modern web development.

The other nice thing about the book is that it is not an enclosed garden, but at
each step it is pointing to external sources and reference material, such as
books, articles, and conference talks. It is opening doors to the world of
disputes, controversies and clashing opinions related to software development
and architecture best practices.

At the moment of the publication, versions of the packages used in the book were
bleeding edge. As for today Python 3.6 and Django 1.11 are no longer exactly the
versions one would use, but they are still very close to the current state of
the technological stack, as both Django and Python are quite stable. Also, the
author is [working on the third
edition](https://www.obeythetestinggoat.com/book/preface.html) of the book.

Even though I was reading the printed book, the fact that at the same time it
was freely available online made the experience much easier in respect of
following links, making notes and navigating around quite a big volume of dense
material.

The lecture of the book made me follow the trail to where the author had
opportunity to practice Test Driven Development, Pair Programming and Extreme
Programming in general and I joined [the
company](https://www.pythonanywhere.com/about/company_details/) where the book
was born.

After 2017, Harry wrote [another book](https://www.cosmicpython.com/), this time
about his experience with software architecture in another organization. Even a
not very diligent reader could notice that his opinions had evolved. For those
who would like to follow the evolution, I would recommend his [Pycon 2020 talk
about mocks](https://youtu.be/rk-f3B-eMkI?t=9).

As you see I am not adhering to [the little style that I started my blog
with](obligatory-metablogging-post.html). Truthfully, that post was written
few years ago before I had that weird idea, but there are more little posts on
the way. I hope that the gap between conception and completion isn't as wide as
it was for this one.
