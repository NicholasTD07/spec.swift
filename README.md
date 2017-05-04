# spec.swift

Pure Swift BDD framework

## What can it do?

Runs the set up hooks (`before`, `after`) and also the tests.


**Matchers**

It does verify things now. Just not all the following though...

```swift
let love = false
expect(love).to.beTrue()

let dock: [Icon] = ["📔", "🎵", "📷"] // real apps!
expect(dock).to.beEmpty()

let shopping = ToDo("Buy milk")
let todos: [ToDo] = [ shopping ]
expect(todos).to.contain(shopping)
```

It can do these now:

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

Nope. Not those. Not now.

## Usage

Coming soon

## Try it out

1. Clone the repo
2. Have Swift 3 installed (if you haven't already got it - you should)
3. `cd` into this repo's path
4. `swift test`

You should see something like this.

```
[[Cat, when being fed, eats], [Cat, when being fed, meows], [Cat, did not sleep]]
eat
meow
sleep
eat
meow
sleep
sleep
[[Cat, when being fed, eats passed], [Cat, when being fed, meows passed], [Cat, did not sleep passed]]
```

This is proof for all the setup, teardown and also the tests are run.

First line is printed by `./Sources/spec.swift`, the `atexit` closure (line 94).
All lines after that are printed by `./Tests/specTests/specTests.swift` the
`Cat.did` method (line 26) except the last line. That's my pseudo test report
before I have time to make a fancy one.

You can also add or change the tests in the `specTests.swift` file.

## Git workflow

I'd like to keep the branch/history graph as simple as it can be. So,

only merge branches with "Rebase and merge" option. OR,

do it in cli with `git merge --ff-only feature-branch`

## LICENSE

spec.swift is released under the MIT license. See [LICENSE](LICENSE) for details.
