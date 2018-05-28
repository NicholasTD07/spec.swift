# spec.swift


<p align="center">

[![Travis](https://img.shields.io/travis/NicholasTD07/spec.swift.svg)](https://travis-ci.org/NicholasTD07/spec.swift/)
[![Codecov](https://img.shields.io/codecov/c/github/NicholasTD07/spec.svg)](https://codecov.io/gh/NicholasTD07/spec.swift)
[![GitHub license](https://img.shields.io/github/license/NicholasTD07/spec.swift.svg)](https://github.com/NicholasTD07/spec.swift/blob/master/LICENSE)
[![Carthage](https://img.shields.io/badge/Carthage-compatible-brightgreen.svg)](https://github.com/Carthage/Carthage)
[![Swift 4](https://img.shields.io/badge/Swift-4-orange.svg)](https://swift.org/)
[![Swift 3.1](https://img.shields.io/badge/Swift-3.1-orange.svg)](https://swift.org/)

</p>

Pure Swift BDD framework

## What can it do?

Runs the set up hooks (`before`, `after`) and also the tests.


**Matchers**

It can do these:

```swift
let love = false

expect(love).to.beTrue() // fails
expect(love).to.beTrue().toFail() // expected failure

let dock: [Icon] = ["📔", "🎵", "📷"] // real apps!
expect(dock).toNot.beEmpty()

let shopping = ToDo("Buy milk")
let todos: [ToDo] = [ shopping ]
expect(todos).to.contain(shopping)
```

and also these:

```swift
expect(42) == 42
expect(42) != 2017

// Also, the above works for values wrapped in Optional
let optional: Int? = 42
expect(optional) == 42

expect(["an array"]).to.beEmpty()
expect(["an array"]).to.contain("another array")
```

More matchers coming soon!

### What it cannot do?

**Async Tests**

Nope. Not these. Not now.

## Usage

### Installation

#### Swift Package Manager

Include it as a dependency in the `Package.swift` file:

```swift
let package = Package(
    name: "Your Package",
    dependencies: [
        .Package(url: "https://github.com/NicholasTD07/spec.swift.git", majorVersion: 1),
    ]
)
```

#### Carthage

Add this line to your `Cartfile`:

```
github "NicholasTD07/spec.swift" ~> 1.0.0
```

### Testing with spec.swift

```swift
import XCTest
import spec

func testCat() {
    describe("Cat") {
        var cat: Cat!

        $0.before { cat = Cat() }

        $0.it("did not eat") { expect(cat.actions).to.beEmpty() }

        $0.context("when being fed") {
            $0.before { cat.feed(.fish) }
            $0.it("eats") { expect(cat.actions).to.contain(.eat(.fish)) }
            $0.it("meows") { expect(cat.actions.last) == .meow }
        }

        $0.after { cat.sleep() }

        $0.it("did not sleep") { expect(cat.actions).to.beEmpty() }
    }
}

class SomeTests: XCTestCase {
    func testExample() {
        testCat()
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
```

### Note: the order of execution

For each example (created by calling `it`), `spec.swift` will call all the
`before` blocks before the `it` block (within the same `describe` method call).

## Try it out

1. Clone this repo
2. Have Swift 3 installed (if you haven't already got it - you should)
3. `cd` into this repo's path
4. `swift test`

You should see something like this.

```
.......e......eeee
18 examples, 5 failed (5 expected), 13 passed.
```

This is proof for all the setup, teardown and also the tests are run.
Also the test result reporter is working properly.

You can also add or change the tests in the `specTests.swift` file.

## Git workflow

I'd like to keep the branch/history graph as simple as it can be. So,

only merge branches with "Rebase and merge" option. OR,

do it in cli with `git merge --ff-only feature-branch`

## LICENSE

spec.swift is released under the MIT license. See [LICENSE](LICENSE) for details.
