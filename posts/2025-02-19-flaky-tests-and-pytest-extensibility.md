title: Exposing Flaky Tests with Pytest Rerunfailures
date: 2025-02-19 22:00
tags: testing, pytest, flakiness, plugins, python
style: plain
---

When you have a large suite of end-to-end
tests, [flaky tests](https://docs.pytest.org/en/stable/explanation/flaky.html)
are almost inevitable. Relying on external services can cause unexpected
failures. Similarly, browsers are unpredictable, networks are unreliable, and
sometimes things just break. While it's worthwhile to invest in making tests
more robust, there are diminishing returns—at some point, you have to accept the
occasional random failure.

Sometimes, all you need is to retry the test. In the context of pytest, there
are several plugins available to handle
retries. [Brian Okken](https://testandcode.com/) gave a great overview of
various options in his short podcast
episode [#213: Repeating Tests](https://testandcode.com/213). That episode
inspired me to explore this problem in more depth and find a solution that fits
my needs.

Because it's useful to distinguish truly flaky tests from those that
consistently fail for a valid reason, I tried
out [pytest-rerunfailures](https://pypi.org/project/pytest-rerunfailures/). It
retries failing tests until they either pass or reach the maximum number of
retries, and it also reports how many retries were needed in the test
summary — just what I was looking for.

However, I also wanted a clear indication when the test suite succeeded only
after retries. By default, pytest-rerunfailures doesn't make this fact obvious
to a continuous integration system, since it doesn’t report this “flaky success”
in its exit code. I decided to extend the plugin and introduce a
`--fail_on_flaky` option to return a custom exit code if tests only pass after
retries.

One of the best things about pytest is its extensibility: nearly everything is
pluggable and customizable. In this case, the key hooks
were [pytest_addoption](https://docs.pytest.org/en/stable/reference/reference.html#pytest.hookspec.pytest_addoption)
and [pytest_sessionfinish](https://docs.pytest.org/en/stable/reference/reference.html#pytest.hookspec.pytest_sessionfinish).
These let
me [add the new option and modify the exit code](https://github.com/pytest-dev/pytest-rerunfailures/pull/276)
if any tests were retried. More recently, this feature has
been [enhanced even further](https://github.com/pytest-dev/pytest-rerunfailures/pull/288).

Extending pytest was a great experience overall. I also [created some basic
documentation](https://github.com/pytest-dev/pytest-rerunfailures/pull/283) for
the plugin, which was missing at the time. It was a good opportunity to practice
some sphinx-fu.
