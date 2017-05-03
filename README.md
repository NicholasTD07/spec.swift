# spec.swift

Pure Swift BDD framework

## What can it do?

Runs the set up hooks (`before`, `after`) and also the tests.

### What it cannot do?

**Matchers**

It does not verify things yet. e.g.

```swift
let love = false
expect(love).isTrue()

let dock: [Icon] = ["📔", "🎵", "📷"] // real apps!
expect(dock).isEmpty()

let shopping = ToDo("Buy milk")
let todos: [ToDo] = [ shopping ]
expect(todos).contains(shopping)
```

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
[[Cat, when being fed, eats], [Cat, when being fed, meows], [Cat, when being fed, did not sleep]]
eat
meow
sleep
eat
meow
sleep
eat
meow
sleep
```

First line is printed by `./Sources/spec.swift`, the `atexit` closure (line 94).
All lines after that are printed by `./Tests/specTests/specTests.swift` the
`Cat.did` method (line 26)

You can also add or change the tests in the `specTests.swift` file. However, as
of now, there is no support for matchers, e.g. `expect(this).isAmazing()`.

## Git workflow

I'd like to keep the branch/history graph as simple as it can be. So,

only merge branches with "Rebase and merge" option. OR,

do it in cli with `git merge --ff-only feature-branch`

## LICENSE

spec.swift is released under the MIT license. See [LICENSE](LICENSE) for details.
