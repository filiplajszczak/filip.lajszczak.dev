title: Testing Dependency Injection with Mocks – Notes on the Margin of Chapter 3 of Architecture Patterns with Python
date: 2025-02-13 08:00
tags: tdd, python, book, pytest
style: plain
---

While working through [*Architecture Patterns with
Python*](https://www.cosmicpython.com/)
by [Harry J.W. Percival](https://github.com/hjwp)
and [Bob Gregory](https://github.com/bobthemighty), I came
across [Chapter 3, “A Brief Interlude: On Coupling and Abstractions.”](https://www.cosmicpython.com/book/chapter_03_abstractions.html)
It’s a short but thought-provoking essay on decoupling in software design,
particularly through the strategic use of abstractions in tests.

![Architecture Patterns with Python - Chapter 3](static/images/chapter-3.png)

One argument that stood out is the authors’ caution that ‘mocking is a code
smell’ when used excessively. The
authors warn against patching in tests, suggesting specialized fakes and the use
of dependency injection as more flexible alternatives.

While I agree with the general principle, I’d like to offer a slightly different
perspective: sometimes, mocks are the perfect tool for the job as long as we use
them responsibly.

Harry’s first book, [*Test-Driven Development with
Python*](https://www.obeythetestinggoat.com/), leaned heavily
toward [London-style TDD](https://paulbellamy.com/2018/12/testing-with-intent-5-two-schools-of-tdd),
which often involves extensive patching. In my
previous [post about Harry's TDD book](https://filip.lajszczak.dev/test-driven-development-with-python-revisited.html),
I noted how his views on testing evolved in this second book (influence of the
co-author Bob Gregory is explicitly mentioned), reflecting his
architectural experiences in a new organization.

For those interested in tracing this shift in thinking, I highly
recommend
his [PyCon 2020 talk on mocks](https://www.youtube.com/watch?v=rk-f3B-eMkI),
which echoes many of the ideas explored in Chapter 3.

#### Decoupling a File Synchronization Function (Book Example)

I would encourage you to read the book to get the full context (it's
available [online for free](https://www.cosmicpython.com/book/preface.html)) 
— or at least the third chapter. But here’s a brief summary of the idea.

The authors illustrate the concepts of decoupling and abstractions with
a toy example of a file synchronization function. The [first naïve
implementation](https://www.cosmicpython.com/book/chapter_03_abstractions.html#_abstracting_state_aids_testability)
is tightly coupled to the filesystem and is tested using end-to-end tests.
They then demonstrate how to decouple the function from the filesystem, first by
[separating logic from actions](https://www.cosmicpython.com/book/chapter_03_abstractions.html#_implementing_our_chosen_abstractions),
and later by introducing an [abstract filesystem interface and
Dependency Injection](https://www.cosmicpython.com/book/chapter_03_abstractions.html#_testing_edge_to_edge_with_fakes_and_dependency_injection).
Although end-to-end tests remain the final line of defense (and are still
necessary), most of the business logic can be covered by more focused unit tests.

One of the key insights from *Architecture Patterns with Python* is its 
emphasis on Domain-Driven Design (DDD) principles. If you’re unfamiliar with
DDD, the main idea is to keep business rules at the core of the application
and treat infrastructure (like file I/O) as a separate concern. By doing this,
we avoid tangling domain logic with external details, which makes the code
easier to maintain. The “toy example” of syncing files in Chapter 3 demonstrates
how and why we create these boundaries, underscoring the importance of clear
abstractions.

Let's also remind ourselves why we care
about [coupling](https://en.wikipedia.org/wiki/Coupling_(computer_programming))
and [cohesion](https://en.wikipedia.org/wiki/Cohesion_(computer_science)). When
different parts of the codebase depend too closely on each other’s internal
implementation, even a small change can have unintended ripple effects.
Well-structured code, however, should be cohesive - each module or component has
a clear, focused responsibility. Abstractions introduce seams in the code so we
can substitute dependencies without affecting the
rest of the system. For instance, a class or function responsible for filesystem
operations can be designed so that we can swap it with a test-friendly version
when needed. The more we rely on these well-defined boundaries, the less we
have to resort to patching deeply nested functions in tests. Instead, our tests
can focus on high-level behavior and domain logic, making them more robust,
maintainable, and aligned with a well-structured architecture.


#### Testing with a Dedicated Fake

The authors suggest that instead of using mocks, we should create dedicated
fakes for our tests. A fake is a test double that implements a simplified
version of a real dependency, like a filesystem or a database. Where the
code with side effects would read from or write to a real filesystem, the
fake would store the actions, allowing us to assert on them later.

Let's take a look at the example from the book. The "real" filesystem class:

```python
class FileSystem:

    def read(self, path):
        return read_paths_and_hashes(path)

    def copy(self, source, dest):
        shutil.copyfile(source, dest)

    def move(self, source, dest):
        shutil.move(source, dest)

    def delete(self, dest):
        os.remove(dest)
```

is replaced in tests with a fake:

```python
class FakeFilesystem:
    def __init__(self, path_hashes):
        self.path_hashes = path_hashes
        self.actions = []

    def read(self, path):
        return self.path_hashes[path]

    def copy(self, src, dest):
        self.actions.append(('COPY', src, dest))

    def move(self, src, dest):
        self.actions.append(('MOVE', src, dest))

    def delete(self, dest):
        self.actions.append(('DELETE', dest))
```

making the tests that look like that:

```python
def test_when_a_file_exists_in_the_source_but_not_the_destination():
    fakefs = FakeFilesystem(
        {
            '/src': {"hash1": "fn1"},
            '/dst': {},
        }
    )
    sync('/src', '/dst', filesystem=fakefs)
    assert fakefs.actions == [
        ("COPY", Path("/src/fn1"), Path("/dst/fn1"))
    ]
```

(It's worth to mention that the example in the print version of the book is
different, and it's the updated online version, that I'm quoting here)

A key advantage of using a dedicated fake like `FakeFilesystem` is that it
makes the clear distinction between the fake and a real filesystem,
ensuring that tests remain predictable. It also improves readability, as tests
written with domain-specific fakes often resemble real-world usage, making them
easier to understand. Additionally, newcomers to the project can quickly grasp
the intention behind a `FakeFilesystem` class without needing to dig into
implementation details.

However, there are downsides. Over time, these fakes can
multiply—especially in large codebases with many different domains—leading to a
growing collection of specialized test doubles, each with its own maintenance
overhead. While this approach can be useful, it can also become overkill, adding
verbosity and requiring a significant amount of [boilerplate](https://en.wikipedia.org/wiki/Boilerplate_code).
Fortunately, there is a DRYer alternative that address that.

#### Using Mock as a Swiss Army Knife

We start with realization that mocks have all we need to do similar job as
dedicated fakes, and that use of them does not have to be related to patching.

So, we have a function `sync(source, destination, filesystem)`, which reads
files from a source directory, compares them with a destination directory, and
decides whether to copy, move, or delete them. Here’s how we can test it using
`unittest.mock.Mock` (or `pytest`’s `mocker` fixture):

```python
def test_when_a_file_exists_in_the_source_but_not_the_destination(
        mocker
):
    fakefs = mocker.Mock(
        read=lambda path: {
            '/src': {"hash1": "fn1"},
            '/dst': {},
        }[path]
    )

    sync('/src', '/dst', filesystem=fakefs)

    fakefs.copy.assert_called_once_with(
        Path("/src/fn1"), Path("/dst/fn1")
    )
    fakefs.move.assert_not_called()
    fakefs.delete.assert_not_called()


def test_when_a_file_has_been_renamed_in_the_source(
        mocker
):
    fakefs = mocker.Mock(
        read=lambda path: {
            '/src': {"hash1": "fn1"},
            '/dst': {"hash1": "fn2"},
        }[path]
    )

    sync('/src', '/dst', filesystem=fakefs)

    fakefs.move.assert_called_once_with(
        Path("/dst/fn2"), Path("/dst/fn1")
    )
    fakefs.copy.assert_not_called()
    fakefs.delete.assert_not_called()
```
*(see commit [5a291ca](https://github.com/filiplajszczak/cosmic-python-code/commit/5a291cae789baf2305c169600ffb0bd37d8d613d) 
in the fork of the example repo)*

In these tests, we inject a mock into `sync`, ensuring that no real filesystem
operations take place. The behavior of `fakefs.read` is defined using a simple
lambda, allowing us to control its output based on the provided paths. This
setup enables us to make precise assertions about how the system interacts with
the filesystem—checking that `copy`, `move`, and `delete` are called exactly as
expected. The result is a clean and focused test, though in more complex
scenarios—like intricate permission checks—you might find a specialized fake
more appropriate. (See ‘When a Dedicated Fake
Shines’ below.) More importantly, we avoid patching internal function calls 
within `sync`, keeping our test setup simple and maintaining clear 
separation between dependencies and business logic.

Note that in testing terminology, ‘fakes’ typically have simplified working
logic (e.g., an in-memory version of a database), while ‘mocks’ are
interaction-based test doubles that verify how they are called. Although
Python’s `Mock` class can be used to implement a ‘fake-like’ behavior, they are
not strictly the same concept.

#### Refactoring with a Pytest Fixture

As soon as you notice a repeating pattern in your tests—like configuring a mock
in exactly the same way in multiple places—this is a good indicator that it can
be refactored to a [pytest
fixture](https://docs.pytest.org/en/7.1.x/explanation/fixtures.html#about-fixtures).
Here’s an example where we move the
creation of our mock “filesystem” into a helper fixture called `get_fakefs`:

```python
@pytest.fixture
def get_fakefs(mocker):
    def _get_fakefs(paths):
        return mocker.Mock(read=lambda path: paths[path])

    return _get_fakefs


def test_when_a_file_exists_in_the_source_but_not_the_destination(
        get_fakefs
):
    fakefs = get_fakefs(
        {
            '/src': {"hash1": "fn1"},
            '/dst': {},
        }
    )

    sync('/src', '/dst', filesystem=fakefs)

    fakefs.copy.assert_called_once_with(
        Path("/src/fn1"), Path("/dst/fn1")
    )
    fakefs.move.assert_not_called()
    fakefs.delete.assert_not_called()


def test_when_a_file_has_been_renamed_in_the_source(get_fakefs):
    fakefs = get_fakefs(
        {
            '/src': {"hash1": "fn1"},
            '/dst': {"hash1": "fn2"},
        }
    )

    sync('/src', '/dst', filesystem=fakefs)

    fakefs.move.assert_called_once_with(
        Path("/dst/fn2"), Path("/dst/fn1")
    )
    fakefs.copy.assert_not_called()
    fakefs.delete.assert_not_called()
```
*(see commit [7c5ca01](https://github.com/filiplajszczak/cosmic-python-code/commit/7c5ca01e406eb1208fee79a3baffecefcea5b92d)
in the fork of the example repo)*

While I realize that using the same mock in just two tests isn’t always enough
to justify refactoring—typically, three occurrences would be the minimum—I
wanted to stay close to the minimalistic example from the book to illustrate the
idea. Extracting the mock into a fixture improves readability and reuse by
defining the mock logic in a single place, allowing each test to simply request
a `fakefs` configured with the necessary data. It also enhances maintainability
since any changes to how the mock is constructed, such as adding default
behaviors for `copy` or `delete`, only need to be made once in the fixture.
Finally, it results in cleaner tests, with each one focusing on its specific
scenario and assertions rather than being cluttered with repetitive setup code.

#### Are Abstract Base Classes Overkill?

One valid concern with the approach of using mocks is that it doesn’t
enforce interface parity between the real and fake objects by default. We
can use another Python feature to address this issue and it would nicely fit
other patterns suggested in the book.

In the book, the authors use [Abstract Base
Classes](https://docs.python.org/3/library/abc.html) to demonstrate idea of
an interface. Good example is [Chapter
2](https://www.cosmicpython.com/book/chapter_02_repository.html), where they
[implement](https://www.cosmicpython.com/book/chapter_02_repository.html#_the_repository_in_the_abstract)
`AbstractRepository` and base both `SqlAlchemyRepository` and `FakeRepository`
on it. The good news is that Mock is perfectly capable of implementing an
ABC thanks to the `spec` argument. It makes sure that the mock object only
allows method calls that are defined in the ABC.

Here’s how we can define an ABC for our filesystem interface:

```python
class AbstractFileSystem(abc.ABC):
    @abc.abstractmethod
    def read(self, path):
        raise NotImplementedError

    @abc.abstractmethod
    def copy(self, source, dest):
        raise NotImplementedError

    @abc.abstractmethod
    def move(self, source, dest):
        raise NotImplementedError

    @abc.abstractmethod
    def delete(self, dest):
        raise NotImplementedError
```

Then our real `FileSystem` could implement it, and we can use it in our test
fixture:

```python
@pytest.fixture
def get_fakefs(mocker):
    def _get_fakefs(paths):
        return mocker.Mock(
            read=lambda path: paths[path],
            spec=AbstractFileSystem
        )

    return _get_fakefs
```
*(see commit [9ad5d83](https://github.com/filiplajszczak/cosmic-python-code/commit/9ad5d839b46761bd1b203666316a2ad4e9b2ddee)
in the fork of the example repo)*

And that's all. Now, if someone tries to call a method that is not
defined in the ABC, our test will fail.

Using an ABC adds a layer of formality and can prevent drift between production
and test doubles. However, in smaller projects or prototypes, ABCs might be more
overhead than they’re worth. The decision depends on how stable and shared your
interfaces are.

#### Isn’t Mocking a Code Smell?

In *Architecture Patterns with Python*, the authors caution that mocking can be
a code smell, especially when you patch functions you don’t own deep inside your
code. That often signals a design that’s too tightly coupled to implementation
details. However, injecting a mock at a clear boundary is different: it’s
simply a form of dependency injection that keeps your tests clear and your
dependencies replaceable.

There is a key difference between patching an internal function (for example,
`os.remove`) versus passing a mock `filesystem` object to `sync()`. The former
can lead to brittle tests whenever internals change, while the latter ensures
your design remains decoupled. In short, the problem isn’t mocking itself, but
where and how it’s used.

#### When a Dedicated Fake Shines

Of course, this isn’t a black-and-white issue - there are plenty of cases
where a specialized fake is the better choice. If your filesystem abstraction
involves more than just basic reading and copying, such as versioning, 
concurrency handling, or intricate permission rules, a well-defined fake can 
more accurately represent that logic while keeping your tests descriptive. 
Likewise, if you find yourself repeatedly setting up the same mocks or 
recreating dictionary-based test data, a structured fake can help reduce 
duplication and make tests easier to follow.

Once your abstraction starts capturing domain rules (e.g., complex permissions
or concurrency details), rewriting all that logic in a mock’s lambda can get
messy. A robust fake that implements this logic (e.g., an in-memory model of
your real system) might be clearer and more maintainable in the long run.

Team preferences also play a role - some developers may find that a
dedicated `FakeFilesystem` makes the intent of tests clearer, especially for
newcomers who can immediately understand its purpose. Ultimately, context is
everything - while mocks can keep tests simple and quick to write, more complex
domain problems may benefit from a more robust, reusable fake, but necessity
to have one might be considered a code smell itself.

#### No One-Size-Fits-All Approach

There’s no one-size-fits-all approach to testing. Some teams prefer a purely
mock-driven, London-style approach for speed and isolation, while others favor
fewer mocks and deeper integration tests (classical TDD). The ‘right’ approach
depends on your domain, codebase size, and performance constraints.

One of the things I appreciate most about Harry Percival and Bob Gregory’s work
is how they don’t just present rigid rules but instead encourage thoughtful
decision-making. Their discussion on coupling and abstractions isn’t about
banning mocks altogether but about helping developers make better choices for
long-term maintainability. Mocks function like a Swiss Army knife: they can be
misused in ways that create confusion, but when applied thoughtfully within a
well-structured design, they are a perfectly valid tool. In many cases, they
offer the simplest and most efficient way to keep tests clean and maintainable.
Before investing in a fully developed fake class, it’s worth considering whether
a single, well-defined mock—perhaps wrapped in a Pytest fixture—can achieve the
same goal with less complexity.