# spec.swift

## Usage

Coming soon

## Try it out

1. Clone the repo
2. Have Swift 3 installed
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
