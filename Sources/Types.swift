import Foundation

enum Either<Left, Right> {
    case left(Left)
    case right(Right)
}

typealias Step = Either<Context, Test>
typealias Group = [Step]
typealias ResultStep = Either<String, TestResult>
typealias ResultGroup = [ResultStep]

public struct Test {
    internal let name: String
    internal let closure: () -> TestResult.State
}

public class Context {
    internal let name: String
    internal var befores = [() -> Void]()
    internal var afters = [() -> Void]()


    internal init(name: String) {
        self.name = name
    }

    public func before(_ before: @escaping () -> Void) {
        befores.append(before)
    }

    public func after(_ after: @escaping () -> Void) {
        afters.append(after)
    }

    public func context(_ name: String, _ closure: (Context) -> Void) {
        guard !currentGroup.isEmpty else {
            // Only publicly accessible way to create `Context`
            // is to call the global `describe` func
            // and that adds the created context to currentGroup
            fatalError("Impossible Error...")
        }

        let context = Context(name: name)

        currentGroup.append(.left(context))

        closure(context)

        _ = currentGroup.popLast()
    }

    public func it(_ name: String, _ closure: @escaping () -> TestResult.State) {
        guard !currentGroup.isEmpty else {
            // Only publicly accessible way to create `Context`
            // is to call the global `describe` func
            // and that adds the created context to currentGroup
            fatalError("Impossible Error...")
        }

        var group = currentGroup
        let test = Test(name: name, closure: closure)

        group.append(.right(test))

        groups.append(group)
    }
}

public struct Expression<T> {
    let expression: () -> T
    /* let location: */

    var actual: T { return expression() }

    public var to: Expression { return self }
}

public struct TestResult {
    let name: String
    let state: State

    public enum State {
        case passed
        case failed
        case typeMismatched // TODO: include the expected and actual types if possible
        // TODO: add a mismatching values?

        init(passed: Bool) {
            if passed {
                self = .passed
            } else {
                self = .failed
            }
        }
    }
}

